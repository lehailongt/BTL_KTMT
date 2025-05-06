;14. Viet chuong trinh hop ngu assembly cho phep nhap vao 2 so va in ra man hinh UCLN va BCNN cua hai so do
.model small    ;khai bao che do bo nho la small
.stack 100h     ;khai bao kich thuoc stack la 100h
.data           ;khai bao cac bien du lieu
    tb1 db 'Nhap so thu nhat : $'       ;chuoi ki tu thong bao nhap so thu nhat
    tb2 db 'Nhap so thu hai : $'        ;chuoi ki tu thong bao nhap so thu hai
    tb3 db 'UCLN cua hai so do la: $'   ;chuoi ki tu thong bao in ra uoc chung lon nhat
    tb4 db 'BCNN cua hai so do la: $'   ;chuoi ki tu thong bao in ra boi chung nho nhat
    a dw ?          ;bien a luu so thu nhat
    b dw ?          ;bien b luu so thu hai
    ucln dw ?       ;uoc chung lon nhat 2 so do
    bcnn dw ?       ;boi chung nho nhat 2 so a, b
    dong db 13, 10, '$'     ;chuoi ki tu (thuc hien xuong va thut dau dong)
.code 

nhap_so macro a     ;thuc hien nhap so
    local ket_thuc_nhap, lap        ;khai bao nhan cuc bo chi su dung trong macro
    pusha           ;day het thanh ghi vao stack
    mov bx, 10      ;nap gia tri 10 vao thanh ghi bx
    mov dx, 0       ;reset lai dx (so ban dau)
    lap:
        mov ah, 1           ;chon che do lay 1 ki tu nhap tu nguoi dung
        int 21h             ;thuc hien lay 1 ki tu nhap
        cmp al, 13          ;kiem tra xem ki tu nhap co phai ki tu ket thuc khong
        je ket_thuc_nhap    ;neu bang thi nhay toi nhan ket_thuc_nhap
        sub al, '0'         ;chuyen ki tu so sang dang chu so
        mov ah, 0           ;reset lai ah = 0
        mov cx, ax          ;luu lai gia tri chu so do vao thanh ghi cx
        mov ax, dx          ;luu lai gia tri thanh ghi dx (so ban dau) vao ax
        mul bx              ;thuc hien nhan thanh ghi ax voi bx ( 10 )
        add ax, cx          ;them thanh ghi ax voi chu so moi vua luu
        mov dx, ax          ;luu lai gia tri so vao thanh ghi dx
    jmp lap                 ;lenh nhay toi nhan lap tiep theo
    ket_thuc_nhap:          ;nhan ket_thuc_nhap so
    mov a, dx               ;luu lai so nhap moi tinh duoc ve tham so truyen ban dau
    popa                    ;lay het thanh ghi ra khoi stack
nhap_so endm        ;ket thuc macro nhap so

in_so macro a       ;thuc hien in so 
    local lap1, lap2    ;khai bao nhan cuc bo chi su dung trong macro
    pusha               ;day het thanh ghi vao stack
    mov bx, 10          ;nap gia tri 10 vao thanh ghi bx
    mov ax, a           ;nap gia tri tham so a vao thanh ghi ax (so ban dau)
    mov cx, 0           ;reset lai thanh ghi dem cx
    lap1:
        mov dx, 0       ;reset lai thanh ghi dx (tranh viec tinh toan bi sai)
        div bx          ;thuc hien chia ax cho bx (so du luu vao dx, phan nguyen luu ax)
        push dx         ;day phan du (dx) vao stack
        inc cx          ;gia tang them so luong chu so
        cmp ax, 0       ;so sanh phan nguyen co bang 0 hay khong
        jne lap1        ;neu khong nhay toi nhan lap
    lap2:
        pop dx          ;lay va luu vao thanh ghi dx ra khoi stack
        add dx, '0'     ;chuyen so sang dang ki tu so
        mov ah, 2       ;chon che do in 1 ki tu ham ngat 21h
        int 21h         ;thuc hien ki tu ra man hinh
        dec cx          ;giam so ki tu can in ra
        cmp cx, 0       ;kiem tra xem so ki tu con lai
        jg lap2         ;neu con thi nhay toi lap2 va in tiep
    popa        ;lay het thanh ghi ra khoi stack
in_so endm      ;ket thuc in so macro

in_thong_bao macro a    ;in thong bao 1 chuoi ki tu
    call xuong_dong     ;goi chuong trinh con xuong va thut dau dong
    push ax             ;day gia tri thanh ghi ax vao stack
    push dx             ;day gia tri thanh ghi dx vao stack
    mov ah, 9           ;chon che do in 1 chuoi ki tu ham ngat 21h
    lea dx, a           ;tro dx toi dau chuoi ki tu a
    int 21h             ;thuc hien in 1 chuoi ki tu a
    pop dx              ;lay gia tri thanh ghi ra khoi stack va luu vao thanh dx
    pop ax              ;lay gia tri thanh ghi ra khoi stack va luu vao thanh ax
in_thong_bao endm       ;ket thuc in thong bao macro

tinh_ucln macro a, b, c     ;thuc hien tich ucln hai tham so a, b va luu ket qua vao tham so c
    local lap               ;khai bao nhan cuc bo chi su dung trong macro
    pusha                   ;day het thanh ghi vao stack
    mov ax, a               ;nap gia tri tham so a vao thanh ghi ax (so thu nhat)
    mov bx, b               ;nap gia tri tham so b vao thanh ghi bx (so thu hai)
    cmp ax, bx              ;so sanh hai so
    jg lap                  ;neu ax > bx thuc hien nhay toi nhan lap
    ;thuc hien hoan doi hai so luu trong ax, bx de so lon ax > bx
    mov dx, ax
    mov ax, bx
    mov bx, dx
    lap:    ;(xac dinh rang: ax luon lon hoac bang bx)
    mov dx, 0   ;reset lai thanh ghi dx
    div bx      ;thuc hien phep chia gia tri thanh ghi ax cho thanh ghi bx
    mov ax, bx  ;luu so chia vao ax
    mov bx, dx  ;luu so du vao bx
    cmp bx, 0   ;so sanh so du voi 0
    jg lap      ;neu con du thi nhay toi nhan lap va thuc hien tiep
    mov c, ax   ;luu gia tri thanh ghi ax (ucln da tinh duoc) vao tham so c ban dau
    popa            ;lay lan luot cac thanh ghi ra khoi stack
tinh_ucln endm              ;ket thuc tinh toan ucln macro

main proc
    mov ax, @data    ;nap dia chi du lieu @data vao thanh ghi ax
    mov ds, ax       ;tro thanh ghi ds toi @data thong qua thanh ghi ax
    in_thong_bao tb1        ;thuc hien in thong bao moi nhap so thu nhat
    nhap_so a               ;thuc hien nhap so thu nhat va luu vao bien a
    in_thong_bao tb2        ;thuc hien in thong bao moi nhap so thu hai
    nhap_so b               ;thuc hien nhap so thu hai va luu vao bien b
    tinh_ucln a, b, ucln    ;thuc hien tinh toan gia tri uoc chung lon nhat
    in_thong_bao tb3        ;thuc hien in thong bao ucln
    in_so ucln              ;thuc hien in ra uoc chung lon nhat hai so a, b
    mov dx, 0               ;reset lai thanh ghi dx
    mov ax, a               ;nap gia tri so thu nhat vao thanh ghi ax
    mov bx, b               ;nap gia tri so thu hai vao thanh ghi bx
    mul bx                  ;nhan thanh ghi ax voi bx (luu tich hai so vao ax)
    mov bx, ucln            ;nap gia tri ucln vao thanh ghi bx
    div bx                  ;thuc hien chia tich cho ucln
    mov bcnn, ax            ;luu gia tri vua tinh duoc vao bcnn
    in_thong_bao tb4        ;thuc hien in thong bao bcnn
    in_so bcnn              ;thuc hien in gia tri boi chung nho nhat hai so do
    mov ah, 4ch             
    int 21h                 ;thuc hien lenh ket thuc chuong trinh
main endp 

xuong_dong proc             ;thuc hien xuong va thut dau dong
    push ax                 ;day thanh ghi ax vao stack
    push dx                 ;day thanh ghi dx vao stack
    mov ah, 9               ;chon che do in 1 chuoi ki tu ham ngat 21h
    lea dx, dong            ;tro dx toi chuoi ki tu dong
    int 21h                 ;thuc hien lenh xuong va thut dau dong
    pop dx                  ;lay gia tri thanh ghi ra khoi stack va luu vao thanh ghi dx
    pop ax                  ;lay gia tri thanh ghi ra khoi stack va luu vao thanh ghi ax
    ret                     ;ket thuc chuong trinh con
xuong_dong endm             ;ket thuc xuong va thut dau dong


