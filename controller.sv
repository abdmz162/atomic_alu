module controller(
    input logic clk,
    input logic command[11:0],
    output logic alu_op_code[2:0],
    output logic alu_a[31:0],
    output logic alu_b[31:0],
)

[7:0] mem = 
//decode the commands
instruction = command[11:9]
addr1 = command[8:6] // addresses in memory
addr2 = command[5:3] // addresses in memory
addr3 = command[2:0] // addresses in memory

case (command)[11:9]
    3'b000: begin // ADD
        alu_a = memory[addr1];
        alu_b = memory[addr2];
        alu_op_code = 3'b000;

    end
    3'b001: begin // SUB
        alu_a = memory[addr1];
        alu_b = memory[addr2];
        alu_op_code = 3'001;
    end
    3'b010: begin // AND
        alu_a = memory[addr1];
        alu_b = memory[addr2];
        alu_op_code = 3'010;
    end
    3'b011: begin // OR
        alu_a = memory[addr1];
        alu_b = memory[addr2];
        alu_op_code = 3'011;
    end
    3'b100: begin // NOT
        alu_a = memory[addr1];
        alu_op_code = 3'100;
    end
    default: begin // NOP
        op_code = 3'b111;
    end

endcase




endmodule