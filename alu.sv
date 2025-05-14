module alu(
    input  logic [31:0] a, 
    input  logic [31:0] b, 
    input  logic [2:0] op_code, 
    output logic O, C, Z, N, 
    output logic [31:0] y
    );
    
    always_comb begin
        case (op_code)
            3'b000: begin //add
                y = a + b;
            end
            
            3'b001: begin //subt
                y = a - b;
            end
            
            3'b010: begin //increment
                y = a + 1;
            end

            3'b011: begin //b_and
                y = a & b;
            end
            
            3'b100: begin //b_or
                y = a | b;
            end
            
            3'b101: begin //b_xor
                y = a ^ b;
            end
            
            3'b110: begin //b_not
                y = ~a;
            end
            
            default: begin //default
                y = 0;
            end
        endcase

        C = ((a[31] | b[31]) & ~y[31]); //carry flag
        O = ~(a[31] ^ b[31]) & (y[31] ^ b[31]); //overflow flag
        Z = (y == 0); //zero flag
        N = y[31]; //negative flag

        // Special case for increment carry
        if (op_code == 3'b010) begin
            C = Z ? 1'b1 : 1'b0;
        end

        // Clear C and O for logical operations
        if (op_code inside {3'b011, 3'b100, 3'b101, 3'b110}) begin
            C = 1'b0;
            O = 1'b0;
        end
    end

endmodule