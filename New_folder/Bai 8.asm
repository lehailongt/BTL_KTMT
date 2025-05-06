;8. Viet chuong trinh hop ngu assembly chuyen mot so tu he co so 10 sang he 16 (hexa)
.model small    ;khai bao che do bo nho la small
.stack 100h     ;khai bao kich thuoc ngan xep la 100h
.data           ;khoi tao cac bien
    he_10 db 'Nhap so he co so 10 la: $'                ;chuoi ki tu thong bao nhap so he 10
    he_16 db 'So da chuyen sang he co so 16 la: $'      ;chuoi ki tu thong bao in so he 16
    a dw ?                  ;bien luu so nhap
    dong db 10, 13, '$'     ;chuoi ki tu  
.code

nhap_so_he_10 macro a   ;nhap so he co so 10
    local ket_thuc_nhap, lap    ;khai bao nhan cuc bo chi su dung trong macro
    pusha                       ;day het thanh ghi vao stack
    mov bx, 10                  ;luu gia tri 10 vao thanh ghi bx
    lap:
        mov ah, 1           ;che do lay 1 ki tu phim nhap
        int 21h             ;thuc hien lenh ngat lay 1 ki tu
        cmp al, 13          ;kiem tra ki tu nhap co phai ki tu ket thuc khong
        je ket_thuc_nhap    ;nhay toi nhan ket_thuc_nhap neu dung
        sub al, '0'         ;chuyen ki tu so sang dang so
        mov ah, 0           ;reset ah = 0
        mov cx, ax          ;luu lai gia tri chu so vua nhap vao thanh cx
        mov ax, dx          ;luu so ban dau vao thanh ghi ax
        mul bx              ;thuc hien nhan thanh ghi ax voi 10
        add ax, cx          ;cong so ban dau voi chu so vua nhap duoc
        mov dx, ax          ;luu lai gia tri so tinh duoc vao thanh ghi dx (tam thoi)
    jmp lap                 ;thuc hien tiep vong lap nhap so
    ket_thuc_nhap:          ;nhan ket thuc nhap so
    mov a, dx               ;luu so da tinh duoc tra lai tham so a ban dau
    popa                    ;lay het thanh ghi ra khoi stack  
nhap_so_he_10 endm      ;ket thuc macro nhap so 10

in_so_he_16 macro a         ;in so da nhap sang he co so 16
    local lap1, lap2        ;khai bao nhan cuc bo chi su dung trong macro
    pusha           ;day het thanh ghi vao stack
    mov bx, 16      ;luu so chia 16 vao thanh ghi bx
    mov ax, a       ;luu so ban dau vao thanh ghi ax
    mov cx, 0       ;reset thanh ghi cx ban dau ve 0 (so luong chu so)
    lap1:
        mov dx, 0   ;reset lai thanh ghi dx
        div bx      ;thuc hien chia ax cho 16 (so du luu dx, phan nguyen luu ax)
        push dx     ;day phan du vao stack
        inc cx      ;tang them so luong chu so len 1
        cmp ax, 0   ;so sanh phan nguyen co bang 0 khong
        jne lap1    ;khong bang thi ta thuc hien vong lap tiep
    
    lap2:
        pop dx      ;lay so ra khoi stack
        cmp dx, 9   ;kiem tra xem so do co lon hon 9 khong
        jg chu_cai  ;lon hon thi doi sang dang hcu cai
        add dx, '0' ;chuyen dang so sang dang ki tu so
        jmp in_ra   ;thuc hien in ra ki tu
        chu_cai:
        add dx, 55  ;chuyen dang so sang dang chu cai he co so 16
        in_ra:
        mov ah, 2   ;che do in 1 ki tu ham ngat 21h
        int 21h     ;thuc hien in 1 ki tu ra man hinh
        dec cx      ;giam so luong chu so can in di 1
        cmp cx, 0   ;kiem tra xem co can in them hay khong
        jg lap2     ;co thi nhay toi nhan lap2 in tiep theo
    popa            ;lay het thanh ghi ra khoi stack 
in_so_he_16 endm    ;ket thuc macro in so 16

in_thong_bao macro a 
    call xuong_dong     ;goi chuong trinh con xuong_dong
    push ax             ;day thanh ghi dx vao stack
    push dx             ;day thanh ghi dx vao stack
    mov ah, 9           ;chon che do in 1 chuoi ki tu ham ngat 21h
    lea dx, a           ;tro toi chuoi a
    int 21h             ;thuc hien in ra man hinh thong bao a
    pop dx              ;lay thanh ghi dx ra khoi stack
    pop ax              ;lay thanh ghi ax ra khoi stack
in_thong_bao endm       ;ket thuc macro in thong bao

main proc
    mov ax, @data           ;nap dia chi du lieu @data vao thanh ghi ax
    mov ds, ax              ;luu gia tri dia chi ax vao thanh ghi ds
    in_thong_bao he_10      ;thuc hien in thong bao nhap so he co so 10
    nhap_so_he_10 a         ;thuc hien nhap so va luu vao bien a
    in_thong_bao he_16      ;thuc hien in thong bao in ra so da chuyen doi sang he co so 16
    in_so_he_16 a           ;thuc hien in so a khi chuyen sang he co so 16
    mov ah, 4ch             ;ham ngat ket thuc chuong trinh
    int 21h   
main endp

xuong_dong proc         ;in xuong dong va thut dau dong
    push ax             ;day thanh ghi ax vao stack
    push dx             ;day thanh ghi dx vao stack
    mov ah, 9           ;che do in ra 1 chuoi ki tu
    lea dx, dong        ;tro toi chuoi ki tu(xuong dong va thut dau dong)
    int 21h             ;thuc hien lenh
    pop dx              ;lay thanh ghi dx ra khoi stack
    pop ax              ;lay thanh ghi ax ra khoi stack
    ret                 ;ket thuc chuong trinh con
xuong_dong endm


