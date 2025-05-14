module controller(
    input  logic clk,
    input  logic [11:0] command,
    input  logic syscall, // RUN signal
    input  logic Z,
    input  logic [31:0] y,
    output logic [2:0] alu_op_code,
    output logic [31:0] data_a, data_b
);

    typedef enum logic [2:0] {
        IDLE, DECODE, EXECUTE, WRITE_BACK, CAS_WAIT, CAS_SWAP
    } state_t;

    state_t state, next_state;

    logic [31:0] registers [7:0];
    logic [2:0] instruction, addr1, addr2, addr3;
    logic [11:0] command_reg;

    initial begin
        $readmemh("register_init.hex", registers);
    end

    // Sequential logic for state transition
    always_ff @(posedge clk) begin
        if (syscall) begin
            state <= DECODE;
            command_reg <= command;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for FSM
    always_comb begin
        // Defaults
        next_state = IDLE;
        data_a = 0;
        data_b = 0;
        alu_op_code = 3'b000;

        case (state)
            IDLE: begin
                if (syscall)
                    next_state = DECODE;
                else
                    next_state = IDLE;
            end

            DECODE: begin
                instruction = command_reg[11:9];
                addr1 = command_reg[8:6];
                addr2 = command_reg[5:3];
                addr3 = command_reg[2:0];

                if (command_reg[11:9] == 3'b111)
                    next_state = CAS_WAIT;
                else
                    next_state = EXECUTE;
            end

            EXECUTE: begin
                data_a = registers[addr1];
                data_b = registers[addr2];
                alu_op_code = instruction;
                next_state = WRITE_BACK;
            end

            WRITE_BACK: begin
                registers[7] = y;
                next_state = IDLE;
            end

            CAS_WAIT: begin
                data_a = registers[addr1];
                data_b = registers[addr2];
                alu_op_code = 3'b001; // Subtract
                next_state = CAS_SWAP;
            end

            CAS_SWAP: begin
                if (Z) begin
                    logic [31:0] temp;
                    temp = registers[addr3];
                    registers[addr3] = registers[addr1];
                    registers[addr1] = temp;
                end
                next_state = IDLE;
            end
        endcase
    end

endmodule
