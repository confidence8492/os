nasm -f bin boot.asm -o boot.bin  
nasm -f bin boot2.asm -o boot2.bin
cat boot.bin boot2.bin > disk.img
qemu-system-x86_64 -drive file=disk.img,format=raw
