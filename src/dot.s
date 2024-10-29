.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 33
# =======================================================
dot:

    # Prologue
    addi sp, sp, -40
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

    add s0, a0, x0 # s0 is pointer of v0
    add s1, a1, x0 # s1 is pointer of v1
    addi s4, x0, 1   # s4 = i
    
    blt a2, s4, exit_32  # if len < 1
    blt a3, s4, exit_33  # if v0 stride < 1
    blt a4, s4, exit_33 # if v1 stride < 1

    li s8, 0  #initialize sum a0
    li s7, 4
    mul s6, a3, s7  #stride * 4 byte
    mul s7, a4, s7



loop_start:
    bgt s4, a2, loop_end
    lw s2, 0(s0)  # number of v0
    lw s3, 0(s1) # number i ofv1
    mul s5, s2, s3 
    add s8, s8, s5
    addi s4, s4, 1 # s4++
    add s0, s0, s6
    add s1, s1, s7
    j loop_start


loop_end:


    # Epilogue
    add a0, s8, x0

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
    addi sp, sp, 40
    
    ret


exit_32:
    li a1, 32
    jal exit2


exit_33:
    li a1, 33
    jal exit2
