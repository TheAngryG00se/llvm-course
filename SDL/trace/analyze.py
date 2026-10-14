#!/usr/bin/env python3
"""
Pattern statistics over the IR use-trace collected by trace_rt.c.

Usage: analyze.py <trace-dir> <out-dir> [--opt=-O2]
"""
import collections
import csv
import os
import re
import shutil
import sys

WINDOW = 5
TOP = 10

# Type-mangling suffixes of intrinsic names: .f32, .p0i8, .i64, .v4f32 ...
MANGLING = re.compile(r"^(p\d+)?(i\d+|f\d+|v\d+[if]\d+|p\d+\w*)$")


def load_map(path):
    insts = {}
    with open(path) as f:
        for line in f:
            iid, func, opcode, _, ops, text = line.rstrip("\n").split("\t", 5)
            ops = [] if ops == "-" else ops.split(",")
            callee = ops[-1][2:] if opcode == "call" and ops and ops[-1].startswith("f:") else None
            insts[int(iid)] = {"func": func, "label": label(opcode, callee),
                               "ops": ops[:-1] if callee else ops, "text": text}
    return insts


def label(opcode, callee):
    """Opcode; calls are named by callee (`llvm.fmuladd`, `call @flush`)."""
    if callee is None:
        return opcode
    if callee.startswith("llvm."):
        parts = callee.split(".")
        while len(parts) > 2 and MANGLING.match(parts[-1]):
            parts.pop()
        return ".".join(parts)
    return f"call @{callee}"


def write_csv(path, header, rows):
    with open(path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(header)
        w.writerows(rows)


def md_table(header, rows):
    out = ["| " + " | ".join(header) + " |", "|" + "---|" * len(header)]
    out += ["| " + " | ".join(str(c).replace("|", "\\|") for c in r) + " |" for r in rows]
    return "\n".join(out) + "\n"


def render_head(path, out_path, insts):
    with open(path) as f:
        ids = [int(l) for l in f if l.strip()]
    with open(out_path, "w") as f:
        f.write("# seq  function  User <- Operands  ; IR\n")
        for seq, iid in enumerate(ids):
            inst = insts[iid]
            ops = [insts[int(op[1:])]["label"] if op.startswith("i") else op
                   for op in inst["ops"] if op != "b"]
            f.write(f"{seq:05d}  {inst['func']:<10} {inst['label']:<16} <- "
                    f"{', '.join(ops) or '-':<40} ; {inst['text']}\n")


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    opts = dict(a[2:].split("=", 1) for a in sys.argv[1:] if a.startswith("--"))
    if len(args) != 2:
        sys.exit(__doc__)
    trace_dir, out_dir = args
    os.makedirs(out_dir, exist_ok=True)

    insts = load_map(os.path.join(trace_dir, "map.tsv"))
    with open(os.path.join(trace_dir, "meta.txt")) as f:
        meta = {k: int(v) for k, v in (l.split("\t") for l in f if l.strip())}
    events = meta["events"]

    # Exact counts of all windows of length 1..5, by static instruction IDs.
    by_ids = [collections.Counter() for _ in range(WINDOW + 1)]
    with open(os.path.join(trace_dir, "windows.tsv")) as f:
        for line in f:
            count, ids = line.split("\t")
            ids = tuple(int(x) for x in ids.split())
            for n in range(1, len(ids) + 1):
                by_ids[n][ids[:n]] += int(count)
    assert sum(by_ids[1].values()) == events

    edges = collections.Counter()
    for (iid,), c in by_ids[1].items():
        for op in insts[iid]["ops"]:
            if op.startswith("i"):
                edges[(insts[iid]["label"], insts[int(op[1:])]["label"])] += c
    n_edges = sum(edges.values())
    rows = [(u, o, c, f"{100 * c / n_edges:.2f}") for (u, o), c in edges.most_common()]
    write_csv(os.path.join(out_dir, "use_edges.csv"), ("user", "operand", "count", "percent"), rows)

    report = [f"# IR use-trace patterns, logic module at `{opts.get('opt', '?')}`\n",
              f"{events:,} executed IR instructions ({meta['frames']} frames), "
              f"{len(insts)} static instructions.\n",
              "## User <- Operand\n",
              md_table(("User", "Operand", "%"), [(f"`{u}`", f"`{o}`", p) for u, o, _, p in rows[:TOP]])]

    for n in range(1, WINDOW + 1):
        total = events - n + 1
        plain = collections.Counter()
        for ids, c in by_ids[n].items():
            plain[" | ".join(insts[i]["label"] for i in ids)] += c
        rows = [(p, c, f"{100 * c / total:.2f}") for p, c in plain.most_common()]
        write_csv(os.path.join(out_dir, f"opcode_n{n}.csv"), ("pattern", "count", "percent"), rows)
        if n == 1:  # every instruction executed at least once
            report += [f"## Window n = 1 (all {len(rows)} executed instructions)\n",
                       md_table(("instruction", "count", "%"), [(f"`{p}`", f"{c:,}", s) for p, c, s in rows])]
        else:
            report += [f"## Window n = {n}\n",
                       md_table(("pattern", "%"), [(f"`{p}`", s) for p, _, s in rows[:TOP]])]

    with open(os.path.join(out_dir, "patterns.md"), "w") as f:
        f.write("\n".join(report))
    render_head(os.path.join(trace_dir, "head.ids"), os.path.join(out_dir, "trace_head.txt"), insts)
    for name in ("map.tsv", "windows.tsv", "meta.txt"):
        shutil.copy(os.path.join(trace_dir, name), os.path.join(out_dir, name))
    print(f"[analyze] {events:,} events -> {out_dir}")


if __name__ == "__main__":
    main()
