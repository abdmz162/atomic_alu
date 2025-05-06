module memory(
    input logic d[31:0], q[31:0],
    input logic clk, reset, enable
)
always_ff @(posedge clk) begin
    if (reset) begin
        q <= 32'b0; // Reset the output to zero
    end else if (enable) begin
         q <= d; // Load data into the output on the rising edge of the clock
    end else begin
        q <= 0; // Maintain the current value if not enabled
    end
end


endmodule