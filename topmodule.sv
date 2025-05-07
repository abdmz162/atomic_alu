module topmodule(
    input [11:0]command,
    input clk,
    input run
    );

    logic O,C,Z,N;
    logic [2:0]op_code;
    logic [31:0] data_a,data_b,output_a,output_b,y;    
    controller ctrl( .clk(clk), command(commmand), syscall(run),alu_op_code(op_code),.data_a(data_a),.data_b(data_b).y(y));
    bit_32_register alu_a(.clk(clk),.d(data_a),.q(output_a));
    bit_32_register alu_b(.clk(clk),.d(data_b),.q(output_b));
    alu top_alu(.a(output_a),.b(output_b),.op_code(op_code),.y(y),.O(O),.C(C),.Z(Z),.N(N));

endmodule

