#include "sim.h"

#include <SDL.h>
#include <stdlib.h>

static SDL_Window *window = NULL;
static SDL_Renderer *renderer = NULL;
static SDL_Texture *texture = NULL;
static uint32_t pixels[SCREEN_HEIGHT][SCREEN_WIDTH];

#define TARGET_FRAME_MS 16u /* ~60 FPS */

static uint32_t last_flush_ticks = 0u;
static bool quit_requested = false;
static bool key_down[7] = { false, false, false, false, false, false, false };

static void init_sdl(void) {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        SDL_Log("SDL_Init failed: %s", SDL_GetError());
        exit(1);
    }

    window = SDL_CreateWindow("Reaction-Diffusion", SDL_WINDOWPOS_CENTERED,
                               SDL_WINDOWPOS_CENTERED, (int)SCREEN_WIDTH,
                               (int)SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
    if (window == NULL) {
        SDL_Log("SDL_CreateWindow failed: %s", SDL_GetError());
        exit(1);
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (renderer == NULL) {
        SDL_Log("SDL_CreateRenderer failed: %s", SDL_GetError());
        exit(1);
    }

    texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888,
                                 SDL_TEXTUREACCESS_STREAMING,
                                 (int)SCREEN_WIDTH, (int)SCREEN_HEIGHT);
    if (texture == NULL) {
        SDL_Log("SDL_CreateTexture failed: %s", SDL_GetError());
        exit(1);
    }
}

static void poll_events(void) {
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        if (event.type == SDL_QUIT) {
            quit_requested = true;
        }
    }

    const uint8_t *state = SDL_GetKeyboardState(NULL);
    key_down[KEY_SPACE] = state[SDL_SCANCODE_SPACE] != 0;
    key_down[KEY_R] = state[SDL_SCANCODE_R] != 0;
    key_down[KEY_1] = state[SDL_SCANCODE_1] != 0;
    key_down[KEY_2] = state[SDL_SCANCODE_2] != 0;
    key_down[KEY_3] = state[SDL_SCANCODE_3] != 0;
    key_down[KEY_4] = state[SDL_SCANCODE_4] != 0;
    key_down[KEY_5] = state[SDL_SCANCODE_5] != 0;
}

void put_pixel(uint32_t y, uint32_t x, uint32_t argb) {
    if (window == NULL) {
        init_sdl();
    }
    pixels[y][x] = argb;
}

void flush(void) {
    SDL_UpdateTexture(texture, NULL, pixels, (int)(SCREEN_WIDTH * sizeof(uint32_t)));
    SDL_RenderClear(renderer);
    SDL_RenderCopy(renderer, texture, NULL, NULL);
    SDL_RenderPresent(renderer);

    /* Frame pacing lives here so logic needs no timing API. Bounded sleep,
     * not an event wait. */
    uint32_t elapsed = (uint32_t)SDL_GetTicks() - last_flush_ticks;
    if (elapsed < TARGET_FRAME_MS) {
        SDL_Delay(TARGET_FRAME_MS - elapsed);
    }
    last_flush_ticks = (uint32_t)SDL_GetTicks();
}

bool should_quit(void) {
    if (window == NULL) {
        init_sdl();
    }
    poll_events();
    return quit_requested;
}

bool is_key_pressed(uint32_t key) {
    if (key >= 7u) {
        return false;
    }
    return key_down[key];
}
