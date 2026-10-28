# Reaction-Diffusion Visualizer

A real-time Gray-Scott reaction-diffusion simulation in C, rendered with
SDL2

## Build & run

Requires `clang` and SDL2.

```
make          # build build/rd
./build/rd
```

Other targets: `make debug`, `make opt0`, `make opt3` (`-O3 -march=native`),
`make ir` / `make asm` (LLVM IR / assembly dumps of the logic core),
`make clean`.

`make trace-stats` — IR use-trace of the logic module at `-O2`/`-Os` via an
instrumenting LLVM pass, plus pattern statistics; see [trace/](trace/README.md).

### IR generator (LLVM ExecutionEngine)

```
make jit          # build build/rd-jit
./build/rd-jit    # optional arg: path to dump the rebuilt module (.ll)
make jit-check    # headless: native vs JIT pixel hash must match
```

`build/ir2cpp` ([irgen/ir2cpp.cpp](irgen/ir2cpp.cpp)) reads the logic IR
(`ir/logic-gen.ll`, `-O2` without vectorization/unrolling) and writes
[irgen/app_ir_gen.cpp](irgen/app_ir_gen.cpp): IRBuilder code that rebuilds
`app()` and everything it calls (each call is preceded by the IR line it
produces), verifies the module and runs it in MCJIT. `put_pixel`, `flush`,
`should_quit` and `is_key_pressed` are forwarded to the real SDL backend
through `InstallLazyFunctionCreator`. `make irgen` regenerates the file;
`make -B irgen IRGEN_OPT=-O0` uses another opt level. Attributes, metadata and
lifetime/noalias hint intrinsics are not rebuilt.

## Controls

| Key     | Action              |
|---------|---------------------|
| Space   | Pause / resume      |
| R       | Reset the grid      |
| 1 – 5   | Switch preset       |

## Layout

```
src/
├── main.c        # calls app()
├── app/          # SDL2 backend (sim.h is the only header logic includes)
└── logic/        # Gray-Scott simulation
trace/            # IR use-trace pass, runtime, analysis and collected stats
irgen/            # ir2cpp (IR -> IRBuilder C++), generated app_ir_gen.cpp, stub backend
```