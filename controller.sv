module controller(
    input logic clk,
    input logic [11:0] command,
    input logic syscall,//RUN
    input logic Z,
    input logic [31:0] y,
    output logic [2:0] alu_op_code,
    output logic [31:0] data_a, data_b,
    output logic ready = 1
);
    // Declaring logic
    logic [31:0] registers [7:0];  // 8 registers of 32-bit width
    logic [2:0] instruction,addr1,addr2,addr3;
    logic [31:0] d [7:0]; // 32 bit data for 8 registers
    logic [31:0] q [7:0]; // 32 bit output of 8 registers
    logic [31:0] data_a, data_b;
    logic [7:0] write_enables;


    initial begin
        $readmemh("register_init.hex", registers);
        for(int i=0;i<8;i++) begin
            d[i] = registers[i];
        end
    end



    bit_32_register memory[7:0](
        .clk(clk),
        .d(d),
        .q(q),
        .writeEnable(write_enables)
    );

    
    //decode the commands
    instruction = command[11:9];
    addr1 = command[8:6]; // addresses in memory
    addr2 = command[5:3]; // addresses in memory
    addr3 = command[2:0]; // addresses in memory


    always_ff @(posedge syscall) begin // And ready
        writeEnable[addr1] <= 0; // Disable write to all registers
        writeEnable[addr2] <= 0; // Disable write to all registers
        writeEnable[addr3] <= 0; // Disable write to all registers
        if (ready==1)begin
            if(command!=3'b111) begin    // All other operations    
                ready <= 0;
                data_a <= q[addr1]; // read from memory
                data_b <= q[addr2]; // read from memory
                alu_op_code <= instruction;
                d[7] <= y;
                ready <= 1;
            end else begin      // CAS operation
                ready <= 0;
                data_a <= q[addr1];
                data_b <= q[addr2];
                alu_op_code <= 001; // Subtract
                @(posedge clk)
                if (Z) begin
                    writeEnable[addr3] <= 1;
                    writeEnable[addr1] <= 1;
                    d[7] <= q[addr3];       // Swapping logic
                    d[addr3] <= q[addr1];         // Swapping logic
                    d[addr1] <= q[7];
                    d[7] <= 32'b1;
                end else begin
                    d[7] <= 32'b0;
                end
                ready <= 1;
            end
            writeEnable[addr1] = 1; // Enable write to register 1
            writeEnable[addr2] = 1; // Enable write to register 2
            writeEnable[addr3] = 1; // Enable write to register 3
        
        end else begin
            // Explicitly retain or reset values if needed
            data_a <= data_a;
            data_b <= data_b;
            alu_op_code <= alu_op_code;
            d[7] <= d[7];
        end

    end

endmodule