module controller(
    input logic command[11:0],
    output logic op_code[2:0],
)

//decode the commands
instruction = command[11:9]
addr1 = command[8:6]
addr2 = command[5:3]
addr3 = command[2:0]

case (instruction)


    
endcase

endmodule