# Трасса использования IR-инструкций (User <- Operand)

Инструментирующий Pass собирает в рантайме трассу IR-инструкций логического модуля
(`src/logic/logic.c`) на **-O2** и **-Os**, пропуская User-phi. По трассе считаются частые паттерны
длиной 1–5 инструкций.

* [IRTracePass.cpp](IRTracePass.cpp) — Pass: перед каждой не-phi инструкцией вставляет `__ir_trace_inst(id)`
  и кладёт в модуль карту `id → opcode, операнды, текст IR`.
* [trace_rt.c](trace_rt.c) — логгер: считает окна из 5 подряд идущих инструкций (окна 1–4 получаются из них
  точно) и сохраняет кусок сырой трассы. Целиком трасса не пишется.
* [analyze.py](analyze.py) — подсчёт паттернов.
* [stats/O2/](stats/O2/patterns.md), [stats/Os/](stats/Os/patterns.md) — результаты.

```
make trace-stats                 # -O2 и -Os, 20 кадров каждый
make trace-O2 TRACE_FRAMES=50
```

В `stats/<opt>/`: `patterns.md` — отчёт, `opcode_n{1..5}.csv` — все паттерны,
`use_edges.csv` — частоты User <- Operand,
`trace_head.txt` — фрагмент трассы, `windows.tsv`/`map.tsv`/`meta.txt` — сырые данные.

## Результаты

| n | самый частый паттерн (-O2 и -Os совпадают) | % |
|---|---|---|
| 1 | `getelementptr` | 24.8 |
| 2 | `getelementptr \| load` | 22.3 |
| 3 | `getelementptr \| load \| llvm.fmuladd` | 17.2 |
| 4 | `llvm.fmuladd \| getelementptr \| load \| llvm.fmuladd` | 16.0 |
| 5 | `getelementptr \| load \| llvm.fmuladd \| getelementptr \| load` | 16.0 |

* 96% трассы — внутренний цикл `sim_step` (78 IR-инструкций на клетку), 4% — отрисовка.
* `getelementptr` + `load` + `llvm.fmuladd` дают 72% всех инструкций: лапласиан компилируется в цепочку
  «адрес → загрузка → FMA с накоплением».
* Тороидальные границы `(x ± 1) % 800` дают `trunc | add | urem | zext` на каждой клетке (1.2%).
* -O2 и -Os по динамике почти идентичны: горячий цикл одинаковый и не векторизован. Отличается только
  холодный код (359 против 240 статических инструкций, на -O2 `init_grid` встроена и векторизована).
