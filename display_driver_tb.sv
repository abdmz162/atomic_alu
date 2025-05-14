module tb_seven_seg_display_driver;

    logic clk;
    logic [31:0] number;
    logic [6:0] seg_out;
    logic [7:0] an;

    // Instantiate the DUT
    seven_seg_display_driver uut (
        .clk(clk),
        .number(number),
        .seg_out(seg_out),
        .an(an)
    );

    initial begin
        clk = 0;
    end
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        number = 32'h00000000;
        #12500000
        number = 32'hDEADBEEF;
        #12500000
        number = 32'h12345678;
        #12500000
        number = 32'h87654321;
        #12500000
        number = 32'hFFFFFFFF;

        $finish; 
    end

endmodule
