
.model small
.stack 100h
.data
    
    nhap db 13, 10, 'moi ban nhap ki tu: $'
    innhap db 13, 10, 'ki tu ban da nhap la: $'
    day_trong db 'Hell$'
    day_ngoai db '$$$$$'

.code

main proc
    mov ax, @data       ;luu dia chi @data vao thanh ghi tam ax
    mov ds, ax          ;chuyen dia chi da luu trong ax vao ds 
    mov es, ax          ;chuyen dia chi da luu trong ax vao es
    
    lea si, day_trong   ;tro si toi xau ki tu nguon
    lea di, day_ngoai   ;tro di toi xau ki tu dich
    cld                 ;clear co de cung tang di, si
    mov cx, 4           ;so lan lap la 4
    rep movsw           ;thuc hien sao chep du lieu nguon sang dich 
    
    mov ah, 9           ;chon che do in 1 chuoi ki tu ham ngat INT 21h/09h
    lea dx, day_ngoai   ;tro toi chuoi ki tu day_ngoai
    int 21h             ;
    
    mov ah, 9           ;chon che do in 1 chuoi ki tu ham ngat INT 21h/09h
    lea dx, nhap        ;tro toi chuoi ki tu innhap
    int 21h             ;thuc hien lenh in chuoi ki tu
    
    
    mov ah, 1           ;chon che do lay 1 ki tu nhap ham ngat INT 21h/01h
    int 21h             ;thuc hien lenh ngat lay 1 ki tu
    mov bl, al          ;nap gia tri thanh ghi al vao thanh ghi bl
    
    push ax             ;day thanh ghi ax vao stack
    
    mov bp, ss          ;tro toi dau ngan xep stack
    add bp, 100h        ;tang them dia chi 100h
    
    mov ah, 9           ;chon che do in 1 chuoi ki tu ham ngat INT 21h/09h
    lea dx, innhap      ;tro toi chuoi ki tu innhap
    int 21h             ;thuc hien lenh in chuoi ki tu
    
    pop dx              ;lay phan tu ra khoi stack va gan vao thanh ghi dx
    mov dh, 0           ;reset lai phan dh giu lai dl
    
    mov ah, 2           ;chon che do in 1 ki tu ham ngat INT 21h/02h
    int 21h             ;thuc hien lenh in 1 ki tu
    
    mov ah, 4ch         
    int 21h             ;ket thuc chuong trinh
main endp