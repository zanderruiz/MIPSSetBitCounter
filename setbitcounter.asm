.data
    prompt: .asciiz "Enter an integer N: "
    result: .asciiz "\nTotal set bits in all integers from 1 to "
    semicolon: .asciiz ": "

.text
.globl main
    main:
        # Prompt the user to enter N
        li $v0, 4
        la $a0, prompt
        syscall

        # Get user input
        li $v0, 5
        syscall
        move $s0, $v0

        # Loop from 1 to N to find total set bits
        li $s1, 1 # counter to iterate through loop up to N ($s0)
        li $s2, 0 # register to accumulate set bit count
        beq $s0, $zero, exit # if user put in 0, just exit program and return 0
        loop:
            move $a1, $s1
            jal countSetBits # count set bits in curr number
            addu $s2, $s2, $v1 # add the set bits from curr number to total set bits
            li $v1, 0 # reset $v1
            beq $s1, $s0, exit # if counter == N, exit loop
            addi $s1, $s1, 1 # counter++
            j loop

        exit:
            # Print message
            li $v0, 4
            la $a0, result
            syscall
            li $v0, 1
            move $a0, $s0
            syscall
            li $v0, 4
            la $a0, semicolon
            syscall

            # Print total set bit count following message
            li $v0, 1
            move $a0, $s2
            syscall

            # End the program
            li $v0, 10
            syscall


    # counts the set bits in a given integer
    countSetBits:
        li $t0, 2
        recursion:
            beq $a1, $zero, return # base case, $a1 == 0
            divu $a1, $t0 # divide $a1 by 2
            mfhi $t1 # take remainder of division by 2 (0 or 1)
            addu $v1, $v1, $t1 # add to $v1
            srl $a1, $a1, 1  # $a1 / 2
            j recursion

        return:
            jr $ra

