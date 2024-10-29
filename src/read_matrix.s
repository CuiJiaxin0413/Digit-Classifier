.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 48
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 64
# - If you receive an fread error or eof,
#   this function terminates the program with error code 66
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 65
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp) # -1
    sw s4, 20(sp) # s4 file descriptor
    sw s5, 24(sp) # 8 -> m*n*4
    sw s6, 28(sp) # s6: malloc return
    sw s7, 32(sp) # row
    sw s8, 36(sp) # col



    mv s0, a0 # s0 pointer
    mv s1, a1  # s1 row
    mv s2, a2 # s2 col

    mv a1, s0
    li a2, 0
    jal fopen

    # a0 is the return value of fopen
    li s3, -1
    beq a0, s3, exit_64
    mv s4, a0 # s4 file descriptor

    li s5, 8  # s5=8 bytes
    mv a0, s5
    jal malloc

    # if malloc failed, return 0, exit_48
    beq a0, x0, exit_48

    # save malloc return
    mv s6, a0

    # fread: return actual size of read.   
    mv a1, s4  # a1: s4 file descriptor
    mv a2, s6  # a2: buffer pointer
    mv a3, s5  # s3: number of bytes to be read: 8
    jal fread
    # If the number of bytes actually read differs from the number of bytes specified in the input, 
    # then we either hit the end of the file or there was an error.
    bne a0, s5, exit_66
    
    lw s7, 0(s6)  # row
    sw s7, 0(s1)
    lw s8, 4(s6)  # col
    sw s8, 0(s2)

    mul s5, s7, s8 # m*n
    slli s5, s5, 2 # m*n*4
    mv a0, s5
    jal malloc
    # if malloc failed, return 0, exit_48
    beq a0, x0, exit_48
    mv s6, a0  # s6: array pointer

    # fread
    mv a1, s4
    mv a2, s6
    mv a3, s5
    jal fread
    bne a0, s5, exit_66

    mv a1, s4
    jal fclose
    beq a0, s3, exit_65

    mv a0, s6

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp) # -1
    lw s4, 20(sp) # s4 file descriptor
    lw s5, 24(sp) # 8 -> m*n*4
    lw s6, 28(sp) # s6: malloc return
    lw s7, 32(sp) # row
    lw s8, 36(sp) # col
    addi sp, sp, 40

    ret


exit_48:
    li a1, 48
    jal exit2

exit_64:
    li a1, 64
    jal exit2

exit_65:
    li a1, 65
    jal exit2

exit_66:
    li a1, 66
    jal exit2
