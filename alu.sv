`timescale 1ns / 1ps

//top module
module alu(
    input  logic [31:0] a, 
    input  logic [31:0] b, 
    input  logic [3:0]  op_code, 
    output logic O, C, Z, N, 
    output logic [31:0] y);
always_comb
begin
    C = (a[31] & b[31]) | ((a[31] | b[31]) & ~y[31]); //carry flag
    O = ~(a[31] ^ b[31]) & (y[31] ^ b[31]); //overflow flag
    Z = (y == 0); //zero flag
    N = y[31]; //negative flag
    case (op_code)
        4'b0000:begin
            y = a + b;
        end
        4'b0001:begin 
            y=a-b;
        end
        4'b0010:begin
        y=a+1;
        if (Z) begin
            C = 1; //carry flag
        end
        else begin
            C = 0; //carry flag
        end
        end

        4'b0011:begin y=0; C=0; O=0;end //cas
        4'b0100:begin y=a&b; C=0; O=0;end //bit_wise and 
        4'b0101:begin y=~a; C=0; O=0;end //bit_wise not of a
        4'b0110:begin y=a^b; C=0; O=0;end //bit_wise xor
        4'b0111:begin y=a|b; C=0; O=0;end //bit_wise or 
        default:begin  y=0; C=0; O=0;end //default case
    endcase
end
endmodule
