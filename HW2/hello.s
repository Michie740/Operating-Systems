# Fill this in yourself!
.code16
.globl start

start:
    movw $message, %si
    movb $0x00, %ah
    movb $0x03, %al
    int $0x10

print_char:
    lodsb # load bite into al and increment si
    testb %al, %al # check if byte is 0
    jz done # if so then go
    movb $0x0E, %ah # 0x0E is the BIOs code to print a single char
    int $0x10 # call into BIOs using softwre interupt
    jmp print_char # go back to the start of the loop

done:
    jmp done

message:
    .string "Hello World"

.fill 510 - (. - start), 1, 0

.byte 0x55
.byte 0xAA
