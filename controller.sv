module controller(
    input logic clk,
    input logic [11:0] command,
    input logic syscall,//RUN
    input logic Z,
    input logic [31:0] y,
    output logic [2:0] alu_op_code,
    output logic [31:0] data_a, data_b
);
    // Declaring logic
    logic ready = 1;
    logic [31:0] registers [7:0];  // 8 registers of 32-bit width
    logic [2:0] instruction,addr1,addr2,addr3;


    initial begin
        $readmemh("register_init.hex", registers);
    end

    
    //decode the commands
    assign instruction = command[11:9];
    assign addr1 = command[8:6]; // addresses in memory
    assign addr2 = command[5:3]; // addresses in memory
    assign addr3 = command[2:0]; // addresses in memory


    always @(posedge syscall) begin // And ready
        if (command!=3'b111) begin    // All other operations    
            ready <= 0;
            data_a <= registers[addr1]; // read from memory
            data_b <= registers[addr2]; // read from memory
            alu_op_code <= instruction;
            registers[7] <= y;
            ready <= 1;
        end else begin      // CAS operation
            ready <= 0;
            data_a <= registers[addr1];
            data_b <= registers[addr2];
            alu_op_code <= 001; // Subtract
            @(posedge clk)
            if (Z) begin
                registers[7] <= registers[addr3];       // Swapping logic
                registers[addr3] <= registers[addr1];         // Swapping logic
                registers[addr1] <= registers[7];
                registers[7] <= 32'b1;
            end else begin
                registers[7] <= 32'b0;
            end
            ready <= 1;
        end
    end
endmodule