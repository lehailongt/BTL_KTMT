
.model small
.stack 100h
.data
    
    nhap db 13, 10, 'moi ban nhap ki tu: $'
    innhap db 13, 10, 'ki tu ban da nhap la: $'
    
.code

main proc
    mov ax, @data       
    mov ds, ax
    
    mov ah, 1           ;chon che do lay 1 ki tu nhap
    int 21h
    mov dl, al
    sub dl, '0'
    mov ah, 2
    int 21h
    
    mov ah, 4ch         
    int 21h             ;ket thuc chuong trinh
main endp