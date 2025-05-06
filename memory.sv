module 32_bit_register (
    input  logic        clk,   // clock input
    input  logic [31:0]  d = 32'h0,     // 32-bit data input
    output logic [31:0]  q = 32'h0      // 32-bit output
);

    always_ff @(posedge clk) begin
            q <= d;        // Update register when enable is high
    end

endmodule