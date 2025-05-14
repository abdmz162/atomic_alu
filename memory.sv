module bit_32_register (
    input  logic clk,   // clock input
    input  logic [31:0]  d,     // 32-bit data input
    output logic [31:0]  q    // 32-bit output
);

    always_ff @(posedge clk) begin
            q <= d;
    end
endmodule