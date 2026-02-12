module instruction_memory_testbench;
    reg [10:0] address;
    wire [15:0] instruction;

    // Instantiate the instruction memory
    instruction_memory imem (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        // Test reading instructions from memory
        $display("Address    |Instruction");
        $display("-----------|-----------------");
        for (address = 0; address < 4; address = address + 1) begin
            #10; // Wait for a short time to simulate read delay
            $display("%b| %b", address, instruction);
        end
        $finish;
    end
endmodule