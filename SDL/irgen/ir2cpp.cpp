// ir2cpp (LLVM 14): reads an IR module and prints a C++ program that rebuilds
// it with IRBuilder and runs it in MCJIT ("IR generator" assignment).
//
// Only the entry function and what it can reach (callees, globals) are
// emitted. External functions are resolved to host functions declared in a C
// header (--header) via InstallLazyFunctionCreator.
//
// Dropped on purpose, since none of them change semantics: attributes,
// metadata attachments (!tbaa, !llvm.loop, ...), lifetime/noalias/dbg
// intrinsics and instructions that only fed them.

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/ModuleSlotTracker.h"
#include "llvm/IR/Operator.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

#include <cstdio>
#include <cstdlib>
#include <set>
#include <string>
#include <tuple>

using namespace llvm;

namespace {

cl::opt<std::string> InputFile(cl::Positional, cl::Required,
                               cl::desc("<input .ll/.bc>"));
cl::opt<std::string> OutputFile("o", cl::init("-"), cl::value_desc("file"),
                                cl::desc("Output C++ file (default: stdout)"));
cl::opt<std::string> EntryName("entry", cl::init("app"),
                               cl::desc("Function to rebuild and run"));
cl::opt<std::string> Header("header", cl::init("sim.h"),
                            cl::desc("C header declaring the external functions"));

[[noreturn]] void fail(const Twine &Msg, const Value *V = nullptr) {
  errs() << "ir2cpp: " << Msg;
  if (V) {
    errs() << ": ";
    V->print(errs());
  }
  errs() << '\n';
  std::exit(1);
}

std::string quote(StringRef S) {
  std::string Out = "\"";
  for (unsigned char C : S) {
    if (C == '"' || C == '\\' || C == '?') {
      Out += '\\';
      Out += C;
    } else if (C >= 0x20 && C < 0x7F) {
      Out += C;
    } else {
      // Octal, not \x: a hex escape would swallow following hex digits.
      char Buf[8];
      std::snprintf(Buf, sizeof Buf, "\\%03o", C);
      Out += Buf;
    }
  }
  return Out + "\"";
}

std::string sanitize(StringRef S) {
  std::string Out;
  for (char C : S)
    Out += isAlnum(C) ? C : '_';
  return Out;
}

// One line of IR as a comment: no metadata (it is not rebuilt), bounded length.
std::string irComment(const Value &V) {
  std::string Text;
  raw_string_ostream TOS(Text);
  V.print(TOS);
  TOS.flush();
  size_t Start = Text.find_first_not_of(' ');
  Text = Start == std::string::npos ? "" : Text.substr(Start);
  size_t MD = Text.find(", !");
  if (MD != std::string::npos)
    Text.resize(MD);
  if (Text.size() > 150)
    Text = Text.substr(0, 147) + "...";
  while (!Text.empty() && Text.back() == '\\')
    Text.pop_back();
  return "// " + Text;
}

// The "define ..."/"declare ..." line of a function.
std::string functionHeader(const Function &F) {
  std::string Text;
  raw_string_ostream TOS(Text);
  F.print(TOS);
  TOS.flush();
  StringRef Rest(Text);
  while (!Rest.empty()) {
    StringRef Line, Tail;
    std::tie(Line, Tail) = Rest.split('\n');
    if (Line.startswith("define") || Line.startswith("declare"))
      return "// " + Line.str();
    Rest = Tail;
  }
  return "// @" + F.getName().str();
}

const char *opcodeName(unsigned Op) {
  switch (Op) {
#define HANDLE_INST(N, OPC, CLASS)                                             \
  case N:                                                                      \
    return #OPC;
#include "llvm/IR/Instruction.def"
  default:
    fail("unknown opcode " + Twine(Op));
  }
}

const char *linkageName(GlobalValue::LinkageTypes L) {
  switch (L) {
  case GlobalValue::ExternalLinkage: return "GlobalValue::ExternalLinkage";
  case GlobalValue::AvailableExternallyLinkage: return "GlobalValue::AvailableExternallyLinkage";
  case GlobalValue::LinkOnceAnyLinkage: return "GlobalValue::LinkOnceAnyLinkage";
  case GlobalValue::LinkOnceODRLinkage: return "GlobalValue::LinkOnceODRLinkage";
  case GlobalValue::WeakAnyLinkage: return "GlobalValue::WeakAnyLinkage";
  case GlobalValue::WeakODRLinkage: return "GlobalValue::WeakODRLinkage";
  case GlobalValue::AppendingLinkage: return "GlobalValue::AppendingLinkage";
  case GlobalValue::InternalLinkage: return "GlobalValue::InternalLinkage";
  case GlobalValue::PrivateLinkage: return "GlobalValue::PrivateLinkage";
  case GlobalValue::ExternalWeakLinkage: return "GlobalValue::ExternalWeakLinkage";
  case GlobalValue::CommonLinkage: return "GlobalValue::CommonLinkage";
  }
  fail("unknown linkage");
}

std::string predicateName(CmpInst::Predicate P) {
  std::string Name = CmpInst::isIntPredicate(P) ? "CmpInst::ICMP_" : "CmpInst::FCMP_";
  for (char C : CmpInst::getPredicateName(P))
    Name += toUpper(C);
  return Name;
}

// Shortest decimal literal that reads back to exactly the same value, or ""
// for inf/nan (those are emitted as raw bits).
std::string fpLiteral(const APFloat &V) {
  if (!V.isFinite())
    return "";
  bool IsFloat = &V.getSemantics() == &APFloat::IEEEsingle();
  double D = IsFloat ? V.convertToFloat() : V.convertToDouble();
  for (int Prec = 1; Prec <= 17; ++Prec) {
    char Buf[64];
    std::snprintf(Buf, sizeof Buf, "%.*g", Prec, D);
    double Back = std::strtod(Buf, nullptr);
    bool Same = IsFloat ? APFloat(static_cast<float>(Back)).bitwiseIsEqual(V)
                        : APFloat(Back).bitwiseIsEqual(V);
    if (!Same)
      continue;
    std::string Lit = Buf;
    if (Lit.find_first_of(".e") == std::string::npos)
      Lit += ".0";
    return Lit;
  }
  return "";
}

std::string apintExpr(const APInt &V) {
  unsigned W = V.getBitWidth();
  if (W <= 64)
    return "APInt(" + std::to_string(W) + ", 0x" + utohexstr(V.getZExtValue()) + "ULL)";
  return "APInt(" + std::to_string(W) + ", \"" + toString(V, 16, false) + "\", 16)";
}

const char *fpSemantics(const Type *T) {
  if (T->isHalfTy()) return "IEEEhalf";
  if (T->isBFloatTy()) return "BFloat";
  if (T->isFloatTy()) return "IEEEsingle";
  if (T->isDoubleTy()) return "IEEEdouble";
  if (T->isX86_FP80Ty()) return "x87DoubleExtended";
  if (T->isFP128Ty()) return "IEEEquad";
  if (T->isPPC_FP128Ty()) return "PPCDoubleDouble";
  fail("unsupported floating-point type");
}

bool isHintIntrinsic(const Instruction &I) {
  auto *II = dyn_cast<IntrinsicInst>(&I);
  if (!II)
    return false;
  switch (II->getIntrinsicID()) {
  case Intrinsic::lifetime_start:
  case Intrinsic::lifetime_end:
  case Intrinsic::experimental_noalias_scope_decl:
  case Intrinsic::dbg_declare:
  case Intrinsic::dbg_value:
  case Intrinsic::dbg_label:
    return true;
  default:
    return false;
  }
}

template <typename RangeT, typename FnT>
std::string join(const RangeT &R, FnT Fn) {
  std::string Out;
  for (const auto &X : R) {
    if (!Out.empty())
      Out += ", ";
    Out += Fn(X);
  }
  return Out;
}

class Emitter {
public:
  Emitter(const Module &M) : M(M), MST(&M) {}

  std::string run(const Function &Entry);

private:
  const Module &M;
  ModuleSlotTracker MST;
  std::string Buf;
  raw_string_ostream OS{Buf};

  SetVector<const GlobalValue *> Used; // reachable from the entry, in discovery order
  DenseSet<const Instruction *> Dropped;
  DenseMap<const Value *, std::string> Names;
  std::set<std::string> Taken;
  DenseSet<const Value *> Defined; // locals already emitted in the current function

  void collect(const Function &Entry);
  void addConstantRefs(const Constant *C, SmallVectorImpl<const GlobalValue *> &WL);
  void markDropped(const Function &F);

  std::string name(const Value *V);
  std::string uniqueName(const std::string &Base);
  std::string type(Type *T);
  std::string constant(const Constant *C);
  std::string constantData(const ConstantDataSequential *CDS);
  std::string value(const Value *V);
  std::string nameArg(const Value &V, bool Leading = true);

  void emitGlobal(const GlobalVariable &GV);
  void emitFunctionDecl(const Function &F);
  void emitFunctionBody(const Function &F);
  void emitInst(const Instruction &I);
  void emitMain(const Function &Entry);
};

void Emitter::addConstantRefs(const Constant *C,
                              SmallVectorImpl<const GlobalValue *> &WL) {
  if (auto *GV = dyn_cast<GlobalValue>(C)) {
    if (Used.insert(GV))
      WL.push_back(GV);
    return;
  }
  if (isa<BlockAddress>(C))
    fail("blockaddress is not supported", C);
  for (const Use &Op : C->operands())
    addConstantRefs(cast<Constant>(Op), WL);
}

// Hint intrinsics, then (to a fixpoint) side-effect-free instructions whose
// every user is dropped - e.g. the bitcast feeding llvm.lifetime.start.
void Emitter::markDropped(const Function &F) {
  for (const Instruction &I : instructions(F))
    if (isHintIntrinsic(I))
      Dropped.insert(&I);
  bool Changed = true;
  while (Changed) {
    Changed = false;
    for (const Instruction &I : instructions(F)) {
      if (Dropped.count(&I) || I.use_empty() || I.mayHaveSideEffects() ||
          I.isTerminator() || isa<PHINode>(I))
        continue;
      bool AllDropped = all_of(I.users(), [&](const User *U) {
        auto *UI = dyn_cast<Instruction>(U);
        return UI && Dropped.count(UI);
      });
      if (AllDropped) {
        Dropped.insert(&I);
        Changed = true;
      }
    }
  }
}

void Emitter::collect(const Function &Entry) {
  SmallVector<const GlobalValue *, 16> WL;
  Used.insert(&Entry);
  WL.push_back(&Entry);
  while (!WL.empty()) {
    const GlobalValue *GV = WL.pop_back_val();
    if (auto *F = dyn_cast<Function>(GV)) {
      if (F->isDeclaration())
        continue;
      markDropped(*F);
      for (const Instruction &I : instructions(*F)) {
        if (Dropped.count(&I))
          continue;
        for (const Use &Op : I.operands())
          if (auto *C = dyn_cast<Constant>(Op))
            addConstantRefs(C, WL);
      }
    } else if (auto *Var = dyn_cast<GlobalVariable>(GV)) {
      if (Var->hasInitializer())
        addConstantRefs(Var->getInitializer(), WL);
    } else {
      fail("aliases/ifuncs are not supported", GV);
    }
  }
}

std::string Emitter::uniqueName(const std::string &Base) {
  std::string Name = Base;
  for (unsigned N = 2; !Taken.insert(Name).second; ++N)
    Name = Base + "_" + std::to_string(N);
  return Name;
}

// g_<name> globals, f_<name> functions, bb<slot>/bb_<name> blocks,
// v<slot>/v_<name> arguments and instructions.
std::string Emitter::name(const Value *V) {
  auto It = Names.find(V);
  if (It != Names.end())
    return It->second;
  std::string Base;
  if (isa<Function>(V)) {
    Base = "f_" + sanitize(V->getName());
  } else if (isa<GlobalVariable>(V)) {
    Base = "g_" + sanitize(V->getName());
  } else {
    const char *Prefix = isa<BasicBlock>(V) ? "bb" : "v";
    if (V->hasName()) {
      Base = std::string(Prefix) + "_" + sanitize(V->getName());
    } else {
      int Slot = MST.getLocalSlot(V);
      Base = std::string(Prefix) + (Slot >= 0 ? std::to_string(Slot) : "tmp");
    }
  }
  return Names[V] = uniqueName(Base);
}

std::string Emitter::type(Type *T) {
  switch (T->getTypeID()) {
  case Type::VoidTyID:
    return "builder.getVoidTy()";
  case Type::HalfTyID:
    return "builder.getHalfTy()";
  case Type::BFloatTyID:
    return "builder.getBFloatTy()";
  case Type::FloatTyID:
    return "builder.getFloatTy()";
  case Type::DoubleTyID:
    return "builder.getDoubleTy()";
  case Type::IntegerTyID: {
    unsigned W = T->getIntegerBitWidth();
    if (W == 1 || W == 8 || W == 16 || W == 32 || W == 64 || W == 128)
      return "builder.getInt" + std::to_string(W) + "Ty()";
    return "builder.getIntNTy(" + std::to_string(W) + ")";
  }
  case Type::PointerTyID: {
    auto *PT = cast<PointerType>(T);
    std::string AS = PT->getAddressSpace() ? std::to_string(PT->getAddressSpace()) : "";
    if (PT->isOpaque())
      return "PointerType::get(ctx, " + (AS.empty() ? "0" : AS) + ")";
    return type(PT->getNonOpaquePointerElementType()) + "->getPointerTo(" + AS + ")";
  }
  case Type::ArrayTyID:
    return "ArrayType::get(" + type(T->getArrayElementType()) + ", " +
           std::to_string(T->getArrayNumElements()) + ")";
  case Type::FixedVectorTyID: {
    auto *VT = cast<FixedVectorType>(T);
    return "FixedVectorType::get(" + type(VT->getElementType()) + ", " +
           std::to_string(VT->getNumElements()) + ")";
  }
  case Type::StructTyID: {
    auto *ST = cast<StructType>(T);
    if (!ST->isLiteral())
      fail("named struct types are not supported: " + ST->getName());
    return "StructType::get(ctx, {" +
           join(ST->elements(), [&](Type *E) { return type(E); }) + "}, " +
           (ST->isPacked() ? "true" : "false") + ")";
  }
  case Type::FunctionTyID: {
    auto *FT = cast<FunctionType>(T);
    std::string VarArg = FT->isVarArg() ? "true" : "false";
    if (FT->getNumParams() == 0)
      return "FunctionType::get(" + type(FT->getReturnType()) + ", " + VarArg + ")";
    return "FunctionType::get(" + type(FT->getReturnType()) + ", {" +
           join(FT->params(), [&](Type *P) { return type(P); }) + "}, " + VarArg + ")";
  }
  default: {
    std::string S;
    raw_string_ostream TOS(S);
    T->print(TOS);
    fail("unsupported type " + TOS.str());
  }
  }
}

std::string Emitter::constantData(const ConstantDataSequential *CDS) {
  Type *ET = CDS->getElementType();
  bool IsVec = isa<ConstantDataVector>(CDS);
  std::string Cls = IsVec ? "ConstantDataVector" : "ConstantDataArray";
  unsigned N = CDS->getNumElements();

  if (!IsVec && ET->isIntegerTy(8)) {
    StringRef Raw = CDS->getRawDataValues();
    return "ConstantDataArray::getString(ctx, StringRef(" + quote(Raw) + ", " +
           std::to_string(Raw.size()) + "), false)";
  }
  std::string Elems;
  auto Add = [&](const std::string &E) {
    if (!Elems.empty())
      Elems += ", ";
    Elems += E;
  };
  if (ET->isIntegerTy()) {
    for (unsigned I = 0; I < N; ++I)
      Add(std::to_string(CDS->getElementAsInteger(I)) +
          (ET->isIntegerTy(64) ? "ULL" : ""));
    return Cls + "::get(ctx, ArrayRef<uint" +
           std::to_string(ET->getIntegerBitWidth()) + "_t>{" + Elems + "})";
  }
  if (ET->isFloatTy() || ET->isDoubleTy()) {
    bool AllFinite = true;
    for (unsigned I = 0; I < N; ++I) {
      std::string Lit = fpLiteral(CDS->getElementAsAPFloat(I));
      AllFinite &= !Lit.empty();
      Add(Lit + (ET->isFloatTy() ? "f" : ""));
    }
    if (AllFinite)
      return Cls + "::get(ctx, ArrayRef<" + (ET->isFloatTy() ? "float" : "double") +
             ">{" + Elems + "})";
    Elems.clear();
  }
  // Raw bits: half/bfloat, or float/double arrays holding inf/nan.
  unsigned W = ET->getPrimitiveSizeInBits();
  for (unsigned I = 0; I < N; ++I)
    Add("0x" + utohexstr(CDS->getElementAsAPFloat(I).bitcastToAPInt().getZExtValue()));
  return Cls + "::getFP(" + type(ET) + ", ArrayRef<uint" + std::to_string(W) +
         "_t>{" + Elems + "})";
}

std::string Emitter::constant(const Constant *C) {
  Type *T = C->getType();
  if (isa<GlobalValue>(C))
    return name(C);
  if (auto *CI = dyn_cast<ConstantInt>(C)) {
    unsigned W = CI->getBitWidth();
    if (W == 1)
      return std::string("builder.getInt1(") + (CI->isOne() ? "true" : "false") + ")";
    if (W == 8 || W == 16 || W == 32 || W == 64) {
      int64_t S = CI->getSExtValue();
      std::string Lit = S == INT64_MIN ? "INT64_MIN" : std::to_string(S);
      return "builder.getInt" + std::to_string(W) + "(" + Lit + ")";
    }
    return "ConstantInt::get(ctx, " + apintExpr(CI->getValue()) + ")";
  }
  if (auto *CF = dyn_cast<ConstantFP>(C)) {
    if (T->isFloatTy() || T->isDoubleTy()) {
      std::string Lit = fpLiteral(CF->getValueAPF());
      if (!Lit.empty())
        return "ConstantFP::get(" + type(T) + ", " + Lit + ")";
    }
    return std::string("ConstantFP::get(ctx, APFloat(APFloat::") + fpSemantics(T) +
           "(), " + apintExpr(CF->getValueAPF().bitcastToAPInt()) + "))";
  }
  if (isa<ConstantPointerNull>(C))
    return "ConstantPointerNull::get(cast<PointerType>(" + type(T) + "))";
  if (isa<PoisonValue>(C))
    return "PoisonValue::get(" + type(T) + ")";
  if (isa<UndefValue>(C))
    return "UndefValue::get(" + type(T) + ")";
  if (isa<ConstantAggregateZero>(C))
    return "ConstantAggregateZero::get(" + type(T) + ")";
  if (auto *CDS = dyn_cast<ConstantDataSequential>(C))
    return constantData(CDS);
  if (isa<ConstantAggregate>(C)) {
    std::string Elems = join(C->operands(), [&](const Use &U) {
      return constant(cast<Constant>(U));
    });
    if (isa<ConstantArray>(C))
      return "ConstantArray::get(cast<ArrayType>(" + type(T) + "), {" + Elems + "})";
    if (isa<ConstantStruct>(C))
      return "ConstantStruct::get(cast<StructType>(" + type(T) + "), {" + Elems + "})";
    return "ConstantVector::get({" + Elems + "})";
  }
  if (auto *CE = dyn_cast<ConstantExpr>(C)) {
    unsigned Op = CE->getOpcode();
    if (Op == Instruction::GetElementPtr) {
      auto *GEP = cast<GEPOperator>(CE);
      std::string Idx;
      if (CE->getNumOperands() == 2)
        Idx = constant(CE->getOperand(1));
      else
        Idx = "{" + join(drop_begin(CE->operands()), [&](const Use &U) {
                return constant(cast<Constant>(U));
              }) + "}";
      return "ConstantExpr::getGetElementPtr(" + type(GEP->getSourceElementType()) +
             ", " + constant(CE->getOperand(0)) + ", " + Idx + ", " +
             (GEP->isInBounds() ? "true" : "false") + ")";
    }
    if (CE->isCast())
      return std::string("ConstantExpr::getCast(Instruction::") + opcodeName(Op) +
             ", " + constant(CE->getOperand(0)) + ", " + type(T) + ")";
    if (Instruction::isBinaryOp(Op))
      return std::string("ConstantExpr::get(Instruction::") + opcodeName(Op) + ", " +
             constant(CE->getOperand(0)) + ", " + constant(CE->getOperand(1)) + ", " +
             std::to_string(CE->getRawSubclassOptionalData()) + ")";
    if (CE->isCompare())
      return "ConstantExpr::getCompare(" +
             predicateName(static_cast<CmpInst::Predicate>(CE->getPredicate())) + ", " +
             constant(CE->getOperand(0)) + ", " + constant(CE->getOperand(1)) + ")";
    if (Op == Instruction::Select)
      return "ConstantExpr::getSelect(" + constant(CE->getOperand(0)) + ", " +
             constant(CE->getOperand(1)) + ", " + constant(CE->getOperand(2)) + ")";
  }
  fail("unsupported constant", C);
}

std::string Emitter::value(const Value *V) {
  if (auto *C = dyn_cast<Constant>(V))
    return constant(C);
  if (isa<Instruction>(V) && !Defined.count(V))
    fail("operand used before its definition", V);
  if (isa<Instruction>(V) || isa<Argument>(V) || isa<BasicBlock>(V))
    return name(V);
  fail("unsupported operand (metadata/inline asm?)", V);
}

// `, "name"` for named values; unnamed ones get the next %N on print anyway.
std::string Emitter::nameArg(const Value &V, bool Leading) {
  if (!V.hasName())
    return "";
  return (Leading ? ", " : "") + quote(V.getName());
}

void Emitter::emitGlobal(const GlobalVariable &GV) {
  if (GV.isThreadLocal() || GV.getAddressSpace() != 0)
    fail("thread-local/addrspace globals are not supported", &GV);
  std::string N = name(&GV);
  OS << "  " << irComment(GV) << '\n'
     << "  GlobalVariable *" << N << " = new GlobalVariable(\n"
     << "      *module, " << type(GV.getValueType()) << ", "
     << (GV.isConstant() ? "true" : "false") << ", " << linkageName(GV.getLinkage())
     << ", nullptr, " << quote(GV.getName()) << ");\n";
  if (GV.hasGlobalUnnamedAddr())
    OS << "  " << N << "->setUnnamedAddr(GlobalValue::UnnamedAddr::Global);\n";
  else if (GV.hasAtLeastLocalUnnamedAddr())
    OS << "  " << N << "->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);\n";
  if (MaybeAlign A = GV.getAlign())
    OS << "  " << N << "->setAlignment(MaybeAlign(" << A->value() << "));\n";
}

void Emitter::emitFunctionDecl(const Function &F) {
  OS << "  " << functionHeader(F) << '\n'
     << "  Function *" << name(&F) << " = Function::Create(\n"
     << "      " << type(F.getFunctionType()) << ",\n"
     << "      " << linkageName(F.getLinkage()) << ", " << quote(F.getName())
     << ", module);\n";
  if (F.getCallingConv() != CallingConv::C)
    OS << "  " << name(&F) << "->setCallingConv(CallingConv::ID("
       << F.getCallingConv() << "));\n";
}

void Emitter::emitFunctionBody(const Function &F) {
  MST.incorporateFunction(F);
  Defined.clear();
  std::string FN = name(&F);
  OS << "\n  " << functionHeader(F) << "\n  {\n";

  for (const Argument &A : F.args()) {
    std::string N = name(&A);
    OS << "    Argument *" << N << " = " << FN << "->getArg(" << A.getArgNo() << ");\n";
    if (A.hasName())
      OS << "    " << N << "->setName(" << quote(A.getName()) << ");\n";
    Defined.insert(&A);
  }

  // All blocks up front (keeps the source layout), then fill them in reverse
  // post-order so that every non-phi operand is defined before its use.
  OS << "    // BasicBlocks:\n";
  for (const BasicBlock &BB : F)
    OS << "    BasicBlock *" << name(&BB) << " = BasicBlock::Create(ctx"
       << (BB.hasName() ? ", " + quote(BB.getName()) : std::string(", \"\""))
       << ", " << FN << ");\n";

  SmallVector<const BasicBlock *, 32> Order;
  DenseSet<const BasicBlock *> Seen;
  for (const BasicBlock *BB : ReversePostOrderTraversal<const Function *>(&F)) {
    Order.push_back(BB);
    Seen.insert(BB);
  }
  for (const BasicBlock &BB : F)
    if (!Seen.count(&BB))
      Order.push_back(&BB);

  SmallVector<const PHINode *, 16> Phis;
  for (const BasicBlock *BB : Order) {
    std::string Label = BB->hasName() ? BB->getName().str()
                                      : std::to_string(MST.getLocalSlot(BB));
    OS << "\n    // " << Label << ":\n"
       << "    builder.SetInsertPoint(" << name(BB) << ");\n";
    for (const Instruction &I : *BB) {
      if (Dropped.count(&I))
        continue;
      emitInst(I);
      if (auto *Phi = dyn_cast<PHINode>(&I))
        Phis.push_back(Phi);
    }
  }

  if (!Phis.empty())
    OS << "\n    // Link PHI nodes\n";
  for (const PHINode *Phi : Phis) {
    OS << "    " << irComment(*Phi) << '\n';
    for (unsigned I = 0; I < Phi->getNumIncomingValues(); ++I) {
      const Value *In = Phi->getIncomingValue(I);
      std::string InExpr = isa<Instruction>(In) ? name(In) : value(In);
      OS << "    " << name(Phi) << "->addIncoming(" << InExpr << ", "
         << name(Phi->getIncomingBlock(I)) << ");\n";
    }
  }
  OS << "  }\n";
}

void Emitter::emitInst(const Instruction &I) {
  OS << "    " << irComment(I) << '\n';
  auto V = [&](unsigned Idx) { return value(I.getOperand(Idx)); };
  auto B = [](bool X) { return X ? "true" : "false"; };
  std::string Expr;   // the builder call producing the instruction
  std::string Decl = "Value"; // C++ type of the result variable
  std::string Post;   // statements after creation, `%` stands for the variable

  unsigned Op = I.getOpcode();
  switch (Op) {
  case Instruction::Ret:
    Expr = I.getNumOperands() ? "builder.CreateRet(" + V(0) + ")" : "builder.CreateRetVoid()";
    break;
  case Instruction::Br: {
    auto *Br = cast<BranchInst>(&I);
    if (Br->isUnconditional())
      Expr = "builder.CreateBr(" + name(Br->getSuccessor(0)) + ")";
    else
      Expr = "builder.CreateCondBr(" + value(Br->getCondition()) + ", " +
             name(Br->getSuccessor(0)) + ", " + name(Br->getSuccessor(1)) + ")";
    break;
  }
  case Instruction::Switch: {
    auto *SI = cast<SwitchInst>(&I);
    Decl = "SwitchInst";
    Expr = "builder.CreateSwitch(" + value(SI->getCondition()) + ", " +
           name(SI->getDefaultDest()) + ", " + std::to_string(SI->getNumCases()) + ")";
    for (const auto &Case : SI->cases())
      Post += "%->addCase(" + constant(Case.getCaseValue()) + ", " +
              name(Case.getCaseSuccessor()) + ");\n";
    break;
  }
  case Instruction::Unreachable:
    Expr = "builder.CreateUnreachable()";
    break;

  case Instruction::Add:
  case Instruction::Sub:
  case Instruction::Mul:
  case Instruction::Shl:
    Expr = std::string("builder.Create") + opcodeName(Op) + "(" + V(0) + ", " + V(1) +
           ", " + (I.hasName() ? quote(I.getName()) : "\"\"") + ", " +
           B(I.hasNoUnsignedWrap()) + ", " + B(I.hasNoSignedWrap()) + ")";
    break;
  case Instruction::UDiv:
  case Instruction::SDiv:
  case Instruction::LShr:
  case Instruction::AShr:
    Expr = std::string("builder.Create") + opcodeName(Op) + "(" + V(0) + ", " + V(1) +
           ", " + (I.hasName() ? quote(I.getName()) : "\"\"") + ", " +
           B(I.isExact()) + ")";
    break;
  case Instruction::URem:
  case Instruction::SRem:
  case Instruction::And:
  case Instruction::Or:
  case Instruction::Xor:
  case Instruction::FAdd:
  case Instruction::FSub:
  case Instruction::FMul:
  case Instruction::FDiv:
  case Instruction::FRem:
    Expr = std::string("builder.Create") + opcodeName(Op) + "(" + V(0) + ", " + V(1) +
           nameArg(I) + ")";
    break;
  case Instruction::FNeg:
    Expr = "builder.CreateFNeg(" + V(0) + nameArg(I) + ")";
    break;

  case Instruction::Alloca: {
    auto *AI = cast<AllocaInst>(&I);
    Decl = "AllocaInst";
    std::string Size = AI->isArrayAllocation() ? value(AI->getArraySize()) : "nullptr";
    Expr = "builder.CreateAlloca(" + type(AI->getAllocatedType()) + ", " + Size +
           nameArg(I) + ")";
    Post = "%->setAlignment(Align(" + std::to_string(AI->getAlign().value()) + "));\n";
    break;
  }
  case Instruction::Load: {
    auto *LI = cast<LoadInst>(&I);
    if (LI->isAtomic())
      fail("atomic load is not supported", &I);
    Expr = "builder.CreateAlignedLoad(" + type(LI->getType()) + ", " + V(0) +
           ", MaybeAlign(" + std::to_string(LI->getAlign().value()) + ")" +
           (LI->isVolatile() ? ", true" : "") + nameArg(I) + ")";
    break;
  }
  case Instruction::Store: {
    auto *SI = cast<StoreInst>(&I);
    if (SI->isAtomic())
      fail("atomic store is not supported", &I);
    Expr = "builder.CreateAlignedStore(" + V(0) + ", " + V(1) + ", MaybeAlign(" +
           std::to_string(SI->getAlign().value()) + ")" +
           (SI->isVolatile() ? ", true" : "") + ")";
    break;
  }
  case Instruction::GetElementPtr: {
    auto *GEP = cast<GetElementPtrInst>(&I);
    std::string Idx;
    // A single index goes as a plain Value*: `{x}` would be ambiguous.
    if (GEP->getNumIndices() == 1)
      Idx = V(1);
    else
      Idx = "{" + join(GEP->indices(), [&](const Use &U) { return value(U); }) + "}";
    Expr = std::string("builder.Create") + (GEP->isInBounds() ? "InBoundsGEP(" : "GEP(") +
           type(GEP->getSourceElementType()) + ", " + V(0) + ", " + Idx + nameArg(I) + ")";
    break;
  }

  case Instruction::Trunc:
  case Instruction::ZExt:
  case Instruction::SExt:
  case Instruction::FPToUI:
  case Instruction::FPToSI:
  case Instruction::UIToFP:
  case Instruction::SIToFP:
  case Instruction::FPTrunc:
  case Instruction::FPExt:
  case Instruction::PtrToInt:
  case Instruction::IntToPtr:
  case Instruction::BitCast:
  case Instruction::AddrSpaceCast:
    Expr = std::string("builder.Create") + opcodeName(Op) + "(" + V(0) + ", " +
           type(I.getType()) + nameArg(I) + ")";
    break;

  case Instruction::ICmp:
  case Instruction::FCmp:
    Expr = std::string("builder.Create") + (Op == Instruction::ICmp ? "ICmp(" : "FCmp(") +
           predicateName(cast<CmpInst>(&I)->getPredicate()) + ", " + V(0) + ", " + V(1) +
           nameArg(I) + ")";
    break;
  case Instruction::PHI:
    Decl = "PHINode";
    Expr = "builder.CreatePHI(" + type(I.getType()) + ", " +
           std::to_string(cast<PHINode>(&I)->getNumIncomingValues()) + nameArg(I) + ")";
    break;
  case Instruction::Select:
    Expr = "builder.CreateSelect(" + V(0) + ", " + V(1) + ", " + V(2) + nameArg(I) + ")";
    break;
  case Instruction::Freeze:
    Expr = "builder.CreateFreeze(" + V(0) + nameArg(I) + ")";
    break;

  case Instruction::Call: {
    auto *CI = cast<CallInst>(&I);
    if (CI->isInlineAsm())
      fail("inline asm is not supported", &I);
    Decl = "CallInst";
    std::string Args = join(CI->args(), [&](const Use &U) { return value(U); });
    const Function *Callee = CI->getCalledFunction();
    std::string Target = Callee ? name(Callee)
                                : type(CI->getFunctionType()) + ", " +
                                      value(CI->getCalledOperand());
    if (Args.empty() && !I.hasName())
      Expr = "builder.CreateCall(" + Target + ")";
    else
      Expr = "builder.CreateCall(" + Target + ", " +
             (Args.empty() ? std::string("None") : "{" + Args + "}") + nameArg(I) + ")";
    if (CI->getTailCallKind() == CallInst::TCK_Tail)
      Post += "%->setTailCall();\n";
    else if (CI->getTailCallKind() != CallInst::TCK_None)
      Post += "%->setTailCallKind(CallInst::TailCallKind(" +
              std::to_string(CI->getTailCallKind()) + "));\n";
    if (CI->getCallingConv() != CallingConv::C)
      Post += "%->setCallingConv(CallingConv::ID(" +
              std::to_string(CI->getCallingConv()) + "));\n";
    break;
  }

  case Instruction::ExtractElement:
    Expr = "builder.CreateExtractElement(" + V(0) + ", " + V(1) + nameArg(I) + ")";
    break;
  case Instruction::InsertElement:
    Expr = "builder.CreateInsertElement(" + V(0) + ", " + V(1) + ", " + V(2) +
           nameArg(I) + ")";
    break;
  case Instruction::ShuffleVector: {
    auto *SV = cast<ShuffleVectorInst>(&I);
    std::string Mask = join(SV->getShuffleMask(), [](int M) { return std::to_string(M); });
    Expr = "builder.CreateShuffleVector(" + V(0) + ", " + V(1) + ", ArrayRef<int>{" +
           Mask + "}" + nameArg(I) + ")";
    break;
  }
  case Instruction::ExtractValue: {
    auto *EV = cast<ExtractValueInst>(&I);
    Expr = "builder.CreateExtractValue(" + V(0) + ", {" +
           join(EV->indices(), [](unsigned X) { return std::to_string(X); }) + "}" +
           nameArg(I) + ")";
    break;
  }
  case Instruction::InsertValue: {
    auto *IV = cast<InsertValueInst>(&I);
    Expr = "builder.CreateInsertValue(" + V(0) + ", " + V(1) + ", {" +
           join(IV->indices(), [](unsigned X) { return std::to_string(X); }) + "}" +
           nameArg(I) + ")";
    break;
  }
  default:
    fail(Twine("unsupported instruction '") + I.getOpcodeName() + "'", &I);
  }

  if (isa<FPMathOperator>(I) && I.getFastMathFlags().any()) {
    FastMathFlags FMF = I.getFastMathFlags();
    std::string Sets;
    if (FMF.allowReassoc()) Sets += " FMF.setAllowReassoc();";
    if (FMF.noNaNs()) Sets += " FMF.setNoNaNs();";
    if (FMF.noInfs()) Sets += " FMF.setNoInfs();";
    if (FMF.noSignedZeros()) Sets += " FMF.setNoSignedZeros();";
    if (FMF.allowReciprocal()) Sets += " FMF.setAllowReciprocal();";
    if (FMF.allowContract()) Sets += " FMF.setAllowContract();";
    if (FMF.approxFunc()) Sets += " FMF.setApproxFunc();";
    Post += "if (auto *FI = dyn_cast<Instruction>(%)) { FastMathFlags FMF;" + Sets +
            " FI->setFastMathFlags(FMF); }\n";
  }

  bool IsVoid = I.getType()->isVoidTy();
  // `builder.CreateCall(f)->setTailCall();` reads better than a throwaway variable.
  bool SinglePost = StringRef(Post).startswith("%->") && StringRef(Post).count('\n') == 1;
  if (IsVoid && (Post.empty() || SinglePost)) {
    OS << "    " << Expr << (Post.empty() ? "" : StringRef(Post).drop_front(1).drop_back(1))
       << ";\n";
    return;
  }
  std::string N = IsVoid ? uniqueName(Decl == "SwitchInst" ? "sw" : "inst") : name(&I);
  OS << "    " << Decl << " *" << N << " = " << Expr << ";\n";
  StringRef Rest(Post);
  while (!Rest.empty()) {
    StringRef Line, Tail;
    std::tie(Line, Tail) = Rest.split('\n');
    std::string S = Line.str();
    for (size_t P = S.find('%'); P != std::string::npos; P = S.find('%', P + N.size()))
      S.replace(P, 1, N);
    OS << "    " << S << '\n';
    Rest = Tail;
  }
  Defined.insert(&I);
}

void Emitter::emitMain(const Function &Entry) {
  Type *RetTy = Entry.getReturnType();
  OS << "\nint main(int argc, char **argv) {\n"
     << "  LLVMContext context;\n"
     << "  Module *module = new Module(" << quote(M.getSourceFileName())
     << ", context);\n"
     << "  Function *entry = buildModule(module);\n\n"
     << "  // `" << "<prog> out.ll` also dumps the rebuilt module (e.g. for llvm-diff).\n"
     << "  if (argc > 1) {\n"
     << "    std::error_code EC;\n"
     << "    raw_fd_ostream Out(argv[1], EC);\n"
     << "    if (EC) {\n"
     << "      errs() << argv[1] << \": \" << EC.message() << '\\n';\n"
     << "      return EXIT_FAILURE;\n"
     << "    }\n"
     << "    module->print(Out, nullptr);\n"
     << "  }\n"
     << "  if (verifyModule(*module, &errs())) {\n"
     << "    errs() << \"[VERIFICATION] FAIL\\n\";\n"
     << "    return EXIT_FAILURE;\n"
     << "  }\n"
     << "  outs() << \"[VERIFICATION] OK\\n\";\n\n"
     << "  InitializeNativeTarget();\n"
     << "  InitializeNativeTargetAsmPrinter();\n"
     << "  sys::DynamicLibrary::LoadLibraryPermanently(nullptr);\n"
     << "  std::string Err;\n"
     << "  ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module))\n"
     << "                            .setEngineKind(EngineKind::JIT)\n"
     << "                            .setErrorStr(&Err)\n"
     << "                            .create();\n"
     << "  if (!ee) {\n"
     << "    errs() << \"[EE] \" << Err << '\\n';\n"
     << "    return EXIT_FAILURE;\n"
     << "  }\n";

  for (const GlobalValue *GV : Used)
    if (auto *Var = dyn_cast<GlobalVariable>(GV))
      if (Var->isDeclaration())
        OS << "  ee->addGlobalMapping(module->getNamedGlobal(" << quote(Var->getName())
           << "), (void *)&" << Var->getName() << ");\n";

  OS << "  ee->InstallLazyFunctionCreator([](const std::string &fnName) -> void * {\n";
  for (const GlobalValue *GV : Used)
    if (auto *F = dyn_cast<Function>(GV))
      if (F->isDeclaration() && !F->isIntrinsic())
        OS << "    if (fnName == " << quote(F->getName()) << ")\n"
           << "      return reinterpret_cast<void *>(" << F->getName() << ");\n";
  OS << "    // Anything else (e.g. memset/memcpy from lowered intrinsics) is in libc.\n"
     << "    if (void *Addr = sys::DynamicLibrary::SearchForAddressOfSymbol(fnName))\n"
     << "      return Addr;\n"
     << "    errs() << \"[EE] unresolved external: \" << fnName << '\\n';\n"
     << "    return nullptr;\n"
     << "  });\n"
     << "  ee->finalizeObject();\n\n"
     << "  outs() << \"[EE] Run\\n\";\n"
     << "  GenericValue v = ee->runFunction(entry, {});\n";
  if (RetTy->isIntegerTy())
    OS << "  outs() << \"[EE] Result: \" << v.IntVal << '\\n';\n";
  else
    OS << "  (void)v;\n  outs() << \"[EE] Done\\n\";\n";
  OS << "  delete ee;\n"
     << "  return EXIT_SUCCESS;\n"
     << "}\n";
}

std::string Emitter::run(const Function &Entry) {
  if (Entry.isDeclaration())
    fail("entry function has no body", &Entry);
  if (Entry.arg_size() != 0)
    fail("entry function must take no arguments", &Entry);
  collect(Entry);

  // Globals and functions live at buildModule() scope; reserve their names
  // before any local can take them.
  for (const GlobalValue *GV : Used)
    name(GV);

  OS << "// Generated by ir2cpp from " << M.getModuleIdentifier()
     << " - do not edit, regenerate instead.\n"
     << "// Rebuilds @" << Entry.getName()
     << " and everything it reaches with IRBuilder, then runs it in MCJIT\n"
     << "// with external calls resolved to the functions from " << Header << ".\n\n"
     << "extern \"C\" {\n"
     << "#include \"" << Header << "\"\n"
     << "}\n\n"
     << "#include \"llvm/ExecutionEngine/ExecutionEngine.h\"\n"
     << "#include \"llvm/ExecutionEngine/GenericValue.h\"\n"
     << "#include \"llvm/ExecutionEngine/MCJIT.h\"\n"
     << "#include \"llvm/IR/Constants.h\"\n"
     << "#include \"llvm/IR/IRBuilder.h\"\n"
     << "#include \"llvm/IR/LLVMContext.h\"\n"
     << "#include \"llvm/IR/Module.h\"\n"
     << "#include \"llvm/IR/Verifier.h\"\n"
     << "#include \"llvm/Support/DynamicLibrary.h\"\n"
     << "#include \"llvm/Support/TargetSelect.h\"\n"
     << "#include \"llvm/Support/raw_ostream.h\"\n\n"
     << "#include <cstdint>\n"
     << "#include <cstdlib>\n\n"
     << "using namespace llvm;\n\n"
     << "// Returns @" << Entry.getName() << ".\n"
     << "static Function *buildModule(Module *module) {\n"
     << "  LLVMContext &ctx = module->getContext();\n"
     << "  IRBuilder<> builder(ctx);\n"
     << "  (void)ctx;\n"
     << "  module->setSourceFileName(" << quote(M.getSourceFileName()) << ");\n"
     << "  module->setDataLayout(" << quote(M.getDataLayoutStr()) << ");\n"
     << "  module->setTargetTriple(" << quote(M.getTargetTriple()) << ");\n";

  bool AnyGlobals = false;
  for (const GlobalValue *GV : Used)
    if (auto *Var = dyn_cast<GlobalVariable>(GV)) {
      if (!AnyGlobals)
        OS << "\n  // Global variables\n";
      AnyGlobals = true;
      emitGlobal(*Var);
    }

  OS << "\n  // Functions\n";
  for (const GlobalValue *GV : Used)
    if (auto *F = dyn_cast<Function>(GV))
      emitFunctionDecl(*F);

  // Initializers last: they may refer to any global or function above.
  for (const GlobalValue *GV : Used)
    if (auto *Var = dyn_cast<GlobalVariable>(GV))
      if (Var->hasInitializer())
        OS << "  " << name(Var) << "->setInitializer(" << constant(Var->getInitializer())
           << ");\n";

  for (const GlobalValue *GV : Used)
    if (auto *F = dyn_cast<Function>(GV))
      if (!F->isDeclaration())
        emitFunctionBody(*F);

  OS << "\n  return " << name(&Entry) << ";\n}\n";
  emitMain(Entry);
  return OS.str();
}

} // namespace

int main(int argc, char **argv) {
  cl::ParseCommandLineOptions(argc, argv, "LLVM IR -> IRBuilder C++ generator\n");

  LLVMContext Ctx;
  SMDiagnostic Err;
  std::unique_ptr<Module> M = parseIRFile(InputFile, Err, Ctx);
  if (!M) {
    Err.print(argv[0], errs());
    return 1;
  }
  const Function *Entry = M->getFunction(EntryName);
  if (!Entry)
    fail("no function @" + EntryName + " in " + InputFile);

  // Generate fully before opening the output so a failure leaves no stub.
  std::string Code = Emitter(*M).run(*Entry);

  std::error_code EC;
  raw_fd_ostream Out(OutputFile, EC);
  if (EC)
    fail(OutputFile + ": " + EC.message());
  Out << Code;
  return 0;
}
