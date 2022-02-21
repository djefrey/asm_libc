BITS 64

SECTION .text

GLOBAL strlen
GLOBAL strchr
GLOBAL strrchr
GLOBAL strcmp
GLOBAL strncmp
GLOBAL strcasecmp

; RDI : string
strlen:
    XOR RCX, RCX
    CMP BYTE [RDI], 0
    JE strlen_return
strlen_count:
    INC RCX
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
    INC RCX
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
    DEC RCX
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
    MOV R10B, BYTE [RDI]
    MOV R11B, BYTE [RSI]
    CMP R10B, R11B
    JNE strcmp_return
    CMP R10B, 0
    JE strcmp_return
    INC RDI
    INC RSI
    JMP my_strcmp
strcmp_return:
    MOVZX RAX, R10B
    MOVZX RBX, R11B
    SUB RAX, RBX
    RET

; RDI : s1
; RSI : s2
; RDX : n
strncmp:
    XOR RCX, RCX
strncmp_loop:
    CMP RCX, RDX
    JE strncmp_return
    MOV R10B, BYTE [RDI + RCX]
    MOV R11B, BYTE [RSI + RCX]
    CMP R10B, R11B
    JNE strcmp_return
    CMP R10B, 0
    JE strcmp_return
    INC RCX
    JMP strncmp_loop
strncmp_return:
    MOVZX RAX, R10B
    MOVZX RBX, R11B
    SUB RAX, RBX
    RET


; RDI : s1
; RSI : s2
strcasecmp:
    ENTER 0, 0
    MOV DIL, BYTE [RDI]
    CALL upcase_to_lowcase
    MOV R10B, AL
    LEAVE

    ENTER 0, 0
    MOV DIL, BYTE [RSI]
    CALL upcase_to_lowcase
    MOV R11B, AL
    LEAVE

    CMP R10B, R11B
    JNE strcasecmp_return
    CMP R10B, 0
    JE strcasecmp_return
    INC RDI
    INC RSI
    JMP my_strcasecmp
strcasecmp_return:
    MOVZX RAX, R10B
    MOVZX RBX, R11B
    SUB RAX, RBX
    RET

; RDI : character
upcase_to_lowcase:
    CMP DIL, 'A'
    JL upcase_to_lowcase_return
    CMP DIL, 'Z'
    JG upcase_to_lowcase_return
    ADD DIL, 32
upcase_to_lowcase_return:
    XOR EAX, EAX
    MOV AL, DIL
    RET