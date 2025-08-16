; sector2.asm
; 第二扇區程式碼，顯示訊息並換行
[org 0x7e00]        ; 第二扇區被載入到 0x7e00
[bits 16]           ; 16 位元實模式

start:
    ; 初始化段暫存器
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; 使用 BIOS 中斷 0x10 顯示訊息
    mov si, msg
print_loop:
    lodsb            ; 載入下一個字元到 al
    cmp al, 0        ; 檢查字串結束
    je done
    mov ah, 0x0e     ; BIOS 顯示字元功能
    int 0x10         ; 呼叫 BIOS 中斷
    jmp print_loop

done:
    ; 停止執行
    cli
    hlt

msg:
    db "Hello from sector 2!", 13, 10, 0  ; 加入 CR (13) 和 LF (10) 換行

; 填充至 512 位元組
times 512-($-$$) db 0