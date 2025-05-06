;19. Viet chuong trinh hop ngu cho hai chuoi ky tu A va B co do dai la n va m (n>m),
;chi ra xau B co phai la xau con cua xau A khong?
;Neu xau B la xau con cua xau A thi chi ra vi tri xau B o xau A.
.model small    ;khai bao che do bo nho la small
.stack 100h     ;khai bao kich thuoc stack la 100h
.data           ;khai bao cac bien du lieu
    tba db 'Nhap chuoi ki tu A : $'     ;chuoi ki tu thong bao nhap A
    tbb db 'Nhap chuoi ki tu B : $'     ;chuoi ki tu thong bao nhap B
    a db 100 dup('$')                   ;string luu cac ki tu chuoi A
    b db 100 dup('$')                   ;string luu cac ki tu chuoi B
    index db 50 dup(?)                  ;list luu cac chi so xau con B trong xau A
    so_luong dw 0                       ;bien luu so luong cac vi tri xau con
    dong db 13, 10, '$'                 ;chuoi cac ki tu (xuong va thut dong)
    khong_index db 'Xau B khong phai la xau con cua xau A $'        ;thong bao hien khong phai xau con
    co_index db 'Xau B la xau con cua xau A va cac vi tri la: $'    ;thong bao hien co phai la xau con

.code
nhap_xau macro a    ;thuc hien nhap 1 chuoi ki tu
    local lap, ket_thuc     ;khai bao cac nhan cuc bo chi duoc su dung trong macro
    pusha                   ;day het thanh ghi vao trong stack
    lea di, a               ;dua thanh ghi dia chi di tro toi xau a
    lap:                    ;
        mov ah, 1           ;chon che do nhap 1 ki tu ham ngat 21h
        int 21h             ;thuc hien lenh lay 1 ki tu nhap
        cmp al, 13          ;so sanh xem ki tu nhap co phai ki tu ket thuc hay khong
        je ket_thuc         ;neu co thi nhay toi nhan ket thuc
        mov [di], al        ;luu lai ki tu do vao vi tri cua xau
        inc di              ;dua thanh ghi con tro tro toi ki tu tiep theo
        jmp lap             ;lap tiep vong lap
    ket_thuc:               ;ket thuc nhap chuoi ki tu
    popa        ;day het thanh ghi ban dau ra khoi stack
nhap_xau endm       ;ket thuc nhap 1 chuoi ki tu

in_thong_bao macro a        ;thuc hien in ra 1 chuoi 
    call xuong_dong         ;goi chuong trinh con xuong dong va thut ve dau dong
    push ax                 ;day thanh ghi ax vao stack
    push dx                 ;day thanh ghi dx vao stack
    mov ah, 9               ;chon che do in 1 chuoi ki tu ham ngat 21h
    lea dx, a               ;tro toi a
    int 21h                 ;thuc hien lenh in thong bao
    pop dx                  ;lay gia tri ra khoi stack va luu vao thanh ghi dx
    pop ax                  ;lay gia tri ra khoi stack va luu vao thanh ghi ax
in_thong_bao endm           ;ket thuc macro in 1 chuoi
in_so macro a               ;thuc hien in ra 1 so
    local lap1, lap2        ;khai bao nhan cuc bo chi su dung trong macro
    pusha                   ;day het thanh ghi vao stack
    mov ax, a               ;nap gia tri tham so a vao thanh ghi ax
    mov bx, 10              ;nap gia tri hang 10 vao thanh ghi bx
    mov cx, 0               ;reset thanh ghi dem cx ve 0
    lap1:
        inc cx              ;gia tang them thanh ghi cx len 1
        mov dx, 0           ;reset lai thanh ghi dx
        div bx              ;thuc hien chia thanh ghi ax cho bx(phan nguyen: ax, phan du: dx)
        push dx             ;day phan du (dx) vua tinh duoc vao stack
        cmp ax, 0           ;so sanh phan nguyen voi khong
        jg lap1             ;neu con thi nhay toi nhan lap1 va thuc hien lap tiep
    lap2:
        pop dx              ;lay gia tri thanh ghi ra khoi stack va luu vao dx
        add dx, '0'         ;chuyen chu so sang dang ki tu so
        mov ah, 2           ;che do in 1 ki tu ham ngat 21h
        int 21h             ;thuc hien lenh in 1 ki tu
        dec cx              ;giam so luong ki tu can in
        cmp cx, 0           ;so sanh cx voi 0
        jg lap2             ;neu cx > 0 : con ki tu can in thi lap lai nhan lap2 va thuc hien in tiep
    popa                    ;lay lan luot cac thanh ghi da day luc truoc ra khoi stack
in_so endm                  ;ket thuc viec in so macro

main proc
    mov ax, @data           ;luu gia tri dia chi @data vao thanh ghi ax
    mov ds, ax              ;nap gia tri thanh ghi ax vao thanh dia chi ds
    in_thong_bao tba        ;thuc hien in thong bao nhap xau A
    nhap_xau a              ;thuc hien nhap xau va luu vao bien a
    in_thong_bao tbb        ;thuc hien in thong bao nhap xau B
    nhap_xau b              ;thuc hien nhap xau va luu vao bien b  
    call vi_tri_xau_con     ;goi chuong trinh con tim vi tri xau con xuat hien
    call in_chi_so          ;goi chuong trinh con in ra vi tri xuat hien da tim duoc
    mov ah, 4ch
    int 21h                 ;thuc hien ket thuc chuong trinh
main endm 

xuong_dong proc             ;in xuong va thut dau dong
    push ax                 ;day thanh ghi ax vao stack
    push dx                 ;day thanh ghi dx vao stack
    mov ah, 9               ;chon che do in ra 1 chuoi ki tu
    lea dx, dong            ;tro toi chuoi dong
    int 21h                 ;thuc hien lenh in (xuong va thut dau dong)
    pop dx                  ;lay gia tri thanh ghi ra khoi stack va luu vao thanh ghi dx
    pop ax                  ;lay gia tri thanh ghi ra khoi stack va luu vao thanh ghi ax
    ret                     ;return
xuong_dong endp             ;ket thuc

vi_tri_xau_con proc         ;thuc hien tim cac vi tri xua hien xau con
    lea di, a               ;dua thanh ghi dia chi di tro toi chuoi ki tu A
    lap:
        mov dl, [di]        ;luu ki tu hien tai cua xau a vao thanh ghi dl
        mov bx, di          ;luu lai dia chi truoc khi xem xet
        cmp dl, '$'         ;so sanh ki tu do voi ki tu ket thuc xau
        je ket_thuc         ;khi bang nhau thi ket thuc lap
        lea si, b           ;dua con tro si tro toi vi tri dau tien cua xau b
        cmp dl, [si]        ;so sanh ki tu hien tai o xau a voi ki tu dau xau b
        jne lap_tiep        ;neu khong bang ta tiep tuc vong lap
        trung_nhau:         ;hai ki tu dau xau a, b da bang nhau
            inc di          ;tang thanh ghi dia chi toi vi tri tiep theo xau A
            mov dh, [di]    ;luu ki tu hien tai xau a vao thanh ghi dh
            inc si          ;tang thanh ghi dia chi toi vi tri tiep theo xau B
            mov dl, [si]    ;luu ki tu hien tai xau b vao thanh ghi dl
            cmp dl, '$'     ;so sanh ki tu xau b da la ki tu ket thuc chua
            je cong_them    ;da xet het ki tu o xau b va deu trung voi xau a
            cmp dh, '$'     ;so sanh ki tu xau a da la ki tu ket thuc chua
            je ket_thuc     ;da xet het ki tu o xau a
            cmp dh, dl      ;so sanh ki tu hai xau a b
            je trung_nhau   ;xet tiep ki tu tiep theo
        jmp lap_tiep        ;khi khong phai xau con tai vi tri do ta lap tiep
        cong_them:          ;them chi so xau con vao danh sach
        mov ax, bx          ;luu dia chi hien tai o xau a vao thanh ax
        lea si, a           ;luu dia chi dau tien xau a
        sub ax, si          ;tru dia chi hien tai cho dia chi dau tien va luu chi so hien tai vao ax
        lea di, index       ;dia chi danh sach vi tri xau con vao thanh di
        mov cx, so_luong    ;luu so_luong vi tri xau con vao thanh cx
        add di, cx          ;tro toi vi tri xau_con tiep theo da luu
        mov [di], ax        ;luu chi so xau con vao danh sach   
        inc cx              ;tang thanh ghi cx len 1
        mov so_luong, cx    ;luu gia tri so luong moi khi them 1 chi so    
        lap_tiep: 
        mov di, bx          ;reset lai vi tri sau khi xem xet
        inc di              ;dua con tro dia chi toi ki tu tiep theo
        jmp lap             ;tiep tuc xet toi ki tu tiep theo o xau a
    ket_thuc:
    ret                     ;return
vi_tri_xau_con endp         ;ket thuc viec tim vi tri xau con B trong xau A

in_chi_so proc
    mov cx, so_luong    ;nap gia tri so luong vi tri tim duoc vao thanh ghi cx
    cmp cx, 0           ;kiem tra xau b co la xau con cua a khong
    jg in_index         ;nhay toi nhan in vi tri xau con
    in_thong_bao khong_index    ;in thong bao xau b khong phai xau con cua xau a
    jmp ket_thuc_in             ;nhay toi nhan ket thuc in_chi_so
    in_index:                   ;khi xau b la xau con cua xau a
    in_thong_bao co_index       ;in thong bao xau b la xau con cua xau a 
    lea di, index               ;luu dia chi danh sach vi tri vao thanh ghi di
    in_lap:                     ;hien thi cac vi tri la xau 
        mov dl, [di]            ;luu vi tri xau con vao thanh ghi dl
        mov dh, 0               ;khoi tao gia tri thanh ghi dh bang 0
        in_so dx                ;in ra vi tri xau con
        inc di                  ;tang dia chi vi tri toi phan tu tiep theo
        mov ah, 2               ;chon che do in 1 ki tu ham ngat 21h
        mov dl, ' '             ;nap ki tu khong trang vao thanh ghi dl
        int 21h                 ;thuc hien lenh in ki tu khoang trang
        dec cx                  ;giam so luong vi tri can in ra
        cmp cx, 0               ;so sanh so luong co con hay khong
        jg in_lap               ;neu con thi nhay toi nhan in_lap va thuc hien in tiep
    ket_thuc_in:                ;het
    ret                         ;return
in_chi_so endp                  ;ket thuc viec in 