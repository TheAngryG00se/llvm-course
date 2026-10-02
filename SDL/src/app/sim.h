#ifndef SIM_H
#define SIM_H

#include <stdint.h>
#include <stdbool.h>

#define SCREEN_WIDTH  800u
#define SCREEN_HEIGHT 600u

#define KEY_SPACE  0u
#define KEY_R      1u
#define KEY_1      2u
#define KEY_2      3u
#define KEY_3      4u
#define KEY_4      5u
#define KEY_5      6u

void put_pixel(uint32_t y, uint32_t x, uint32_t argb);
void flush(void); /* presents the frame and sleeps to cap the frame rate */

bool should_quit(void);
bool is_key_pressed(uint32_t key);

#endif /* SIM_H */
