.model tiny
.code
org 100h

Start:      
        mov ah, 09h
        mov dx, offset Greeting
        int 21h

        mov ah, 3fh
        mov bx, 0000h
        mov cx, buffer_size

        mov dx, offset buffer
        int 21h

        mov ah, 09h             ;printing of just entered passward
        mov bp, offset buffer
        add bp, 14
        mov bx, '$'
        mov [bp], bx
        int 21h

        mov si, offset PASSWORD
        mov bx, ds
        mov es, bx
        mov di, offset buffer
        mov cx, buffer_size-1

        repe cmpsb

        jne PERMISSION_DENIED
        mov ah, 09h
        mov dx, offset permision_accepted_message
        int 21h
        jmp Continue

        PERMISSION_DENIED:
        mov ah, 09h
        mov dx, offset permision_denied_message
        int 21h

        Continue:

        mov ax, 4c00h
        int 21h

        

.data
PASSWORD db "12345678901234$"
Greeting db "For Admin right please confirm that you`re real human:", 0dh, 0ah, "$"
permision_denied_message db "Permision denied$"
permision_accepted_message db "Permision accepted$"
buffer_size = 15
buffer dw buffer_size dup (0)
end Start