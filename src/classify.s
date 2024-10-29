.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 35
    # - If malloc fails, this function terminates the program with exit code 48
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


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
    
    mv s0, a0  # argc
    mv s1, a1  # argv
    mv s2, a2  # print?
    
    li s3, 5
    bne s0, s3, exit_35

    



	# =====================================
    # LOAD MATRICES
    # =====================================






    # Load pretrained m0

    lw s3, 4(s1)  # <M0_PATH>
    mv a0, s3 # pointer to filename
    addi sp, sp, -4
    mv a1, sp  # row
    addi sp, sp, -4
    mv a2, sp  # col
    mv t1, a1
    mv t2, a2
    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)

    jal read_matrix
    
    lw t1, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    
    mv s4, a0  # pointer to m0

    lw s5, 0(t1) # s5 m0 row
    lw s6, 0(t2) # s6 m0 col

    addi sp, sp, 8


    # Load pretrained m1

    lw s3, 8(s1)  # <M1_PATH>
    mv a0, s3 # pointer to filename
    addi sp, sp, -4
    mv a1, sp  # row
    addi sp, sp, -4
    mv a2, sp  # col
    mv t1, a1
    mv t2, a2

    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)

    jal read_matrix
    
    lw t1, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    
    mv s7, a0  # s7 pointer to m1

    lw s8, 0(t1) # s8 m1 row
    lw s9, 0(t2) # s9 m1 col

    addi sp, sp, 8




    # Load input matrix

    lw s3, 12(s1)  # <INPUT_PATH>
    mv a0, s3 # pointer to filename
    addi sp, sp, -4
    mv a1, sp  # row
    addi sp, sp, -4
    mv a2, sp  # col
    mv t1, a1
    mv t2, a2

    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)

    jal read_matrix
    
    lw t1, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    
    mv s10, a0  # s10: pointer to input
    lw s11, 0(t1) # s11 input row
    lw s3, 0(t2) # s3 input col 
    

    addi sp, sp, 8




    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    
    # linear layer m0 * input
    mul t0, s5, s3  # matrix size
    slli t0, t0, 2  # malloc bytes
    mv a0, t0
    jal malloc

    # if malloc failed, return 0, exit_48
    beq a0, x0, exit_48
    mv s0, a0  # malloc return
    

    mv a0, s4
    mv a1, s5
    mv a2, s6
    mv a3, s10
    mv a4, s11
    mv a5, s3
    mv a6, s0
    jal matmul  # s0-> pointer to m0*input

    # Relu 
    mul a1, s5, s3  # Relu size
    mv a0, s0
    jal relu  # ReLU(m0 * input)


    # m1 * ReLU(m0 * input)
    mul t0, s8, s3  # matrix size
    slli t0, t0, 2  # malloc bytes
    mv a0, t0
    jal malloc

    # if malloc failed, return 0, exit_48
    beq a0, x0, exit_48
    mv s6, a0  # malloc return

    mv a0, s7
    mv a1, s8
    mv a2, s9
    mv a3, s0
    mv a4, s5
    mv a5, s3
    mv a6, s6
    jal matmul
    




    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1) # <OUTPUT_PATH>
    mv a1, s6
    mv a2, s8
    mv a3, s3
    jal write_matrix



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s6
    mul a1, s8, s3  # matrix size
    jal argmax
    mv s11, a0 # index of largest (classification)



    # Print classification
    bne s2, x0, done
    mv a1, s11
    jal print_int



    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char


done:
    
    # free
    mv a0, s0
    jal free
    mv a0, s6
    jal free
    mv a0, s4
    jal free
    mv a0, s7
    jal free
    mv a0, s10
    jal free


    mv a0, s11

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
   
    
exit_35:
    li a1, 35
    jal exit2

exit_48:
    li a1, 48
    jal exit2