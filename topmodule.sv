module topmodule(
    input [11:0]command,
    input clk,
    input run
    );

    logic [31:0] data_a, data_b;
    logic [31:0] output_a, output_b;
    logic [2:0] op_code;
    logic O, C, Z, N;
    logic [31:0] y;
    
    bit_32_register alu_a_register(.d(data_a), .q(output_a));
    bit_32_register alu_a_register(.d(data_b), .q(output_b));

    controller ctrl( .clk(clk), .command(commmand), .syscall(run), .alu_op_code(op_code), .data_a(data_a), .data_b(data_b), .y(y));
    alu top_alu(.a(output_a), .b(output_b), .op_code(op_code), .O(O), .C(C), .Z(Z), .N(N), .y(y));


endmodule

