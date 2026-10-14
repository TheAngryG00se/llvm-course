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
```