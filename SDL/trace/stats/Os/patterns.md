# IR use-trace patterns, logic module at `-Os`

6,241,979,134 executed IR instructions (20 frames), 240 static instructions.

## User <- Operand

| User | Operand | % |
|---|---|---|
| `getelementptr` | `zext` | 15.97 |
| `getelementptr` | `alloca` | 13.39 |
| `load` | `getelementptr` | 12.06 |
| `llvm.fmuladd` | `load` | 11.98 |
| `llvm.fmuladd` | `llvm.fmuladd` | 11.98 |
| `getelementptr` | `phi` | 10.82 |
| `fmul` | `load` | 3.41 |
| `llvm.fmuladd` | `fmul` | 2.00 |
| `zext` | `urem` | 1.33 |
| `store` | `getelementptr` | 1.33 |

## Window n = 1 (all 34 executed instructions)

| instruction | count | % |
|---|---|---|
| `getelementptr` | 1,545,735,728 | 24.76 |
| `llvm.fmuladd` | 1,536,000,000 | 24.61 |
| `load` | 1,392,000,040 | 22.30 |
| `fmul` | 364,800,000 | 5.84 |
| `add` | 163,554,960 | 2.62 |
| `trunc` | 163,414,000 | 2.62 |
| `zext` | 153,792,020 | 2.46 |
| `urem` | 153,792,000 | 2.46 |
| `store` | 153,735,686 | 2.46 |
| `fadd` | 153,600,020 | 2.46 |
| `br` | 105,974,344 | 1.70 |
| `icmp` | 86,648,880 | 1.39 |
| `fsub` | 86,400,000 | 1.38 |
| `fneg` | 76,800,020 | 1.23 |
| `or` | 28,800,040 | 0.46 |
| `fptoui` | 28,800,000 | 0.46 |
| `shl` | 19,200,000 | 0.31 |
| `fcmp` | 19,200,000 | 0.31 |
| `call @put_pixel` | 9,600,000 | 0.15 |
| `bitcast` | 120,005 | 0.00 |
| `mul` | 10,100 | 0.00 |
| `llvm.experimental.noalias.scope.decl` | 640 | 0.00 |
| `llvm.memcpy` | 320 | 0.00 |
| `call @is_key_pressed` | 140 | 0.00 |
| `xor` | 60 | 0.00 |
| `select` | 40 | 0.00 |
| `and` | 40 | 0.00 |
| `call @should_quit` | 20 | 0.00 |
| `call @flush` | 20 | 0.00 |
| `llvm.lifetime.start` | 4 | 0.00 |
| `alloca` | 4 | 0.00 |
| `llvm.memset` | 1 | 0.00 |
| `ret` | 1 | 0.00 |
| `call @init_grid` | 1 | 0.00 |

## Window n = 2

| pattern | % |
|---|---|
| `getelementptr \| load` | 22.30 |
| `llvm.fmuladd \| getelementptr` | 17.23 |
| `load \| llvm.fmuladd` | 17.23 |
| `load \| fmul` | 2.61 |
| `getelementptr \| store` | 2.46 |
| `zext \| getelementptr` | 2.46 |
| `load \| getelementptr` | 2.46 |
| `fadd \| getelementptr` | 2.46 |
| `llvm.fmuladd \| fadd` | 2.46 |
| `fmul \| llvm.fmuladd` | 2.46 |

## Window n = 3

| pattern | % |
|---|---|
| `llvm.fmuladd \| getelementptr \| load` | 17.23 |
| `getelementptr \| load \| llvm.fmuladd` | 17.23 |
| `load \| llvm.fmuladd \| getelementptr` | 15.99 |
| `getelementptr \| load \| fmul` | 2.61 |
| `getelementptr \| load \| getelementptr` | 2.46 |
| `zext \| getelementptr \| load` | 2.46 |
| `load \| getelementptr \| load` | 2.46 |
| `fadd \| getelementptr \| store` | 2.46 |
| `llvm.fmuladd \| fadd \| getelementptr` | 2.46 |
| `load \| fmul \| llvm.fmuladd` | 2.46 |

## Window n = 4

| pattern | % |
|---|---|
| `llvm.fmuladd \| getelementptr \| load \| llvm.fmuladd` | 15.99 |
| `getelementptr \| load \| llvm.fmuladd \| getelementptr` | 15.99 |
| `load \| llvm.fmuladd \| getelementptr \| load` | 15.99 |
| `getelementptr \| load \| getelementptr \| load` | 2.46 |
| `llvm.fmuladd \| fadd \| getelementptr \| store` | 2.46 |
| `getelementptr \| load \| fmul \| llvm.fmuladd` | 2.46 |
| `load \| getelementptr \| load \| fmul` | 2.46 |
| `br \| add \| trunc \| urem` | 1.23 |
| `trunc \| add \| urem \| zext` | 1.23 |
| `trunc \| urem \| trunc \| add` | 1.23 |

## Window n = 5

| pattern | % |
|---|---|
| `getelementptr \| load \| llvm.fmuladd \| getelementptr \| load` | 15.99 |
| `llvm.fmuladd \| getelementptr \| load \| llvm.fmuladd \| getelementptr` | 14.76 |
| `load \| llvm.fmuladd \| getelementptr \| load \| llvm.fmuladd` | 14.76 |
| `getelementptr \| load \| getelementptr \| load \| fmul` | 2.46 |
| `load \| getelementptr \| load \| fmul \| llvm.fmuladd` | 2.46 |
| `br \| add \| trunc \| urem \| trunc` | 1.23 |
| `trunc \| urem \| trunc \| add \| urem` | 1.23 |
| `add \| trunc \| urem \| trunc \| add` | 1.23 |
| `urem \| trunc \| add \| urem \| zext` | 1.23 |
| `zext \| getelementptr \| load \| getelementptr \| load` | 1.23 |
