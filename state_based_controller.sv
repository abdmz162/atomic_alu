module state_based_controller(
    input  logic clk,
    input  logic [11:0] command,
    input  logic syscall, // RUN signal
    input  logic Z,
    input  logic [31:0] y,
    output logic [2:0] alu_op_code,
    output logic [31:0] data_a, data_b,
    output logic [31:0] register_out_7
);

    typedef enum logic [2:0] {
        IDLE, DECODE, EXECUTE, WRITE_BACK, CAS_WAIT, CAS_SWAP
    } state_t;

    state_t state = IDLE, next_state = IDLE;

    logic [31:0] registers [7:0];
    logic [2:0] instruction, addr1, addr2, addr3;
    logic [11:0] command_reg;
    logic syscall_latched;

    initial begin
        $readmemh("register_init.hex", registers);
        // If you want to verify the initialization, you could add:
        $display("Register 0: %h", registers[0]);
        $display("Register 1: %h", registers[1]);
        $display("Register 2: %h", registers[2]);
        $display("Register 3: %h", registers[3]);
        $display("Register 4: %h", registers[4]);
        $display("Register 5: %h", registers[5]);
        $display("Register 6: %h", registers[6]);
        $display("Register 7: %h", registers[7]);
    end

    // Output register for register 7
    assign register_out_7 = registers[7];

    // Latch syscall and command only when in IDLE
    always_ff @(posedge clk) begin
        if (state == IDLE && syscall) begin
            syscall_latched <= 1;
            command_reg <= command;
        end else if (state == DECODE) begin
            syscall_latched <= 0; // clear latch after decoding starts
        end
    end

    // Sequential logic for state transition
    always_ff @(posedge clk) begin
        state <= next_state;
    end

    // Combinational logic for FSM
    always_comb begin
        // Defaults
        next_state = state;
        data_a = 0;
        data_b = 0;
        alu_op_code = 3'b000;

        case (state)
            IDLE: begin
                if (syscall_latched)
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
