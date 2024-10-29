.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)


    add s0, x0, a0   # s0 = &A[0]
    add s1, x0, x0  # s1 is i
    add s2, x0, a1  # s2 is len

    addi s3, x0, 1   # s3 = 1
    blt s2, s3, exit_32  # if len < 1
    
    

loop_start:
    bge s1, s2, loop_end
    lw s4, 0(s0) # s4 = A[i]
    bge s4, x0, loop_continue # if s4 >= 0  -> continue
    
    sw x0, 0(s0)
    j loop_continue



loop_continue:
    addi s1, s1, 1 # i+=1
    addi s0, s0, 4
    j loop_start 



loop_end:


    # Epilogue
    
    add a0, s4, x0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
	ret

exit_32:
    li a1, 32
    jal exit2
