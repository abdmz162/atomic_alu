module controller(
    input logic clk,
    input logic [11:0] command,
    input logic syscall,//RUN
    input logic O, C, Z, N,
    input logic [31:0] y,
    output logic [2:0] alu_op_code,
    output logic [31:0] data_a, data_b
);
    // Declaring logic
    logic ready;
    logic [31:0] registers [0:7];  // 8 registers of 32-bit width
    logic [2:0] instruction,addr1,addr2,addr3;
    logic [31:0] d [7:0]; // 32 bit data for 8 registers
    logic [31:0] q [7:0]; // 32 bit output of 8 registers
    logic [31:0] data_a, data_b;
    logic [7:0] writeEnables;


    inital begin
        $readmemh("register_init.hex", registers);
        for(i=0;i<8;i++) begin
            d[i] = registers[i];
        end
    end



    bit_32_register memory[7:0](
        .clk(clk),
        .d(d),
        .q(q),
        .writeEnable(writeEnables)
    );

    always_comb begin
        //decode the commands
        instruction = command[11:9];
        addr1 = command[8:6]; // addresses in memory
        addr2 = command[5:3]; // addresses in memory
        addr3 = command[2:0]; // addresses in memory
    end

    always_ff @(posedge syscall) begin // And ready
        writeEnable[addr1] = 0; // Disable write to all registers
        writeEnable[addr2] = 0; // Disable write to all registers
        writeEnable[addr3] = 0; // Disable write to all registers

        if(command!=3'b111) begin    // All other operations    
            ready <= 0;
            data_a <= q[addr1]; // read from memory
            data_b <= q[addr2]; // read from memory
            alu_op_code <= instruction;
            d[7] = y;
            ready <= 1;

        end else begin      // CAS operation
            ready <= 0;
            data_a <= q[addr1];
            data_b <= q[addr3];
            op_code <= 001; // Subtract
            @(posedge clk)
            if Z begin
                writeEnable[addr3] = 1;
                writeEnable[addr1] = 1;
                d[addr3] <= data_a;         // Swapping logic
                d[addr1] <= q[addr2];       // Swapping logic
                d[7] <= 32'b1;
            end else begin
                d[7] <= 32'b0;
            end
            ready <= 1;
        end
        writeEnable[addr1] = 1; // Enable write to register 1
        writeEnable[addr2] = 1; // Enable write to register 2
        writeEnable[addr3] = 1; // Enable write to register 3
    end

endmodule