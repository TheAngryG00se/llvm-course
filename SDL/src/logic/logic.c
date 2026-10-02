/* Gray-Scott reaction-diffusion simulation core. No SDL, no malloc, no
 * structs, no switch
 */
#include "sim.h"

#define GRID_WIDTH  SCREEN_WIDTH
#define GRID_HEIGHT SCREEN_HEIGHT

#define DIFFUSE_U 0.2097f
#define DIFFUSE_V 0.1050f
#define TIME_STEP 1.0f

#define STEPS_PER_FRAME 8u

/* Coral, Spots and loops, Chaos, Stripes, Waves*/
static const float PRESET_F[5] = { 0.0540f, 0.0180f, 0.0260f, 0.029f, 0.014f };
static const float PRESET_K[5] = { 0.0620f, 0.0510f, 0.0510f, 0.057f, 0.045f };

/* U=1/V=0 everywhere with a seeded circular blob in the middle. */
static void init_grid(float (*restrict u)[GRID_WIDTH], float (*restrict v)[GRID_WIDTH]) {
    for (uint32_t y = 0u; y < GRID_HEIGHT; y++) {
        for (uint32_t x = 0u; x < GRID_WIDTH; x++) {
            u[y][x] = 1.0f;
            v[y][x] = 0.0f;
        }
    }

    uint32_t radius = 50u;
    uint32_t cy = GRID_HEIGHT / 2u;
    uint32_t cx = GRID_WIDTH / 2u;
    for (uint32_t y = cy - radius; y < cy + radius; y++) {
        for (uint32_t x = cx - radius; x < cx + radius; x++) {
            int32_t dy = (int32_t)y - (int32_t)cy;
            int32_t dx = (int32_t)x - (int32_t)cx;
            if ((uint32_t)(dx * dx + dy * dy) <= radius * radius) {
                u[y][x] = 0.50f;
                v[y][x] = 0.25f;
            }
        }
    }
}

static void sim_step(float (*restrict u)[GRID_WIDTH], float (*restrict v)[GRID_WIDTH],
                     float (*restrict u_next)[GRID_WIDTH], float (*restrict v_next)[GRID_WIDTH],
                     float feed, float kill) {
    for (uint32_t y = 0u; y < GRID_HEIGHT; y++) {
        uint32_t yn = (y + 1u) % GRID_HEIGHT;
        uint32_t ys = (y + GRID_HEIGHT - 1u) % GRID_HEIGHT;

        for (uint32_t x = 0u; x < GRID_WIDTH; x++) {
            uint32_t xe = (x + 1u) % GRID_WIDTH;
            uint32_t xw = (x + GRID_WIDTH - 1u) % GRID_WIDTH;

            float lap_u = u[ys][xw] * 0.05f + u[ys][x] * 0.2f + u[ys][xe] * 0.05f
                        + u[y][xw]  * 0.2f  + u[y][x]  * -1.0f + u[y][xe]  * 0.2f
                        + u[yn][xw] * 0.05f + u[yn][x] * 0.2f  + u[yn][xe] * 0.05f;

            float lap_v = v[ys][xw] * 0.05f + v[ys][x] * 0.2f + v[ys][xe] * 0.05f
                        + v[y][xw]  * 0.2f  + v[y][x]  * -1.0f + v[y][xe]  * 0.2f
                        + v[yn][xw] * 0.05f + v[yn][x] * 0.2f  + v[yn][xe] * 0.05f;

            float uu = u[y][x];
            float vv = v[y][x];
            float reaction = uu * vv * vv;

            u_next[y][x] = uu + (DIFFUSE_U * lap_u - reaction + feed * (1.0f - uu)) * TIME_STEP;
            v_next[y][x] = vv + (DIFFUSE_V * lap_v + reaction - (feed + kill) * vv) * TIME_STEP;
        }
    }

    for (uint32_t y = 0u; y < GRID_HEIGHT; y++) {
        for (uint32_t x = 0u; x < GRID_WIDTH; x++) {
            u[y][x] = u_next[y][x];
            v[y][x] = v_next[y][x];
        }
    }
}

static uint32_t colormap(float value) {
    float t = value * 3.0f;
    if (t < 0.0f) {
        t = 0.0f;
    } else if (t > 1.0f) {
        t = 1.0f;
    }

    uint32_t r = (uint32_t)(t * t * 255.0f);
    uint32_t g = (uint32_t)(t * 255.0f);
    uint32_t b = (uint32_t)(t * (2.0f - t) * 255.0f);

    return 0xFF000000u | (r << 16) | (g << 8) | b;
}

void app(void) {
    float u[GRID_HEIGHT][GRID_WIDTH];
    float v[GRID_HEIGHT][GRID_WIDTH];
    float u_next[GRID_HEIGHT][GRID_WIDTH];
    float v_next[GRID_HEIGHT][GRID_WIDTH];

    init_grid(u, v);

    uint32_t preset_index = 0u;
    bool paused = false;
    bool prev_space = false;
    bool prev_r = false;

    while (!should_quit()) {
        bool space_now = is_key_pressed(KEY_SPACE);
        if (space_now && !prev_space) {
            paused = !paused;
        }
        prev_space = space_now;

        bool r_now = is_key_pressed(KEY_R);
        if (r_now && !prev_r) {
            init_grid(u, v);
        }
        prev_r = r_now;

        if (is_key_pressed(KEY_1)) {
            preset_index = 0u;
        } else if (is_key_pressed(KEY_2)) {
            preset_index = 1u;
        } else if (is_key_pressed(KEY_3)) {
            preset_index = 2u;
        } else if (is_key_pressed(KEY_4)) {
            preset_index = 3u;
        } else if (is_key_pressed(KEY_5)) {
            preset_index = 4u;
        }

        if (!paused) {
            for (uint32_t s = 0u; s < STEPS_PER_FRAME; s++) {
                sim_step(u, v, u_next, v_next, PRESET_F[preset_index], PRESET_K[preset_index]);
            }
        }

        for (uint32_t y = 0u; y < GRID_HEIGHT; y++) {
            for (uint32_t x = 0u; x < GRID_WIDTH; x++) {
                put_pixel(y, x, colormap(v[y][x]));
            }
        }
        flush();
    }
}
