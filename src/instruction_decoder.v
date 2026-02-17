module instruction_decoder(
    input wire [15:0] instruction,

    output reg [3:0] alu_opcode,
    output wire [2:0] rs,
    output wire [2:0] rt,
    output reg [2:0] rd,
    output wire [4:0] imm5,
    output reg pass_carry,
    output reg isImm,

    output reg mem_read,
    output reg mem_write,
    output reg [7:0] mem_addr8,
    output reg addr_is_reg, // if 1 then mem_addr8 is actually a register number whose value is the address to access

    output reg reg_write,

    output reg halt,

    output reg jump,
    output reg branch,
    output wire [10:0] jump_addr11,

    output reg [1:0] wb_sel // register write back 00=ALU result, 01=Memory data, 10=Immediate (for LOADI) 11=PC+1 (for JAL)
);
    wire [4:0] opcode;
    wire [2:0] rd_wire;

    assign opcode = instruction[15:11];
    assign rs = instruction[10:8];
    assign rt = instruction[7:5];
    assign rd_wire = instruction[2:0];
    assign imm5 = instruction[4:0];
    assign jump_addr11 = instruction[10:0];
    assign mem_addr8 = instruction[10:3];

    always @(*) begin
        alu_opcode  = 4'b0000;
        isImm       = 1'b0;
        pass_carry  = 1'b0;
        
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        addr_is_reg = 1'b0;

        rd          = rd_wire; // default destination register is rd field
        reg_write   = 1'b0;
        
        halt        = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        
        wb_sel      = 2'b00; // default is ALU
        //if opcode starts with 1 then its an alu operation
        //most alu operations write to reg so default it too
        if (opcode[4]) begin
            alu_opcode = opcode[3:0];
            reg_write = 1'b1;
        end

        case (opcode)
            5'b00000: begin //HALT
                halt = 1;
            end
            5'b00001: begin //LOAD
                mem_read = 1;
                wb_sel = 2'b01; // write back memory data
                reg_write = 1;
            end
            5'b00010: begin //STORE
                mem_write = 1;
            end
            5'b00011: begin //LOADI
                wb_sel = 2'b10; // write back immediate
                reg_write = 1;
                isImm = 1;
            end
            5'b00100: begin //BEQ
                branch = 1;
            end
            5'b00101: begin //BNE
                branch = 1;
            end
            5'b00110: begin //BLT
                branch = 1;
            end
            5'b00111: begin //BGT
                branch = 1;
            end
            5'b01000: begin //BLE
                branch = 1;
            end
            5'b01001: begin //BGE
                branch = 1;
            end
            5'b01010: begin //JUMP
                jump = 1;
            end
            5'b01011: begin //JAL
                jump = 1;
                reg_write = 1;
                rd = 3'b111; // write back to R7
                wb_sel = 2'b11; // write back PC+1
            end
            5'b01100: begin //RET
                jump = 1;
            end
            5'b01101: begin //MOVE
                alu_opcode = 4'b0000; // PASS THRU
                reg_write = 1;
            end
            5'b01110: begin //LOADR
                mem_read = 1;
                wb_sel = 2'b01; // write back memory data
                reg_write = 1;
                addr_is_reg = 1;
            end
            5'b01111: begin  //STORER
                // Reserved
                mem_write = 1;
                addr_is_reg = 1;
            end
            5'b10000: begin //NOP
                reg_write = 0;
            end
            /*
            from 10001 to 11011 (which are the following)
            AND
            OR
            NOT
            XOR
            LSL
            LSR
            ASR
            ADD
            SUB
            NEG
            have already been handled by the alu if check above
            */
            5'b11100: begin //ADDI
                isImm = 1;
            end
            5'b11101: begin //MULI
                isImm = 1;
            end
            5'b11110: begin //ADC
                pass_carry = 1;
            end
            5'b11111: begin //CMP
                reg_write = 0;
            end
        endcase
    end
endmodule