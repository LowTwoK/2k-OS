#ifndef SCREEN_H
#define SCREEN_H

#define VGA_ADDRESS 0xA0000
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

// Simple Draw
void draw_pixel(int x, int y, unsigned char color);
void clear(unsigned char color);
void draw_rect(int x, int y, int width, int height, unsigned char color);

//font
void draw_char(char c, int x, int y, unsigned char color);
void draw_string(const char* str, int x, int y, unsigned char color);

#endif