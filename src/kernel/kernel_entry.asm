[bits 32]
[extern twok_main]
global _start
_start:
    call twok_main
    jmp $