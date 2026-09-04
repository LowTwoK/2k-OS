; Boot Section For 2k OS 32bit Operating System

[org 0x7c00]
KERNEL_OFFSET equ 0x1000
[bits 16]

start:
    
    mov [BOOT_DRIVE], dl
    
    mov ax, 0x0013
    int 0x10
    
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    ; Disk load kernel
    mov bx, KERNEL_OFFSET
    mov dh, 15 ; Sector
    mov dl, [BOOT_DRIVE]
    call disk_load

    ; PM Ready
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:init_pm

disk_load:
    pusha
    push dx

    xor ax, ax
    int 0x13
    
    mov ah, 0x02
    mov al, dh ; Sector
    mov ch, 0x00; Cylinder 0
    mov dh, 0x00; Head 0
    mov cl, 0x02
    int 0x13
    jc disk_error

    pop dx
    cmp al, dh ; Sector Checkup
    jne disk_error
    popa
    ret

disk_error:
    mov si, MSG_DISK_ERROR
    call print_str_16
    hlt

print_str_16:
    mov ah, 0x0e
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

BOOT_DRIVE: db 0
MSG_DISK_ERROR: db '2k OS Disk read error!', 0

; GDT

gdt_start:

gdt_null:
    dd 0x0
    dd 0x0
    
gdt_code:
    dw 0xffff ; lim
    dw 0x0000 ; base
    db 0x00 ; base
    db 10011010b ; Access Byte
    db 11001111b ; flags
    db 0x00
    
gdt_data:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00
    
gdt_end:
    
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; GDT Size
    dd gdt_start
    
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; 32bit PM
[bits 32]
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    call KERNEL_OFFSET

    hlt

times 510-($-$$) db 0
dw 0xaa55
