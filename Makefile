ASM = nasm
CC = gcc
LD = ld
QEMU = qemu-system-x86_64

CFLAGS = -m32 -ffreestanding -fno-pie -c
LDFLAGS = -m elf_i386 -Ttext 0x1000 --oformat binary

# Directories
SRC_DIR = src
BUILD_DIR = build

# Source
BOOT_SRC = $(SRC_DIR)/boot/boot.asm
ENTRY_SRC = $(SRC_DIR)/kernel/kernel_entry.asm
KERNEL_C = $(SRC_DIR)/kernel/main.c

BOOT_BIN = $(BUILD_DIR)/boot.bin
ENTRY_OBJ = $(BUILD_DIR)/kernel_entry.o
KERNEL_OBJ = $(BUILD_DIR)/kernel.o
KERNEL_BIN = $(BUILD_DIR)/kernel.bin
OS_IMAGE = $(BUILD_DIR)/os_image.bin

.PHONY: all clean run

all: $(OS_IMAGE)

$(BOOT_BIN): $(BOOT_SRC)
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f bin $< -o $@

$(ENTRY_OBJ): $(ENTRY_SRC)
	@mkdir -p $(BUILD_DIR)
	$(ASM) -f elf32 $< -o $@

$(KERNEL_OBJ): $(KERNEL_C)
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(KERNEL_BIN): $(ENTRY_OBJ) $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(BUILD_DIR)/temp.bin
	dd if=/dev/zero of=$(OS_IMAGE) bs=1024 count=1440
	dd if=$(BUILD_DIR)/temp.bin of=$(OS_IMAGE) conv=notrunc

run: $(OS_IMAGE)
	$(QEMU) -drive format=raw,file=$(OS_IMAGE)

clean:
	rm -rf $(BUILD_DIR)/*