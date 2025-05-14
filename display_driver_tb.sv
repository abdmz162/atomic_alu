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

        // Hold reset briefly

        // Load test number (DEADBEEF)
        number = 32'hDEADBEEF;
        #100
        number = 32'h12345678;
        #100
        number = 32'h87654321;
        #100
        number = 32'hFFFFFFFF;
        #100
    end

endmodule
