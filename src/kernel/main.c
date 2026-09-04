#include "../include/screen.h"

void twok_main()
{
    clear(15);

    draw_rect(0, 0, 640, 30, 1);

    draw_string("2k OS By Low2k", 10, 10, 15);
    draw_string("ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz", 10, 20, 15);
}