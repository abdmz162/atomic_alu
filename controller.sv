module controller(
    input logic clk,
    input logic [11:0] command,
    input logic syscall,//RUN
    input logic O, C, Z, N,
    output logic [2:0] alu_op_code,
    output logic [31:0] data_a, data_b
);

    logic [31:0] registers [0:7];  // 8 registers of 32-bit width

    inital begin
        $readmemh("register_init.hex", registers);
        for(i=0;i<8;i++) begin
            d[i] = registers[i];
        end
    end

    logic [31:0] data_a, data_b

    // Declaring logic
    logic [2:0] alu_op_code,instruction,addr1,addr2,addr3;
    logic [31:0] d [7:0]; // 32 bit data for 8 registers
    logic [31:0] q [7:0]; // 32 bit output of 8 registers

    bit_32_register memory[7:0](
        .clk(clk),
        .d(d),
        .q(q)
    );

    always_comb begin
    //decode the commands
    instruction <= command[11:9];
    addr1 <= command[8:6]; // addresses in memory
    addr2 <= command[5:3]; // addresses in memory
    addr3 <= command[2:0]; // addresses in memory
    end

    alwways_ff @(posedge syscall)begin // And ready
        if(command!=3'b111)begin    // All other operations    
            data_a <= q[addr1]; // read from memory
            data_b <= q[addr2]; // read from memory
            alu_op_code <= instruction;
        end else begin      // CAS operation
            data_a <= q[addr1];
            data_b <= q[addr3];
            op_code <= 001; // Subtract
            @(posedge clk)
            if Z begin
                d[addr3] <= data_a;
                d[addr1] <= q[addr2];
                d[7] <= 32'b1;
            end else begin
                d[7] <= 32'b0;
            end
        end
    end

endmodule