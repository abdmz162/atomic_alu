module seven_seg_display_driver (
    input logic clk, //100MHz
    input logic [31:0] number,
    output logic [6:0] seg_out,
    output logic [7:0] an
);

    logic [3:0] digits[7:0]; // 8 hex digits (0-F)
    logic [2:0] current_digit; // 0 to 7
    logic clk_800Hz;
    logic [15:0] clk_count;

    // Direct mapping of input number to digits
    always_comb begin
        digits[0] = number[3:0];
        digits[1] = number[7:4];
        digits[2] = number[11:8];
        digits[3] = number[15:12];
        digits[4] = number[19:16];
        digits[5] = number[23:20];
        digits[6] = number[27:24];
        digits[7] = number[31:28];
    end

    // Clock divider to create ~800Hz refresh rate from 100MHz
    always_ff @(posedge clk) begin
        if (clk_count == 62500) begin // 100MHz / 62500 / 2 = 800Hz (for both edges)
            clk_count <= 0;
            clk_800Hz <= ~clk_800Hz;
        end else begin
            clk_count <= clk_count + 1;
        end
    end

    // Digit cycling counter
    always_ff @(posedge clk_800Hz) begin
        current_digit <= current_digit + 1;
    end

    // Anode signal (active low)
    always_comb begin
        an = ~(8'b0000_0001 << current_digit);
    end

    // 7-segment decoder
    always_comb begin
        case (digits[current_digit])
            4'h0: seg_out = 7'b1000000;
            4'h1: seg_out = 7'b1111001;
            4'h2: seg_out = 7'b0100100;
            4'h3: seg_out = 7'b0110000;
            4'h4: seg_out = 7'b0011001;
            4'h5: seg_out = 7'b0010010;
            4'h6: seg_out = 7'b0000010;
            4'h7: seg_out = 7'b1111000;
            4'h8: seg_out = 7'b0000000;
            4'h9: seg_out = 7'b0010000;
            4'hA: seg_out = 7'b0001000;
            4'hB: seg_out = 7'b0000011;
            4'hC: seg_out = 7'b1000110;
            4'hD: seg_out = 7'b0100001;
            4'hE: seg_out = 7'b0000110;
            4'hF: seg_out = 7'b0001110;
            default: seg_out = 7'b1111111; // Blank
        endcase
    end

endmodule
