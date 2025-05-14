module seven_seg_display_driver (
    input logic clk,
    input logic rst,
    input logic load,
    input logic [31:0] number,
    output logic [6:0] seg_out,
    output logic [7:0] an
);

    logic [3:0] digits[7:0]; // 8 hex digits (0-F)
    logic [2:0] current_digit; // 0 to 7
    logic clk_800Hz;
    logic [15:0] clk_count;

    // Load the input number into digits[0] (LSB) to digits[7] (MSB)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            digits[0] <= 4'd0; digits[1] <= 4'd0; digits[2] <= 4'd0; digits[3] <= 4'd0;
            digits[4] <= 4'd0; digits[5] <= 4'd0; digits[6] <= 4'd0; digits[7] <= 4'd0;
        end else if (load) begin
            digits[0] <= number[3:0];
            digits[1] <= number[7:4];
            digits[2] <= number[11:8];
            digits[3] <= number[15:12];
            digits[4] <= number[19:16];
            digits[5] <= number[23:20];
            digits[6] <= number[27:24];
            digits[7] <= number[31:28];
        end
    end

    // Clock divider to create ~800Hz refresh rate from 50MHz
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count <= 0;
            clk_800Hz <= 0;
        end else if (clk_count == 62500) begin // 100MHz / 62500 / 2 = 800Hz (for both edges)
            clk_count <= 0;
            clk_800Hz <= ~clk_800Hz;
        end else begin
            clk_count <= clk_count + 1;
        end
    end

    // Digit cycling counter
    always_ff @(posedge clk_800Hz or posedge rst) begin
        if (rst)
            current_digit <= 3'd0;
        else
            current_digit <= current_digit + 1;
    end

    // Anode signal (active low)
    always_comb begin
    an = ~(8'b0000_0001 << current_digit);
    end


    // 7-segment decoder
    always_comb begin
        case (digits[current_digit])
            4'h0: seg_out = 7'b100_0000;
            4'h1: seg_out = 7'b111_1001;
            4'h2: seg_out = 7'b010_0100;
            4'h3: seg_out = 7'b011_0000;
            4'h4: seg_out = 7'b001_1001;
            4'h5: seg_out = 7'b001_0010;
            4'h6: seg_out = 7'b000_0010;
            4'h7: seg_out = 7'b111_1000;
            4'h8: seg_out = 7'b000_0000;
            4'h9: seg_out = 7'b001_0000;
            4'hA: seg_out = 7'b000_1000;
            4'hB: seg_out = 7'b000_0011;
            4'hC: seg_out = 7'b100_0110;
            4'hD: seg_out = 7'b010_0001;
            4'hE: seg_out = 7'b000_0110;
            4'hF: seg_out = 7'b000_1110;
            default: seg_out = 7'b111_1111; // Blank
        endcase
    end

endmodule
