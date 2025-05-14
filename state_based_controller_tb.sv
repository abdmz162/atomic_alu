`timescale 1ns/1ps

module state_based_controller_tb;

    // Inputs
    logic clk;
    logic [11:0] command;
    logic syscall;
    logic Z;
    logic [31:0] y;
    
    // Outputs
    logic [2:0] alu_op_code;
    logic [31:0] data_a, data_b;
    logic [31:0] register_out_7;
    
    // Instantiate the Unit Under Test (UUT)
    state_based_controller uut (
        .clk(clk),
        .command(command),
        .syscall(syscall),
        .Z(Z),
        .y(y),
        .alu_op_code(alu_op_code),
        .data_a(data_a),
        .data_b(data_b),
        .register_out_7(register_out_7)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test cases
    initial begin
        // Initialize inputs
        command = 0;
        syscall = 0;
        Z = 0;
        y = 0;
        
        // Wait for initial register initialization
        #10;
        
        // Test 1: Simple ADD operation (instruction 3'b000)
        $display("Test 1: ADD operation");
        command = {3'b000, 3'b001, 3'b010, 3'b111}; // ADD R1, R2 -> R7
        syscall = 1;
        #10 syscall = 0;
        
        // Provide ALU result (y) after EXECUTE state
        #20 y = 32'h12345678;
        #10;
        
        // Check if R7 was updated
        if (register_out_7 === 32'hBF141176)
            $display("Test 1 PASSED: R7 updated correctly");
        else
            $display("Test 1 FAILED: R7 = %h, expected BF141176", register_out_7);
        
        // Test 2: CAS operation (instruction 3'b111) with Z=1
        $display("\nTest 2: CAS operation (Z=1)");
        command = {3'b111, 3'b001, 3'b010, 3'b011}; // CAS R1, R2, R3
        syscall = 1;
        #10 syscall = 0;
        
        // Set Z flag for CAS_SWAP state
        #20 Z = 1;
        #10 Z = 0;
        
        // We can't directly observe the register swap, but we can check state transitions
        // In a real test, you would need to add a way to observe internal registers
        
        // Test 3: CAS operation (instruction 3'b111) with Z=0
        $display("\nTest 3: CAS operation (Z=0)");
        command = {3'b111, 3'b001, 3'b010, 3'b011}; // CAS R1, R2, R3
        syscall = 1;
        #10 syscall = 0;
        
        // Keep Z flag low for CAS_SWAP state
        #20 Z = 0;
        #10;
        
        // Test 4: Verify state transitions for non-CAS instruction
        $display("\nTest 4: Verify state transitions");
        command = {3'b010, 3'b001, 3'b010, 3'b111}; // Some operation
        syscall = 1;
        #10 syscall = 0;
        
        // Monitor state transitions (would need to make state visible in real test)
        #10; // Should be in DECODE
        #10; // Should be in EXECUTE
        #10; // Should be in WRITE_BACK
        #10; // Should be back to IDLE
        
        // Provide ALU result
        y = 32'hABCDEF01;
        #10;
        
        // Test 5: Multiple back-to-back operations
        $display("\nTest 5: Multiple operations");
        command = {3'b001, 3'b000, 3'b001, 3'b111}; // Operation 1
        syscall = 1;
        #10 syscall = 0;
        #20 y = 32'h11111111;
        #20;
        
        command = {3'b010, 3'b010, 3'b011, 3'b111}; // Operation 2
        syscall = 1;
        #10 syscall = 0;
        #20 y = 32'h22222222;
        #20;
        
        // Finish simulation
        $display("\nAll tests completed");
        $finish;
    end
    
    // Monitor changes
    initial begin
        $monitor("Time = %0t: state = %s, alu_op_code = %b, data_a = %h, data_b = %h, R7 = %h",
                 $time, uut.state.name(), alu_op_code, data_a, data_b, register_out_7);
    end
    
endmodule