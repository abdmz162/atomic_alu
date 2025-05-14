module tb_seven_seg_display_driver;

    logic clk;
    logic rst;
    logic load;
    logic [31:0] number;
    logic [6:0] seg_out;
    logic [7:0] an;

    // Instantiate the DUT
    seven_seg_display_driver uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .number(number),
        .seg_out(seg_out),
        .an(an)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        rst = 1;
        load = 0;
        number = 32'h00000000;

        // Hold reset briefly
        #100;
        rst = 0;

        // Load test number (DEADBEEF)
        number = 32'hDEADBEEF;
        load = 1;
        #20;
        load = 0;

        // Run simulation for a while
        #2000;

        $finish;
    end

endmodule
