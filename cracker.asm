.model tiny
.code
org 100h

Start:    
        NOT_CORRECT_PASSWORD:
        ;-------------------------------------------------------------
        ;                       GREETING
        ;-------------------------------------------------------------
        mov ah, 09h
        mov dx, offset Greeting
        int 21h
        ;-------------------------------------------------------------

        ;-------------------------------------------------------------
        ;               GETTING OF THE BUFFER FROM USER
        ;-------------------------------------------------------------
        mov ah, 3fh
        mov bx, 0000h
        mov cx, buffer_size

        mov dx, offset buffer
        int 21h

        cmp cx, ax
        jne MISTAKE_HANDLE

        
        ;-------------------------------------------------------------

        ;mov ah, 09h             ;printing of just entered passward
        ;mov bp, offset buffer
        ;add bp, buffer_size
        ;mov bx, '$'
        ;mov [bp], bx
        ;int 21h

        ;STD                                            ;sets flag DF 1 which makes compering of strings in reversed order
        mov si, offset PASSWORD ;+ buffer_size - 1      ;address of the string(password) to compare with
        mov bx, ds
        mov es, bx
        mov di, offset buffer ;+ buffer_size - 1        ;es:[di] absolute address of input buffer
        mov cx, buffer_size                             ;___________________AVERAGE_vulnerability__________________ (have to change value on 0)

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

        jmp NOT_CORRECT_PASSWORD

        

        ;-------------------------------------------------------------
        ;                       MISTAKE HANDLE
        ;-------------------------------------------------------------
        MISTAKE_HANDLE:
        mov ah, 09h
        mov dx, offset not_right_length_password
        int 21h
        jmp NOT_CORRECT_PASSWORD
        ;---------------------END_OD_MISTAKE_HANDLE-------------------

        Continue:

        mov ax, 4c00h
        int 21h

        

.data
PASSWORD db "12345678$"
Greeting db "For Admin rights please enter 8 symbols-length password:", 0dh, 0ah, "$"
not_right_length_password db "Please try again. Password have to be 8 symbols long" , 0dh, 0ah, "$"
permision_denied_message  db "Permision denied" , 0dh, 0ah, "$"
permision_provided_message db "Permision provided" , 0dh, 0ah, "$"
buffer_size = 8
buffer dw buffer_size dup (0)
end Start