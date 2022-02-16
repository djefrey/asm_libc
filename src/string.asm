BITS 64

SECTION .text

GLOBAL strlen
GLOBAL strchr
GLOBAL strrchr
GLOBAL strcmp

; RDI : string
strlen:
    XOR RCX, RCX
    CMP BYTE [RDI], 0
    JE strlen_return
strlen_count:
    ADD RCX, 1
    CMP BYTE [RDI + RCX], 0
    JNE strlen_count
strlen_return:
    MOV RAX, RCX
    RET


; RDI : string
; RSI : char
strchr:
    XOR RCX, RCX
    CMP BYTE [RDI], SIL         ; first char == c
    JE strchr_return
    CMP BYTE [RDI + RCX], 0     ; first char == \0
    JE strchr_null
strchr_count:
    ADD RCX, 1
    CMP BYTE [RDI + RCX], SIL   ; char == c
    JE strchr_return
    CMP BYTE [RDI + RCX], 0     ; char == \0
    JNE strchr_count
strchr_null:
    MOV RAX, 0
    RET
strchr_return:
    MOV RAX, RDI
    ADD RAX, RCX
    RET


; RDI : string
; RSI : char
strrchr:
    PUSH RBP
    MOV RBP, RSP

    CALL strlen         ; RAX : strlen

    MOV RSP, RBP
    POP RBP

    CMP RAX, 0          ; strlen == 0
    JE strrchr_null

    MOV RCX, RAX
strrchr_count:
    SUB RCX, 1
    CMP BYTE [RDI + RCX], SIL   ; char == c
    JE strrchr_return
    CMP BYTE [RDI + RCX], 0     ; char == \0
    JE strrchr_null
    CMP RCX, 0
    JE strrchr_null             ; RCX == 0
    JMP strrchr_count
strrchr_null:
    MOV RAX, 0
    RET
strrchr_return:
    MOV RAX, RDI
    ADD RAX, RCX
    RET

; RDI : s1
; RSI : s2
strcmp:
    XOR RAX, RAX
    XOR RBX, RBX
    XOR RCX, RCX
strcmp_loop:
    MOV AL, BYTE [RDI + RCX]
    MOV BL, BYTE [RSI + RCX]
    ADD RCX, 1
    CMP AL, 0
    JE strcmp_return
    CMP BL, 0
    JE strcmp_return
    CMP AL, BL
    JE strcmp_loop
strcmp_return:
    SUB RAX, RBX
    RET
