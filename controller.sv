module controller(
    input logic clk,
    input logic command[11:0],
    output logic op_code[2:0],
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
addr1 = command[8:6]
addr2 = command[5:3]
addr3 = command[2:0]

case (command) 

endcase




endmodule