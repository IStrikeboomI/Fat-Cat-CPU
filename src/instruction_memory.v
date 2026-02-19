module instruction_memory(
    input wire [10:0] address,
    output reg [15:0] instruction
);
    // Simple instruction memory with 2048 instructions
    reg [15:0] memory [0:2047]; // Initialize all instructions to 0
    integer i;
    initial begin
        for (i = 0; i < 2048; i = i + 1) begin
            memory[i] = 16'h0000;
        end
        $readmemb("programs/fibbonaci.bin", memory);
    end

    always @(*) begin
        instruction = memory[address[10:0]]; // Use lower 11 bits for addressing
    end
endmodule