.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# =================================================================
argmax:
    # Prologue
    addi, sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)


    add s0, x0, a0   # s0 = &A[0]
    add s1, x0, x0  # s1 is i
    lw s3, 0(s0)  # s3 is largest
    add s5, a1, x0 # s5 is len

    addi s4, x0, 1   # s4 = 1
    blt s5, s4, exit_32  # if len < 1

        

loop_start:
    bge s1, s5, loop_end
    lw s2, 0(s0) # s2 = A[i]
    blt s2, s3, loop_continue # if s2 < s3
    add s3, s2, x0 # largest = s3
    mv s6, s1 # a0 is index of largest
    j loop_continue



loop_continue:
    addi s1, s1, 1  # i++
    addi s0, s0, 4
    j loop_start


loop_end:
    

    # Epilogue
    
    add a0, s6, x0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi, sp, sp, 32

    ret

exit_32:
    li a1, 32
    jal exit2