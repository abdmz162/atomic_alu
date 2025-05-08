module bit_32_register (
    input  logic clk,   // clock input
    input logic writeEnable = 1,
    input  logic [31:0]  d = 32'h0,     // 32-bit data input
    output logic [31:0]  q = 32'h0    // 32-bit output
);

    always_ff @(posedge clk) begin
        if (writeEnable) begin
            q <= d;    
        end    // Update register when enable is high
        else begin
            q <= q;
        end
    end
endmodule