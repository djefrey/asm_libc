BITS 64

SECTION .text

GLOBAL _start

_start:
    MOV RAX, 60
    MOV RDI, 0
    SYSCALL