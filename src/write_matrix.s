.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 64
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 67
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 65
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)  # -1
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)

    mv s0, a0  # s0 pointer to string representing the filename
    mv s1, a1  # s1 the pointer to the start of the matrix in memory
    mv s2, a2  # s2 row
    mv s3, a3  # s3 col

    mv a1, s0
    li a2, 1
    jal fopen

    # a0 is the return value of fopen
    li s4, -1
    beq a0, s4, exit_64
    mv s5, a0  # s5: file descriptor
   
    addi sp, sp, -4
    sw s2, 0(sp)  # row

    mv a1, s5
    mv a2, sp
    li a3, 1
    mv s7, a3
    li a4, 4
    jal fwrite

    # a0 = Number of elements writen. If this is less than a3, exit
    blt a0, s7, exit_67

    sw s3, 0(sp)  # col
    
    mv a1, s5
    mv a2, sp
    li a3, 1
    mv s7, a3
    li a4, 4
    jal fwrite

    # a0 = Number of elements writen. If this is less than a3, exit
    blt a0, s7, exit_67

    addi sp, sp, 4

    mv a1, s5  # file descriptor
    mv a2, s1  # memory write from
    mul s6, s2, s3  # matrix size
    mv a3, s6
    mv s7, a3  
    li a4, 4  # 4 byte
    jal fwrite

    # a0 = Number of elements writen. If this is less than a3, exit
    blt a0, s7, exit_67

    mv a1, s5
    jal fclose
    beq a0, s4, exit_65

 
    # Epilogue

    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)  # -1
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36


    ret



exit_64:
    li a1, 64
    jal exit2

exit_65:
    li a1, 65
    jal exit2

exit_67:
    li a1, 67
    jal exit2
