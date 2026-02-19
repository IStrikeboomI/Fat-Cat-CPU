module fat_cat_cpu(
    input wire clk,
    input wire rst
)   
    //Program counter
    reg [10:0] pc;
    reg [10:0] pc_next;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 11'b0;
        end else begin
            pc <= pc_next;
        end
    end

    //Instruction memory
    wire [15:0] instruction;
    instruction_memory imem (
        .address(pc),
        .instruction(instruction)
    );
    //Instruction decoder
    wire [3:0] alu_opcode;
    wire [2:0] rs, rt;
    wire [2:0] rd;
    wire [4:0] imm5;
    wire pass_carry;
    wire isImm;
    wire mem_read, mem_write;
    wire [7:0] mem_addr8;
    wire addr_is_reg;
    wire reg_write;
    wire halt;
    wire jump, branch;
    wire [10:0] jump_addr11;
    wire [1:0] wb_sel;
    instruction_decoder idec (
        .instruction(instruction),
        .alu_opcode(alu_opcode),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .imm5(imm5),
        .pass_carry(pass_carry),
        .isImm(isImm),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_addr8(mem_addr8),
        .addr_is_reg(addr_is_reg),
        .reg_write(reg_write),
        .halt(halt),
        .jump(jump),
        .branch(branch),
        .jump_addr11(jump_addr11),
        .wb_sel(wb_sel)
    );

    //Register file
    wire [7:0] rs_data, rt_data;
    reg[7:0] wb_data;
    reg_file (
        .clk(clk),
        .rst(rst),
        .reg_write(reg_write),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .write_data(wb_data),
        .rs_data(rs_data),
        .rt_data(rt_data)
    );
    //ALU
    wire [7:0] alu_result;
    reg carry_out, zero, sign, overflow;
    alu alu_unit (
        .opcode(alu_opcode),
        .a(rs_data),
        .b(isImm ? imm5 : rt_data),
        .carry_in(pass_carry ? carry_out : 0),
        .result(alu_result),
        .carry(carry_out),
        .zero(zero),
        .sign(sign),
        .overflow(overflow)
    );
    //Write back MUX
    always @(*) begin
        case (wb_sel)
            2'b00: wb_data = alu_result; // ALU result
            2'b01: wb_data = mem_read_data;   // Memory data
            2'b10: wb_data = mem_addr8; // Immediate value
            2'b11: wb_data = pc + 11'b1; // PC + 1
            default: wb_data = 8'b0;
        endcase
    end
    //Data memory
    wire [7:0] mem_read_data;
    data_memory dmem (
        .clk(clk),
        .rst(rst),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(addr_is_reg ? rs_data : mem_addr8),
        .write_data(rd_data), // store value is always in rd for store instructions
        .read_data(mem_read_data)
    );
    reg branch_taken;
    always @(*) begin
        branch_taken = 1'b0;
        if (branch) begin
            case (instruction[15:11]) // branch type
                5'b00100: branch_taken = zero;          // BEQ
                5'b00101: branch_taken = ~zero;         // BNE
                5'b00110: branch_taken = sign ^ overflow;          // BLT
                5'b00111: branch_taken = ~zero & ~(sign ^ overflow);         // BGT
                5'b01000: branch_taken = zero | (sign ^ overflow);      // BLE
                5'b01001: branch_taken = ~(sign ^ overflow);     // BGE
                default: branch_taken = 1'b0;
            endcase
        end
    end
    //Next PC logic
    assign pc_next = halt ? pc : 
                     jump ? jump_addr11 : 
                     branch_taken ? pc + jump_addr11 : 
                     pc + 11'b1;
endmodule