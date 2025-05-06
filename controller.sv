module controller(
    input logic clk,
    input logic command[11:0],
    output logic op_code[2:0],
    output logic alu_a[31:0],
    output logic alu_b[31:0],
    output logic alu_op_code[3:0]
)
    

logic reset, enable, [7:0]q, [7:0]d, [7:0]reset, [7:0]enable;
//instantiate the memory module
memory mem[7:0](
    .d(d),
    .q(q),
    .clk(clk),
    .reset(reset),
    .enable(enable)
);
//decode the commands
instruction = command[11:9]
addr1 = command[8:6] // addresses in memory
addr2 = command[5:3] // addresses in memory
addr3 = command[2:0] // addresses in memory

case (command)[11:9]
    3'b000: begin // ADD
        
    end
    3'b001: begin // SUB
        op_code = 3'b001;
        d = q[addr1] - q[addr2];
    end
    3'b010: begin // AND
        op_code = 3'b010;
        d = q[addr1] & q[addr2];
    end
    3'b011: begin // OR
        op_code = 3'b011;
        d = q[addr1] | q[addr2];
    end
    3'b100: begin // NOT
        op_code = 3'b100;
        d = ~q[addr1];
    end
    default: begin // NOP
        op_code = 3'b111;
        d = 8'b00000000;
    end

endcase




endmodule