// IR use-trace pass (LLVM 14 plugin, runs at OptimizerLastEP).
// Inserts __ir_trace_inst(id) before every non-phi instruction and
// __ir_trace_frame() after calls to `flush` (IR_TRACE_FRAME_FN). The map
// id -> opcode/operands/text is embedded as the global __ir_trace_map.

#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

#include <cstdlib>
#include <string>
#include <vector>

using namespace llvm;

namespace {

// Runtime packs window keys with 12 bits per ID (0xFFF is reserved).
constexpr unsigned MaxIds = 0xFFF;

struct IRTracePass : public PassInfoMixin<IRTracePass> {
  static bool isRuntimeFunc(StringRef Name) {
    return Name.startswith("__ir_trace");
  }

  // Tabs/newlines are the map's field/record separators.
  static std::string sanitize(std::string S) {
    for (char &C : S)
      if (C == '\t' || C == '\n')
        C = ' ';
    size_t Start = S.find_first_not_of(' ');
    return Start == std::string::npos ? std::string() : S.substr(Start);
  }

  // i<ID> instruction, a arg, c: const, g: global, f: function, b label, m other
  static std::string describeOperand(const Value *V,
                                     const DenseMap<const Instruction *, unsigned> &Ids) {
    if (auto *I = dyn_cast<Instruction>(V))
      return "i" + std::to_string(Ids.lookup(I));
    if (isa<Argument>(V))
      return "a";
    if (auto *F = dyn_cast<Function>(V))
      return "f:" + F->getName().str();
    if (auto *GV = dyn_cast<GlobalValue>(V))
      return "g:" + GV->getName().str();
    if (isa<BasicBlock>(V))
      return "b";
    if (auto *C = dyn_cast<Constant>(V)) {
      std::string Text;
      raw_string_ostream OS(Text);
      C->printAsOperand(OS, /*PrintType=*/false);
      std::string S = sanitize(OS.str());
      for (char &Ch : S)
        if (Ch == ',' || Ch == ' ')
          Ch = '_';
      return "c:" + S;
    }
    return "m";
  }

  PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
    LLVMContext &Ctx = M.getContext();
    IRBuilder<> Builder(Ctx);
    Type *VoidTy = Type::getVoidTy(Ctx);
    Type *Int32Ty = Type::getInt32Ty(Ctx);

    FunctionCallee InstLog = M.getOrInsertFunction(
        "__ir_trace_inst", FunctionType::get(VoidTy, {Int32Ty}, false));
    FunctionCallee FrameLog = M.getOrInsertFunction(
        "__ir_trace_frame", FunctionType::get(VoidTy, {}, false));

    const char *FrameEnv = std::getenv("IR_TRACE_FRAME_FN");
    std::string FrameFn = FrameEnv ? FrameEnv : "flush";

    DenseMap<const Instruction *, unsigned> Ids;
    std::vector<Instruction *> Order;
    for (Function &F : M) {
      if (F.isDeclaration() || isRuntimeFunc(F.getName()))
        continue;
      for (BasicBlock &B : F)
        for (Instruction &I : B) {
          Ids[&I] = Order.size();
          Order.push_back(&I);
        }
    }
    if (Order.size() >= MaxIds)
      report_fatal_error("IRTracePass: too many instructions for 12-bit IDs");

    // id \t function \t opcode \t instrumented \t operands \t text
    std::string Map;
    raw_string_ostream MapOS(Map);
    for (Instruction *I : Order) {
      std::string Ops;
      for (const Use &U : I->operands()) {
        if (!Ops.empty())
          Ops += ',';
        Ops += describeOperand(U.get(), Ids);
      }
      std::string Text;
      raw_string_ostream TextOS(Text);
      I->print(TextOS);
      bool Traced = !isa<PHINode>(I) && !isa<DbgInfoIntrinsic>(I);
      MapOS << Ids[I] << '\t' << I->getFunction()->getName() << '\t'
            << I->getOpcodeName() << '\t' << (Traced ? 1 : 0) << '\t'
            << (Ops.empty() ? "-" : Ops) << '\t' << sanitize(TextOS.str())
            << '\n';
    }
    MapOS.flush();

    Constant *MapStr = ConstantDataArray::getString(Ctx, Map, true);
    new GlobalVariable(M, MapStr->getType(), /*isConstant=*/true,
                       GlobalValue::ExternalLinkage, MapStr, "__ir_trace_map");

    unsigned Traced = 0, Frames = 0;
    for (Instruction *I : Order) {
      if (isa<PHINode>(I) || isa<DbgInfoIntrinsic>(I))
        continue;

      Builder.SetInsertPoint(I);
      Builder.CreateCall(InstLog, {ConstantInt::get(Int32Ty, Ids[I])});
      ++Traced;

      if (auto *Call = dyn_cast<CallInst>(I)) {
        Function *Callee = Call->getCalledFunction();
        if (Callee && Callee->getName() == FrameFn) {
          Builder.SetInsertPoint(Call->getNextNode());
          Builder.CreateCall(FrameLog);
          ++Frames;
        }
      }
    }

    errs() << "[IRTracePass] " << M.getName() << ": " << Order.size()
           << " instructions, " << Traced << " instrumented, " << Frames
           << " frame hooks after '" << FrameFn << "'\n";

    for (Function &F : M)
      if (!F.isDeclaration() && verifyFunction(F, &errs()))
        report_fatal_error("IRTracePass: broken function after instrumentation");

    return PreservedAnalyses::none();
  }
};

} // namespace

PassPluginLibraryInfo getIRTracePassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "IRTracePass", "0.1", [](PassBuilder &PB) {
            PB.registerOptimizerLastEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel) {
                  MPM.addPass(IRTracePass());
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getIRTracePassPluginInfo();
}
