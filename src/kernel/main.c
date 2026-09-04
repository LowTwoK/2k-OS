#include "../include/screen.h"
#include "../io/screen.c"

void twok_main()
{
    clear(0x00); // Black
    // x,y,w,h,color
    draw_rect(50, 50, 100, 60, 4);
    draw_rect(180, 50, 80, 80, 1);
    
    //Line
    for(int i=0; i<320; i++)
    {
        draw_pixel(i, 150, 2);
    }
}