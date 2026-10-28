CC := clang
CSTD := -std=c11
WARN := -Wall -Wextra -Wpedantic

SDL_CFLAGS := $(shell pkg-config --cflags sdl2)
SDL_LIBS := $(shell pkg-config --libs sdl2) -lm

INCLUDES := -Isrc/app
CFLAGS := $(CSTD) $(WARN) $(INCLUDES) $(SDL_CFLAGS)

SRC := src/main.c src/app/app_sdl.c src/logic/logic.c
LOGIC_SRC := src/logic/logic.c

BUILD_DIR := build
IR_DIR := ir

.PHONY: all debug opt0 opt3 ir asm clean trace-pass trace-O2 trace-Os trace-stats

all: $(BUILD_DIR)/rd

$(BUILD_DIR)/rd: $(SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -O2 $(SRC) -o $@ $(SDL_LIBS)

debug: $(BUILD_DIR)/rd-debug

$(BUILD_DIR)/rd-debug: $(SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -O0 -g $(SRC) -o $@ $(SDL_LIBS)

opt0: $(BUILD_DIR)/rd-O0

$(BUILD_DIR)/rd-O0: $(SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -O0 $(SRC) -o $@ $(SDL_LIBS)

opt3: $(BUILD_DIR)/rd-O3

$(BUILD_DIR)/rd-O3: $(SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -O3 -march=native $(SRC) -o $@ $(SDL_LIBS)

ir: $(IR_DIR)/sim_step-O0.ll $(IR_DIR)/sim_step-O3.ll

$(IR_DIR)/sim_step-O0.ll: $(LOGIC_SRC)
	mkdir -p $(IR_DIR)
	$(CC) $(CSTD) $(WARN) $(INCLUDES) -O0 -fno-inline-functions -S -emit-llvm $< -o $(IR_DIR)/.logic-O0.ll
	llvm-extract -S --func=sim_step $(IR_DIR)/.logic-O0.ll -o $@
	rm -f $(IR_DIR)/.logic-O0.ll

$(IR_DIR)/sim_step-O3.ll: $(LOGIC_SRC)
	mkdir -p $(IR_DIR)
	$(CC) $(CSTD) $(WARN) $(INCLUDES) -O3 -march=native -fno-inline-functions -S -emit-llvm $< -o $(IR_DIR)/.logic-O3.ll
	llvm-extract -S --func=sim_step $(IR_DIR)/.logic-O3.ll -o $@
	rm -f $(IR_DIR)/.logic-O3.ll

asm: $(BUILD_DIR)/logic-O0.s $(BUILD_DIR)/logic-O2.s $(BUILD_DIR)/logic-O3.s

$(BUILD_DIR)/logic-O0.s: $(LOGIC_SRC) | $(BUILD_DIR)
	$(CC) $(CSTD) $(WARN) $(INCLUDES) -O0 -S $< -o $@

$(BUILD_DIR)/logic-O2.s: $(LOGIC_SRC) | $(BUILD_DIR)
	$(CC) $(CSTD) $(WARN) $(INCLUDES) -O2 -S $< -o $@

$(BUILD_DIR)/logic-O3.s: $(LOGIC_SRC) | $(BUILD_DIR)
	$(CC) $(CSTD) $(WARN) $(INCLUDES) -O3 -march=native -S $< -o $@

TRACE_SRC := trace
TRACE_PASS := $(BUILD_DIR)/libIRTracePass.so
TRACE_FRAMES ?= 20
TRACE_HEAD ?= 5000

trace-pass: $(TRACE_PASS)

$(TRACE_PASS): $(TRACE_SRC)/IRTracePass.cpp | $(BUILD_DIR)
	clang++ $< -fPIC -shared $(shell llvm-config --cxxflags) -o $@

$(BUILD_DIR)/rd-trace-%: $(SRC) $(TRACE_SRC)/trace_rt.c $(TRACE_PASS) | $(BUILD_DIR)
	$(CC) $(CSTD) $(WARN) $(INCLUDES) -$* -fpass-plugin=$(TRACE_PASS) -c $(LOGIC_SRC) -o $(BUILD_DIR)/logic-trace-$*.o
	$(CC) $(CFLAGS) -O2 src/main.c src/app/app_sdl.c $(TRACE_SRC)/trace_rt.c $(BUILD_DIR)/logic-trace-$*.o -o $@ $(SDL_LIBS)

trace-O2 trace-Os: trace-%: $(BUILD_DIR)/rd-trace-%
	mkdir -p $(BUILD_DIR)/trace-$*
	IR_TRACE_DIR=$(BUILD_DIR)/trace-$* IR_TRACE_FRAMES=$(TRACE_FRAMES) IR_TRACE_HEAD=$(TRACE_HEAD) ./$<
	python3 $(TRACE_SRC)/analyze.py $(BUILD_DIR)/trace-$* $(TRACE_SRC)/stats/$* --opt=-$*

trace-stats: trace-O2 trace-Os

# IR generator: ir2cpp turns the logic IR into IRBuilder C++ code
# (irgen/app_ir_gen.cpp) that rebuilds it and runs app() in MCJIT.
IRGEN_SRC := irgen
IR2CPP := $(BUILD_DIR)/ir2cpp
# No vectorization/unrolling: keeps the generated code scalar and readable.
IRGEN_OPT ?= -O2 -fno-vectorize -fno-slp-vectorize -fno-unroll-loops
LLVM_CXXFLAGS := $(shell llvm-config --cxxflags)
LLVM_LIBS := $(shell llvm-config --ldflags --libs)

.PHONY: irgen jit

irgen: $(IRGEN_SRC)/app_ir_gen.cpp

jit: $(BUILD_DIR)/rd-jit

$(IR2CPP): $(IRGEN_SRC)/ir2cpp.cpp | $(BUILD_DIR)
	clang++ $(LLVM_CXXFLAGS) $< -o $@ $(LLVM_LIBS)

$(IR_DIR)/logic-gen.ll: $(LOGIC_SRC)
	mkdir -p $(IR_DIR)
	$(CC) $(CSTD) $(WARN) $(INCLUDES) $(IRGEN_OPT) -fno-discard-value-names -S -emit-llvm $< -o $@

$(IRGEN_SRC)/app_ir_gen.cpp: $(IR_DIR)/logic-gen.ll $(IR2CPP)
	$(IR2CPP) $< --entry=app --header=sim.h -o $@

$(BUILD_DIR)/app_sdl.o: src/app/app_sdl.c src/app/sim.h | $(BUILD_DIR)
	$(CC) $(CFLAGS) -O2 -c $< -o $@

$(BUILD_DIR)/rd-jit: $(IRGEN_SRC)/app_ir_gen.cpp $(BUILD_DIR)/app_sdl.o
	clang++ $(LLVM_CXXFLAGS) $(INCLUDES) -O2 $^ -o $@ $(LLVM_LIBS) $(SDL_LIBS)

# Headless check: native logic and the JIT-run generator, both on a stub
# sim.h backend, must print the same pixel hash.
.PHONY: jit-check

$(BUILD_DIR)/sim_stub.o: $(IRGEN_SRC)/sim_stub.c src/app/sim.h | $(BUILD_DIR)
	$(CC) $(CSTD) $(WARN) $(INCLUDES) -O2 -c $< -o $@

$(BUILD_DIR)/rd-stub: src/main.c $(LOGIC_SRC) $(BUILD_DIR)/sim_stub.o
	$(CC) $(CSTD) $(WARN) $(INCLUDES) -O2 $^ -o $@

$(BUILD_DIR)/rd-jit-stub: $(IRGEN_SRC)/app_ir_gen.cpp $(BUILD_DIR)/sim_stub.o
	clang++ $(LLVM_CXXFLAGS) $(INCLUDES) -O2 $^ -o $@ $(LLVM_LIBS)

jit-check: $(BUILD_DIR)/rd-stub $(BUILD_DIR)/rd-jit-stub
	@native=$$(./$(BUILD_DIR)/rd-stub) && jit=$$(./$(BUILD_DIR)/rd-jit-stub | tail -n 1) && \
	echo "native: $$native" && echo "jit:    $$jit" && \
	if [ "$$native" = "$$jit" ]; then echo "jit-check: OK"; else echo "jit-check: MISMATCH"; exit 1; fi

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR) $(IR_DIR)
