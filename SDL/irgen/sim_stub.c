/* Headless sim.h backend for `make jit-check`: hashes every put_pixel call,
 * replays a fixed key script and quits after STUB_FRAMES frames, so the
 * native and the JIT-run logic can be compared by a single printed hash.
 */
#include "sim.h"

#include <stdio.h>

#define STUB_FRAMES 12u

static uint64_t pixel_hash = 1469598103934665603ull; /* FNV-1a offset basis */
static uint32_t frame = 0u;

static void mix(uint32_t value) {
    pixel_hash = (pixel_hash ^ value) * 1099511628211ull;
}

void put_pixel(uint32_t y, uint32_t x, uint32_t argb) {
    mix(y);
    mix(x);
    mix(argb);
}

void flush(void) {
    frame++;
}

bool should_quit(void) {
    if (frame < STUB_FRAMES) {
        return false;
    }
    printf("frames=%u hash=%016llx\n", frame, (unsigned long long)pixel_hash);
    return true;
}

/* Touches every input path of app(): preset switch, pause/resume, reset. */
bool is_key_pressed(uint32_t key) {
    if (key == KEY_2) {
        return frame >= 2u && frame < 4u;
    } else if (key == KEY_5) {
        return frame == 6u;
    } else if (key == KEY_SPACE) {
        return frame == 7u || frame == 9u;
    } else if (key == KEY_R) {
        return frame == 10u;
    }
    return false;
}
