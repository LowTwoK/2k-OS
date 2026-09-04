#include "../include/screen.h"
#include "../include/port.h"
#include "../include/font.h"

void draw_pixel(int x, int y, unsigned char color) {
    if (x < 0 || x >= SCREEN_WIDTH || y < 0 || y >= SCREEN_HEIGHT) return;

    unsigned char* vga = (unsigned char*) VGA_ADDRESS;
    unsigned int offset = (y * (SCREEN_WIDTH / 8)) + (x / 8);
    unsigned char bit_mask = 0x80 >> (x % 8);

    outb(0x3CE, 0x08);
    outb(0x3CF, bit_mask);

    outb(0x3CE, 0x05);
    outb(0x3CF, 0x02);

    volatile unsigned char dummy = vga[offset];
    vga[offset] = color;
}

void clear(unsigned char color) {
    for (int y = 0; y < SCREEN_HEIGHT; y++) {
        for (int x = 0; x < SCREEN_WIDTH; x++) {
            draw_pixel(x, y, color);
        }
    }
}

void draw_rect(int x, int y, int width, int height, unsigned char color) {
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            draw_pixel(x + j, y + i, color);
        }
    }
}

void draw_char(char c, int x, int y, unsigned char color) {
    for (int row = 0; row < 8; row++) {
        unsigned char glyph_row = font8x8_basic[(unsigned char)c][row];
        for (int col = 0; col < 8; col++) {
            if (glyph_row & (0x80 >> col)) {
                draw_pixel(x + col, y + row, color);
            }
        }
    }
}

void draw_string(const char* str, int x, int y, unsigned char color) {
    int cur_x = x;
    int cur_y = y;

    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] == '\n') {
            cur_x = x;
            cur_y += 10; // new line space 10 pixel
            continue;
        }

        draw_char(str[i], cur_x, cur_y, color);
        cur_x += 8; // Move right 8 pixel for next char

        // Newline
        if (cur_x + 8 >= SCREEN_WIDTH) {
            cur_x = x;
            cur_y += 10;
        }
    }
}