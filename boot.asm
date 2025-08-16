; boot.asm
; 第一扇區開機程式，顯示 Hello, World! 並換行，然後載入第二扇區
[org 0x7c00]        ; BIOS 將第一扇區載入到 0x7c00
[bits 16]           ; 16 位元實模式

start:
    ; 初始化段暫存器
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00   ; 設置堆疊指標，避開程式碼區域

    ; 顯示 Hello, World! 並換行
    mov si, msg
print_loop:
    lodsb            ; 載入下一個字元到 al
    cmp al, 0        ; 檢查字串結束
    je done_print
    mov ah, 0x0e     ; BIOS 顯示字元功能
    int 0x10         ; 呼叫 BIOS 中斷
    jmp print_loop

done_print:
    ; 使用 BIOS 中斷 0x13 讀取第二扇區
    mov ah, 0x02     ; BIOS 讀取磁碟功能
    mov al, 1        ; 讀取 1 個扇區
    mov ch, 0        ; 柱面 0
    mov cl, 2        ; 第二扇區 (從 1 開始計數)
    mov dh, 0        ; 磁頭 0
    mov dl, 0x80     ; 第一個硬碟 (QEMU 預設)
    mov bx, 0x7e00   ; 載入第二扇區到記憶體位址 0x7e00
    int 0x13         ; 呼叫 BIOS 中斷

    ; 檢查讀取是否成功
    jc error         ; 若進位旗標置位，跳轉到錯誤處理

    ; 跳轉到第二扇區
    jmp 0x7e00

error:
    ; 簡單錯誤處理：顯示 'E' 並停止
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
    cli
    hlt

msg:
    db "Hello, World!", 13, 10, 0  ; 加入 CR (13) 和 LF (10) 換行

; 填充至 510 位元組
times 510-($-$$) db 0
; 開機扇區標誌
dw 0xAA55