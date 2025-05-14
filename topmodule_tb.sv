module topmodule_tb;
    // Inputs
    logic [11:0] command;
    logic clk;
    logic run;
    
    // Outputs
    logic [6:0] seg_out;
    logic [7:0] an;

    // Instantiate the topmodule
    topmodule dut(
        .command(command),
        .clk(clk),
        .run(run),
        .seg_out(seg_out),
        .an(an)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        command = 12'h000;
        run = 0;
        #1250_0000;

        // Test case 1: ADD operation (R1 + R2 -> R7)
        // command format: [op(3bits)][addr1(3bits)][addr2(3bits)][addr3(3bits)]
        command = 12'b000_001_010_000;  // ADD R1,R2
        run = 1;
        #6250000;
        run = 0;
        #1250_0000;  // Wait for operation to complete

        // // Test case 2: SUBTRACT operation (R3 - R4 -> R7)
        // command = 12'b001_011_100_000;  // SUB R3,R4
        // run = 1;
        // #6250000;
        // run = 0;
        // #1250_0000;

        // // Test case 3: AND operation (R5 & R6 -> R7)
        // command = 12'b011_101_110_000;  // AND R5,R6
        // run = 1;
        // #6250000;
        // run = 0;
        // #1250_0000;

        // // Test case 4: CAS operation (Compare and Swap)
        // command = 12'b111_001_010_011;  // CAS R1,R2,R3
        // run = 1;
        // #6250000;
        // run = 0;
        // #1250_0000;

        // // Add more test cases as needed

        // // End simulation
        // #1250_0000;
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t command=%h run=%b an=%b seg_out=%b, state=%s, register_out_7=%h", 
                 $time, command, run, an, seg_out, dut.ctrl.state.name(), dut.register_out_7);
    end

endmodule