.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 34
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 34
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 34
# =======================================================
matmul:


    # Prologue
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    addi s0, a0, 0 # m0 pointer
    addi s1, a1, 0 # m0 row
    addi s2, a2, 0 # m0 col
    addi s3, a3, 0 # m1 pointer
    addi s4, a4, 0 # m1 row
    addi s5, a5, 0 # m1 col, v1 stride
    addi s6, a6, 0 # pointer of d
    li s7, 1
    li s8, 1
    li s11, 4
    mul s11, s11, s2
    mv s9, a3  # always keep m1 pointer


# Error checks
    # dimensions of m0 do not make sense

    blt s1, s7, exit_34
    blt s2, s7, exit_34
    
    # dimensions of m1 do not make sense
    blt s4, s7, exit_34
    blt s5, s7, exit_34

    # the dimensions of m0 and m1 don't match
    bne s2, s4, exit_34



outer_loop_start:  # row
    bgt s7, s1, outer_loop_end
    
    li s8, 1
    mv s3, s9

    j inner_loop_start




inner_loop_start:  # column
    bgt s8, s5, inner_loop_end

    mv a0, s0 # a0 is m0 pointer
    mv a1, s3 # a1 is m1 pointer
    addi a2, s2, 0 # a2 is len of vector
    li t0, 1
    mv a3, t0 # a3 is v0 stride
    mv a4, s5 # a4 is v1 stride

    mv s10, t0
    jal dot 
    mv t0, s10  # restore t0
    sw a0, 0(s6)  # save cij to d

    addi s3, s3, 4  # move pointer of m1 to next number
    addi s6, s6, 4  # move pointer of c matrix
    addi s8, s8, 1
    j inner_loop_start






inner_loop_end:
    
    add s0, s0, s11  # move pointer of m0 to next row
    addi s7 ,s7, 1  # s7++
    
    j outer_loop_start



outer_loop_end:


    # Epilogue
    
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    
    
    ret


exit_34:
    li a1, 34
    jal exit2