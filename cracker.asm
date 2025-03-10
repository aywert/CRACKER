.model tiny
.code
org 100h

Start:   
        ;-------------------------------------------------------------
        ;                       GREETING
        ;-------------------------------------------------------------
        mov ah, 09h
        mov dx, offset Greeting
        int 21h
        ;-------------------------------------------------------------

        ;-------------------------------------------------------------
        ;               GETTING BUFFER FROM USER
        ;-------------------------------------------------------------
        mov di, offset buffer
        mov cx, -1
        xor ax, ax
        READ_SIMBOL:

        
        inc cx
        mov ah, 01h
        int 21h
        mov ds:[di], al
        inc di
        cmp al, 0Dh

        jne READ_SIMBOL
        ;-------------------------------------------------------------
        ;               END_GETTING BUFFER FROM USER
        ;-------------------------------------------------------------

        cmp cx, 0
        ja CHECK_NUM_OF_SYMBOLS
        jmp Continue

        CHECK_NUM_OF_SYMBOLS:
        ;cmp cx, buffer_size
        
        ;mov ah, 3fh
        ;mov bx, 0000h
        ;mov cx, buffer_size

        ;mov dx, offset buffer
        ;int 21h

        ;cmp cx, ax

        push di 
        push bx
        call cash_counter
        pop bx
        pop di

        mov ax, hash
        cmp ax, hash_const
        je Continue

        jb MISTAKE_HANDLE

        mov read_symbols, cx
        ;---------------------------------------------------------------
        ;                       DEBUG WINDOW WHAT IS IN MY BUFFER?
        ;---------------------------------------------------------------
        ;mov ah, 09h             ;printing of just entered passward
        ;mov bp, offset buffer
        ;add bp, buffer_size
        ;mov bx, '$'
        ;mov [bp], bx
        ;mov dx, offset buffer
        ;int 21h
        ;---------------------------------------------------------------

        ;STD                                            ;sets flag DF 1 which makes compering of strings in reversed order
        mov si, offset PASSWORD ;+ buffer_size - 1      ;address of the string(password) to compare with
        mov bx, ds
        mov es, bx
        mov di, offset buffer ;+ buffer_size - 1        ;es:[di] absolute address of input buffer
        mov cx, buffer_size; read_symbols;                             ;___________________AVERAGE_vulnerability__________________ (have to change value on 0)

        repe cmpsb

        jne PERMISSION_DENIED

        mov ah, 09h
        mov dx, offset permision_provided_message
        int 21h
        jmp Continue

        PERMISSION_DENIED:
        mov ah, 09h
        mov dx, offset permision_denied_message
        int 21h

        jmp EXIT

        

        ;-------------------------------------------------------------
        ;                       MISTAKE HANDLE
        ;-------------------------------------------------------------
MISTAKE_HANDLE:
        mov ah, 09h
        mov dx, offset not_right_length_password
        int 21h
        jmp EXIT
        ;---------------------END_OD_MISTAKE_HANDLE-------------------

Continue:
        mov ah, 09h
        mov dx, offset victory_message
        int 21h

EXIT:
        mov ax, 4c00h
        int 21h

;---------------------------------------------------------------------
;Entry:  CX - how many to count 
;Exit: 
;Destr: AX DI Cash BX
;---------------------------------------------------------------------
        cash_counter proc
        xor bx, bx
        mov di, offset buffer
        CashCount:
        mov bl, ds:[di]
        inc di
        add hash, bx
        loop CashCount
        
        ret
        endp
        
.data

Greeting db "For Admin rights please enter 8 symbols-length password:", 0dh, 0ah, "$"
not_right_length_password db "Please try again. Password have to be 8 symbols long" , 0dh, 0ah, "$"
victory_message  db "You did it, my friend! I am defeated..." , 0dh, 0ah, "$"
permision_denied_message  db "Permision denied" , 0dh, 0ah, "$"
permision_provided_message db "Permision provided" , 0dh, 0ah, "$"
buffer_size = 8

hash dw 0

hash_const dw 0c3h
buffer db buffer_size + 1 dup (0) ;+ 1 for a symbol serving as the ending of the string

PASSWORD db "12345678"
read_symbols dw 0

end Start