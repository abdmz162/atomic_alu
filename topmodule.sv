module topmodule(
    input [11:0] command,
    input clk,
    input run,
    output logic [6:0] seg_out,
    output logic [7:0] an
    );

    logic [31:0] data_a, data_b;
    logic [31:0] output_a, output_b;
    logic [2:0] op_code;
    logic O, C, Z, N;
    logic [31:0] y;
    logic [31:0] register_out_7;
    
    bit_32_register alu_a_register(.clk(clk), .d(data_a), .q(output_a));
    bit_32_register alu_b_register(.clk(clk), .d(data_b), .q(output_b));

    state_based_controller ctrl( .clk(clk), .command(command), .syscall(run), .alu_op_code(op_code), .data_a(data_a), .data_b(data_b), .y(y), .Z(Z), .register_out_7(register_out_7));

    alu top_alu(.a(output_a), .b(output_b), .op_code(op_code), .O(O), .C(C), .Z(Z), .N(N), .y(y));

    seven_seg_display_driver display(.clk(clk), .number(register_out_7), .seg_out(seg_out), .an(an));


endmodule

