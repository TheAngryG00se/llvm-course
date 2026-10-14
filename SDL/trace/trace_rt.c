/* Runtime for IRTracePass: counts every 5-window of the trace (shorter
 * windows are its prefixes) and keeps a raw slice of it.
 * Env: IR_TRACE_DIR, IR_TRACE_FRAMES, IR_TRACE_HEAD, IR_TRACE_HEAD_FRAME. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define WINDOW     5u
#define ID_BITS    12u
#define ID_NONE    0xFFFu
#define TABLE_BITS 20u
#define TABLE_SIZE (1u << TABLE_BITS)
#define HEAD_MAX   (1u << 22)

extern const char __ir_trace_map[] __attribute__((weak));

static uint64_t tab_key[TABLE_SIZE];
static uint64_t tab_cnt[TABLE_SIZE];
static uint32_t tab_used;

static uint32_t ring[WINDOW - 1u];
static uint64_t n_events;
static uint64_t n_frames;

static uint16_t head[HEAD_MAX];
static uint32_t head_len;
static uint32_t head_cap;
static uint64_t head_frame;
static uint64_t head_start_event;

static uint64_t max_frames;
static const char *out_dir;
static int finished;

static uint64_t env_u64(const char *name, uint64_t fallback) {
    const char *s = getenv(name);
    return s ? strtoull(s, NULL, 10) : fallback;
}

static void count_window(uint64_t key) {
    uint32_t h = (uint32_t)((key * 0x9E3779B97F4A7C15ull) >> (64u - TABLE_BITS));
    while (tab_cnt[h] != 0u && tab_key[h] != key) {
        h = (h + 1u) & (TABLE_SIZE - 1u);
    }
    if (tab_cnt[h] == 0u) {
        tab_key[h] = key;
        if (++tab_used > TABLE_SIZE / 2u) {
            fprintf(stderr, "[ir-trace] window table is full\n");
            abort();
        }
    }
    tab_cnt[h]++;
}

static FILE *open_out(const char *name) {
    char path[4096];
    snprintf(path, sizeof path, "%s/%s", out_dir, name);
    FILE *f = fopen(path, "w");
    if (f == NULL) {
        perror(path);
    }
    return f;
}

static void write_window(FILE *f, uint64_t count, const uint32_t *ids, uint32_t len) {
    fprintf(f, "%llu", (unsigned long long)count);
    for (uint32_t i = 0u; i < len; i++) {
        fprintf(f, "%c%u", i == 0u ? '\t' : ' ', ids[i]);
    }
    fputc('\n', f);
}

static void finish(void) {
    if (finished) {
        return;
    }
    finished = 1;

    FILE *f = open_out("map.tsv");
    if (f != NULL) {
        if (__ir_trace_map != NULL) {
            fputs(__ir_trace_map, f);
        }
        fclose(f);
    }

    /* count \t id0 id1 ...; the last 4 events start shorter windows */
    f =open_out("windows.tsv");
    if (f != NULL) {
        for (uint32_t h = 0u; h < TABLE_SIZE; h++) {
            if (tab_cnt[h] == 0u) {
                continue;
            }
            uint32_t ids[WINDOW];
            for (uint32_t i = 0u; i < WINDOW; i++) {
                ids[i] = (uint32_t)(tab_key[h] >> (ID_BITS * i)) & ID_NONE;
            }
            write_window(f, tab_cnt[h], ids, WINDOW);
        }
        uint32_t tail = n_events < WINDOW - 1u ? (uint32_t)n_events : WINDOW - 1u;
        uint32_t last[WINDOW - 1u];
        for (uint32_t i = 0u; i < tail; i++) {
            last[i] = ring[(n_events - tail + i) % (WINDOW - 1u)];
        }
        for (uint32_t s = 0u; s < tail; s++) {
            write_window(f, 1u, last + s, tail - s);
        }
        fclose(f);
    }

    f = open_out("head.ids");
    if (f != NULL) {
        for (uint32_t i = 0u; i < head_len; i++) {
            fprintf(f, "%u\n", head[i]);
        }
        fclose(f);
    }

    f = open_out("meta.txt");
    if (f != NULL) {
        fprintf(f, "events\t%llu\nframes\t%llu\ndistinct_5_windows\t%u\n"
                   "head_frame\t%llu\nhead_start_event\t%llu\nhead_len\t%u\n",
                (unsigned long long)n_events, (unsigned long long)n_frames, tab_used,
                (unsigned long long)head_frame, (unsigned long long)head_start_event,
                head_len);
        fclose(f);
    }

    fprintf(stderr, "[ir-trace] %llu events, %llu frames, %u distinct 5-windows -> %s\n",
            (unsigned long long)n_events, (unsigned long long)n_frames, tab_used, out_dir);
}

__attribute__((constructor)) static void ir_trace_init(void) {
    out_dir = getenv("IR_TRACE_DIR");
    if (out_dir == NULL) {
        out_dir = ".";
    }
    max_frames = env_u64("IR_TRACE_FRAMES", 3u);
    head_cap = (uint32_t)env_u64("IR_TRACE_HEAD", 20000u);
    if (head_cap > HEAD_MAX) {
        head_cap = HEAD_MAX;
    }
    head_frame = env_u64("IR_TRACE_HEAD_FRAME", 1u);
    head_start_event = UINT64_MAX;
    atexit(finish);
}

void __ir_trace_inst(uint32_t id) {
    if (n_events >= WINDOW - 1u) {
        uint64_t key = id;
        for (uint32_t i = 1u; i < WINDOW; i++) {
            key = (key << ID_BITS) | ring[(n_events - i) % (WINDOW - 1u)];
        }
        count_window(key);
    }
    ring[n_events % (WINDOW - 1u)] = id;

    if (n_frames >= head_frame && head_len < head_cap) {
        if (head_len == 0u) {
            head_start_event = n_events;
        }
        head[head_len++] = (uint16_t)id;
    }
    n_events++;
}

void __ir_trace_frame(void) {
    n_frames++;
    if (max_frames != 0u && n_frames >= max_frames) {
        finish();
        exit(0);
    }
}
