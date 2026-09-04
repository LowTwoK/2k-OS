#ifndef SCREEN_H
#define SCREEN_H

#define VGA_ADDRESS 0xA0000
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

void draw_pixel(int x, int y, unsigned char color);
void clear(unsigned char color);
void draw_rect(int x, int y, int width, int height, unsigned char color);

#endif
