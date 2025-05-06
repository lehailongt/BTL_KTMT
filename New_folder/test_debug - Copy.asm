
.model small
.stack 100h
.data

    innhap db 13, 10, 'ki tu ban da nhap la: $'
    
.code

main proc
    mov ax, @data       ;tro dia chi ban dau @data luu vao ax
    mov ds, ax          ;nap dia chi vao thanh ghi ds
    
    mov ah, 1           ;chon che do lay 1 ki tu nhap ham ngat 21h/01
    int 21h             ;thuc hien lenh lay 1 ki tu nhap tu ban phim
    mov bl, al          ;luu gia tri ki tu da nhap vao thanh ghi bl tam
    mov ah, 9
    lea dx, innhap
    int 21h
    mov dl, bl          ;nap gia tri luu o thanh ghi al vao thanh ghi dl
    mov ah, 2           ;chon che do in ra 1 ki tu ham ngat 21h/02
    int 21h             ;thuc hien in 1 ki tu chu so
    
    mov ah, 4ch         
    int 21h             ;ket thuc chuong trinh
main endp