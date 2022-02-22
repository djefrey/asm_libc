BITS 64

SECTION .text

GLOBAL strlen
GLOBAL strchr
GLOBAL strrchr
GLOBAL strcmp
GLOBAL strncmp
GLOBAL strcasecmp
GLOBAL strstr
GLOBAL strpbrk
GLOBAL strcspn

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
    JMP strcmp
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
    CMP RDX, 0
    JE strncmp_err
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
strncmp_err:
    MOV RAX, 0
    RET


; RDI : s1
; RSI : s2
strcasecmp:
    MOV R10B, BYTE [RDI]
    MOV R11B, BYTE [RSI]

strcasecmp_upcase1:
    CMP R10B, 'A'
    JL strcasecmp_upcase2
    CMP R10B, 'Z'
    JG strcasecmp_upcase2
    ADD R10B, 32

strcasecmp_upcase2:
    CMP R11B, 'A'
    JL strcasecmp_cmp
    CMP R11B, 'Z'
    JG strcasecmp_cmp
    ADD R11B, 32

strcasecmp_cmp:
    CMP R10B, R11B
    JNE strcasecmp_return
    CMP R10B, 0
    JE strcasecmp_return
    INC RDI
    INC RSI
    JMP strcasecmp

strcasecmp_return:
    MOVZX RAX, R10B
    MOVZX RBX, R11B
    SUB RAX, RBX
    RET

; RDI : haystack
; RSI : needle (to find)
strstr:
    MOV R9, RDI

strstr_loop:
    CMP BYTE [RDI], 0
    JE strstr_no_match

strstr_find_match:
    XOR RCX, RCX

strstr_find_match_loop:
    MOV R10B, [RDI + RCX]
    MOV R11B, [RSI + RCX]
    INC RCX

    CMP R11B, 0
    JE strstr_match
    CMP R10B, 0
    JE strstr_end_loop
    CMP R10B, R11B
    JE strstr_find_match_loop
    JMP strstr_end_loop

strstr_end_loop:
    INC RDI
    JMP strstr_loop

strstr_no_match:
    MOV RAX, R9
    RET

strstr_match:
    MOV RAX, RDI
    RET

; RDI : str
; RSI : chars
strpbrk:
strpbrk_find_match:
    XOR RCX, RCX
    MOV R10B, BYTE [RDI]
    CMP R10B, 0
    JE strpbrk_no_match

strpbrk_find_match_loop:
    MOV R11B, BYTE [RSI + RCX]

    CMP R11B, 0
    JE strpbrk_find_match_end
    CMP R10B, R11B
    JE strpbrk_match
    INC RCX
    JMP strpbrk_find_match_loop

strpbrk_find_match_end:
    INC RDI
    JMP strpbrk_find_match

strpbrk_no_match:
    XOR RAX, RAX
    RET

strpbrk_match:
    MOV RAX, RDI
    RET

; RDI : str
; RSI : accept
strcspn:
    XOR RAX, RAX

strcspn_loop:
    XOR RCX, RCX
    MOV R10B, [RDI + RAX]
    CMP R10B, 0
    JE strcspn_return

strcspn_check_valid:
    MOV R11B, [RSI + RCX]
    CMP R11B, 0
    JE strcspn_return
    CMP R10B, R11B
    JE strcspn_loop_end
    INC RCX
    JMP strcspn_check_valid

strcspn_loop_end:
    INC RAX
    JMP strcspn_loop

strcspn_return:
    RET