#include "../include/screen.h"

void draw_pixel(int x, int y, unsigned char color)
{
    if (x<0 || x >= SCREEN_WIDTH || y < 0 || y >= SCREEN_HEIGHT) return;
    unsigned char* vga = (unsigned char*) VGA_ADDRESS;
    vga[y*SCREEN_WIDTH+x] = color;
}

void clear(unsigned char color)
{
    unsigned char* vga = (unsigned char*) VGA_ADDRESS;
    for (int i = 0; i < SCREEN_WIDTH*SCREEN_HEIGHT; i++)
    {
        vga[i] = color;
    }
}

void draw_rect(int x, int y, int width, int height, unsigned char color)
{
    for(int i=0; i < height; i++)
    {
        for(int j=0; j < width; j++)
        {
            draw_pixel(x+j,y+i,color);
        }
    }
}