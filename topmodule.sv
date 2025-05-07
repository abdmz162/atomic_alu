module topmodule(
    input [11:0]command,
    input clk,
    input run
    );

    logic op_code;
    controller ctrl( .clk(clk), command(commmand), syscall(run), alu_op_code(op_code));
    alu top_alu()


endmodule

