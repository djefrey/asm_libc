BITS 64

SECTION .text

GLOBAL memset
GLOBAL memcpy
GLOBAL memmove

; RDI : ptr
; RSI : value (SIL : 8bit)
; RDX : size
memset:
    XOR RCX, RCX
memset_loop:
    CMP RCX, RDX
    JE memset_return
    MOV BYTE [RDI + RCX], SIL
    ADD RCX, 1
    JMP memset_loop
memset_return:
    MOV RAX, RDI
    RET

; RDI : dest
; RSI : src
; RDX : size
memcpy:
    XOR RCX, RCX
memcpy_loop:
    CMP RCX, RDX
    JE memcpy_return
    MOV AL, BYTE [RSI + RCX]
    MOV BYTE [RDI + RCX], AL
    ADD RCX, 1
    JMP memcpy_loop
memcpy_return:
    MOV RAX, RDI
    RET

; RDI : dest
; RSI : src
; RDX : size
memmove:
    XOR RCX, RCX
    XOR RAX, RAX
memmove_clone:
    CMP RCX, RDX
    JE memmove_cpy
    MOV AL, BYTE [RSI + RCX]
    PUSH RAX
    ADD RCX, 1
    JMP memmove_clone
memmove_cpy:
    CMP RCX, 0
    JE memmove_return
    SUB RCX, 1
    POP RAX
    MOV BYTE [RDI + RCX], AL
    JMP memmove_cpy
memmove_return:
    MOV RAX, RDI
    RET