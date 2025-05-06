module controller(
    input logic clk,
    input logic command[11:0],
    input logic syscall;//RUN fr
    output logic alu_op_code[2:0],
    output logic [31:0]alu_a,
    output logic [31:0]alu_b
);

inital begin
    //implement hex file stuff
endz
//declaring logic
logic [2:0] alu_a,alu_b,alu_op_code,instruction,addr1,addr2,addr3;
logic [31:0] d [7:0]; // 8 registers of 32 bits each
logic [31:0] q [7:0]; // 8 registers of 32 bits each

bit_32_register memory[7:0](
    .clk(clk),
    .d(d)
    .q(q)
); // 8 registers of 32 bits each


//decode the commands
instruction = command[11:9];
addr1 = command[8:6]; // addresses in memory
addr2 = command[5:3]; // addresses in memory
addr3 = command[2:0]; // addresses in memory


alwways_ff @(posedge syscall)begin//and ready
    
    if(command!=3'b111)begin        
        alu_a = q[addr1]; // read from memory
        alu_b = q[addr2]; // read from memory
        alu_op_code=instruction;
    end

end
endmodule