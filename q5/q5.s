.section .data
fmt_filename:
.string "input.txt"

fmt_filemode:
.string "r"

fmt_pallindrome:
.string "Yes\n"

fmt_notpallindrome:
.string "No\n"

.section .text
.global main
main:
    addi sp, sp, -48
    sd ra, 0(sp)
    sd s0, 8(sp)              # file pointer
    sd s1, 16(sp)             # left index
    sd s2, 24(sp)             # right index
    sd s3, 32(sp)             # length of file
    sd s4, 40(sp)

    la a0, fmt_filename
    la a1, fmt_filemode
    call fopen 
    add s0, a0, x0            # s0 = pointer to file

    add a0, s0, x0
    addi a1, x0, 0
    addi a2, x0, 2            # seek end = 2
    call fseek

    add a0, s0, x0
    call ftell
    add s3, a0, x0            # s3 = length of file

    addi s1, x0, 0            # left index = 0
    addi s2, s3, -1           # right index = len - 1

    loop:
        bge s1, s2, pallindrome

        add a0, s0, x0
        add a1, s1, x0
        addi a2, x0, 0
        call fseek              # sets internal cursor pointer to s1 index in file

        add a0, s0, x0
        call fgetc              # gets the char at s1 index
        add s4, a0, x0

        add a0, s0, x0
        add a1, s2, x0 
        addi a2, x0, 0
        call fseek             # sets internal cursor pointer to s2 index in file

        add a0, s0, x0
        call fgetc             # gets the char at s1 index

        bne s4, a0, not_pallindrome

        addi s1, s1, 1
        addi s2, s2, -1
        beq x0, x0, loop

    pallindrome:
        la a0, fmt_pallindrome
        call printf
        beq x0, x0, end

    not_pallindrome:
        la a0, fmt_notpallindrome
        call printf
        beq x0, x0, end

    end:
        add a0, s0, x0
        call fclose

        ld s4, 40(sp)
        ld s3, 32(sp)
        ld s2, 24(sp)
        ld s1, 16(sp)
        ld s0, 8(sp)
        ld ra, 0(sp)
        addi sp, sp, 48

        addi a0, x0, 0
        ret
