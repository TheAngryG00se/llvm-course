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

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR) $(IR_DIR)
