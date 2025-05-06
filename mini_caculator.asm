
.model small
.stack 100h
.data  
    intro1 db "  ", 76 dup("*"), "$"
    intro2 db 25 dup("-"), "   KTMT ^_^ Mini Caculator   ", 25 dup("-"), "$"
    intro3 db 30 dup(" "), "$" 
    intro4 db "  ", 76 dup("*"), "$"
    intro5 db 10, 13, 50 dup("-"), "$"
    tb_tiep_tuc db 10,13, "Ban co muon tinh tiep khong? <y/n> $"
    tb_nhap_so1 db 10, 13, "Nhap so thu nhat: $"
    tb_nhap_so2 db 10, 13, "Nhap so thu hai: $"
    tb_tong db 10, 13, "Tong hai so la: $" 
    tb_tich db 10, 13, "Tich hai so la: $"
    tb_mu db 10, 13, "Gia tri a^b la: $" 
    tb_hieu db 10, 13, "Hieu hai so la: $"
    tb_thuong db 10, 13, "Thuong hai so la: $"
    tb_phep_toan db 10, 13, "Phep toan ban chon la: $" 
    dong db 10, 13,"$"
    chia_so_0 db 10, 13, "Phep chia cho so 0 se khong the thuc hien duoc $"
    so_0_mu_0 db 10, 13, "Phep mu luy thua 0 ^ 0 khong the xac dinh duoc $"
    tb_nhap_sai db 10, 13, "Ban nhap sai cu phap rui", 10, 13, "Moi ban nhap lai $"
    x dw ?
    y dw ?
    a dw ?
    b dw ?
    lta dw 0    
    kq dw ? 
    dau dw ?  
    nguyen dw ?
    du dw ?
.code

nhap_so macro so 
    pusha
    local lap, nhap_xong, duong, nhap_lai, xong, tiep1, tiep2
    nhap_lai:  
    mov cx, 1
    mov x, 0
    mov dx, 0
    mov bx, 10 
    mov ah, 1
    int 21h
    cmp al, '-'
    jne lap
    dec cx
    mov x, 1
    mov ah, 1
    int 21h
    lap:
    cmp al, 13
    je nhap_xong
    cmp al, '0'
    jnl tiep1
    call xuong_dong
    jmp nhap_lai
    tiep1:
    cmp al, '9'
    jng tiep2
    call xuong_dong
    jmp nhap_lai
    tiep2:
    inc cx
    sub al, '0'
    mov ah, 0
    mov y, ax
    mov ax, dx
    mul bx
    add ax, y
    mov dx, ax
    mov ah, 1
    int 21h
    jmp lap
    nhap_xong:
    cmp cx, 0
    jg xong
    in_thong_bao dong
    jmp nhap_lai
    xong:
    mov ax, x
    cmp ax, 0
    je duong
    neg dx
    duong:
    mov so, dx
    popa       
nhap_so endm

in_so macro so
    pusha 
    local lap1, lap2
    mov x, 0
    mov cx, 0
    mov ax, so
    mov bx, 10   
    cmp ax, 0
    jnl lap1
    neg ax
    mov x, 1
    
    lap1:
    mov dx, 0
    div bx
    inc cx
    push dx
    cmp ax, 0
    jne lap1
    
    mov bx, x
    cmp bx, 0
    je lap2
    
    push dx
    mov ah, 2
    mov dl, '-'
    int 21h
    pop dx
    
    lap2:
    dec cx
    pop dx
    mov ah, 2
    add dl, '0'
    int 21h
    cmp cx, 0
    jg lap2
    popa    
in_so endm

in_thong_bao macro tb
    push ax
    push dx
    mov ah, 9
    lea dx, tb
    int 21h
    pop dx
    pop ax
    call xuong_dong    
in_thong_bao endm 

main proc
    mov ax, @data
    mov ds, ax 
    call introduction
    tinh_tiep:
    in_thong_bao intro5
    in_thong_bao tb_nhap_so1
    nhap_so a 
    in_thong_bao tb_nhap_so2
    nhap_so b
    in_thong_bao tb_phep_toan
    tiep:
    mov ah, 1
    int 21h
    
    cmp al, '+'
    je tinh_tong
    
    cmp al, '*'
    je tinh_tich
    
    cmp al, '^'
    je tinh_luy_thua
    
    cmp al, '-'
    je tinh_hieu
    
    cmp al, '/'
    je tinh_thuong
    
    call xuong_dong
    jmp tiep 
    
    tiep_tuc:
    in_thong_bao tb_tiep_tuc
    mov ah, 1
    int 21h
    cmp al, 'y'
    je tinh_tiep
         
    mov ah, 4ch
    int 21h
main endp

introduction proc
    in_thong_bao intro1
    in_thong_bao intro2
    in_thong_bao intro3
    in_thong_bao intro4
    ret
introduction endp

xuong_dong proc
    push ax
    push dx
    mov ah, 9
    lea dx, dong
    int 21h
    pop dx
    pop ax
    ret
xuong_dong endp

tinh_tong proc
    in_thong_bao tb_tong
    mov ax, a
    mov bx, b
    add ax, bx
    in_so ax
    jmp tiep_tuc
    ret    
tinh_tong endp

tinh_hieu proc
    in_thong_bao tb_hieu
    mov ax, a
    mov bx, b
    sub ax, bx
    in_so ax
    jmp tiep_tuc
    ret    
tinh_hieu endp

tinh_tich proc
    in_thong_bao tb_tich
    mov ax, a
    mov bx, b
    imul bx
    in_so ax 
    jmp tiep_tuc
    ret
tinh_tich endp

tinh_luy_thua proc 
    in_thong_bao tb_mu
    mov bx, a
    mov cx, b
    cmp bx, 0
    jne tiep_mu
    cmp cx, 0
    jne tiep_mu
    in_thong_bao so_0_mu_0
    jmp tinh_tiep
    tiep_mu:
    mov ax, 1
    cmp cx, 0
    jnl lap_mu
    neg cx
    mov lta, 1
    lap_mu:
    dec cx
    cmp cx, 0
    jl het_mu
    imul bx
    jmp lap_mu
    het_mu:
    mov cx, lta
    cmp cx, 0
    je luy_thua_duong
    mov b, ax
    mov ax, 1
    mov a, ax
    call tinh_thuong
    luy_thua_duong:
    in_so ax
    jmp tiep_tuc
    ret
tinh_luy_thua endp 

tinh_thuong proc
    mov ax, lta
    mov lta, 0
    cmp ax, 1
    je luy_thua_am
    in_thong_bao tb_thuong
    luy_thua_am:
    mov bx, b
    cmp bx, 0
    je chia_khong
    mov dx, 0
    mov cx, 0
    mov ax, a
    cmp ax, 0
    jg duong1
    neg ax
    mov cx, 1
    duong1:
    cmp bx, 0
    jg duong2
    neg bx
    mov dx, 1
    duong2:
    
    cmp dx, cx
    je cung_dau
    push ax
    mov ah, 2
    mov dl, '-'
    int 21h
    pop ax 
    cung_dau:
    
    mov dx, 0 
    div bx
    in_so ax
    mov ax, dx
    cmp dx, 0
    je ket_thuc_chia  
    push ax
    mov ah, 2
    mov dl, '.'
    int 21h
    pop ax
    
    mov cx, 5
    lap_chia:
    dec cx
    mov dx, 10
    mul dx
    mov dx, 0
    div bx
    in_so ax
    cmp dx, 0
    je ket_thuc_chia
    mov ax, dx
    cmp cx, 0
    jg lap_chia
    
    ket_thuc_chia:
    jmp tiep_tuc
    chia_khong:
    in_thong_bao chia_so_0
    jmp tiep_tuc
    ret
tinh_thuong endp 