.section .data
fmt_one:
.string "%lld"

fmt_second:
.string " %lld"

fmt_newline:
.string "\n"

arr:
.space 8000                        # long int arr[1000]

stack:
.space 8000                        # long int stack[1000]

res:
.space 8000                        # long int res[1000]

.section .text
.global main
main:
    addi sp, sp, -48
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    sd s4, 40(sp)

    add s0, a0, x0                  # s0 = argc
    add s1, a1, x0                  # s1 = argv

    addi t0, x0, 0                  # i = 0 
    addi t1, x0, 1                  # index for argv (0th index is "./a.out") say j

    store_args:
        beq t1, s0, start

        slli t2, t1, 3               # offset = j*8 = j*2^3
        add t3, s1, t2               # t3 = argv[t1] address
        ld a0, 0(t3)                 # a0 = argv[t1]  (value stored for arg to atoi func)

        addi sp, sp, -16
        sd t0, 0(sp)                 # storing t0 and t1 before function call
        sd t1, 8(sp)
        call atoi                    # str -> int conversion
        ld t0, 0(sp)
        ld t1, 8(sp)
        addi sp, sp, 16

        la t3, arr
        slli t2, t0, 3               # offset = i*8 = i*2^3
        add t3, t3, t2               # t3 = arr[i] address
        sd a0, 0(t3)                 # arr[i] = arg value

        addi t0, t0, 1
        addi t1, t1, 1
        beq x0, x0, store_args

    start:
        add s2, t0, x0                # s2 = n (size of array)
        addi t5, x0, 0                # stack size
        addi t0, t0, -1               # i = n-1 (last index of array, iterate backwards)

        loop_outer:
            blt t0, x0, print_output

            slli t1, t0, 3            # offset = i*8
            la t2, arr                # loading address of array var
            add t2, t2, t1            # t2 = arr[i] address
            ld t3,  0(t2)             # t3 = arr[i] (value)

            while_stack_loop:
                beq t5, x0, stop_while

                addi s3, t5, -1       # top index of stack
                slli s4, s3, 3        # offset = j*8
                la t2, stack          # loading address of stack arr
                add t2, t2, s4        # t2 = stack.top() address
                ld s3, 0(t2)          # s3 = stack.top() (value : index)

                slli s4, s3, 3        # offset = stack[top]*8
                la t2, arr            # loading address of array var
                add t2, t2, s4        # t2 = arr[i] address
                ld t2, 0(t2)          # t2 = arr[i] value

                bgt t2, t3, stop_while # arr[stack[top]] > arr[i] : greater element found

                addi t5, t5, -1        # stack.pop()
                beq x0, x0, while_stack_loop

            stop_while:
                slli t1, t0, 3
                la t2, res
                add t2, t2, t1

                beq t5, x0, stack_empty   # stack is empty => no ans

                addi s3, t5, -1
                slli s4, s3, 3
                la t6, stack
                add t6, t6, s4
                ld t6, 0(t6)          # t6 = stack[top]

                sd t6, 0(t2)          # res[i] = stack[top]
                beq x0, x0, push_in_stack

            stack_empty:
                addi t6, x0, -1
                sd t6, 0(t2)          # res[i] = -1

            push_in_stack:
                la t6, stack
                slli t1, t5, 3        # top index+1 = size of stack = t5 ; offset=t5*8
                add t6, t6, t1
                sd t0, 0(t6)          # stack.push(i)

                addi t5, t5, 1        # stack.size++
                addi t0, t0, -1       # i-- (iterating backwards)
                
                beq x0, x0, loop_outer

    print_output:
        addi t0, x0, 0

        slli t1, t0, 3
        la t2, res
        add t2, t2, t1

        ld a1, 0(t2)                  # a1 = arr[i] (value)
        la a0, fmt_one                

        addi sp, sp, -16
        sd s2, 0(sp)
        call printf
        ld s2, 0(sp)
        addi sp, sp, 16

        addi t0, x0, 1

        print_rest:
            beq t0, s2, end           # i==n

            slli t1, t0, 3
            la t2, res
            add t2, t2, t1
            ld a1, 0(t2)              # a1 = res[i]
            la a0, fmt_second

            addi sp, sp, -16
            sd s2, 0(sp)
            sd t0, 8(sp)
            call printf
            ld s2, 0(sp)
            ld t0, 8(sp)
            addi sp, sp, 16

            addi t0, t0, 1
            beq x0, x0, print_rest

    end:
        la a0, fmt_newline
        call printf

        ld s4, 40(sp)
        ld s3, 32(sp)
        ld s2, 24(sp)
        ld s1, 16(sp)
        ld s0, 8(sp)
        ld ra, 0(sp)
        addi sp, sp, 48

        add a0, x0, x0
        ret
