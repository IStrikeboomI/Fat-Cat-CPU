module fat_cat_cpu_testbench;
    // Signals
    reg clk;
    reg rst;

    // Instantiate the CPU
    fat_cat_cpu uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer i; // For loops

    initial begin
        $dumpfile("testbenches/fat_cat_cpu_testbench.vcd");
        $dumpvars(0, fat_cat_cpu_testbench);
        // Initialize signals
        clk = 0;
        rst = 1;

        $display("--- Starting CPU Simulation ---");
        #10 rst = 0;

        // Execution Loop
        while (!uut.halt) begin
            @(posedge clk);
             $display("Time: %t | PC: %h | Instr: %b", $time, uut.pc, uut.instruction);
        end

        // Execution has halted [cite: 67, 83]
        $display("\n--- Execution Halted at Time %t ---", $time);
        $display("Final PC: %h", uut.pc);

        // --- Print Register File ---
        $display("\n--- Register File (R0-R7) ---");
        $display("Reg | Value (Hex) | Value (Dec)");
        $display("----|-------------|------------");
        for (i = 0; i < 8; i = i + 1) begin
            // Accessing internal registers array from reg_file module 
            $display("R%0d  | %h          | %d", i, uut.rfile.registers[i], uut.rfile.registers[i]);
        end

        // --- Print First 16 Bytes of Data Memory ---
        $display("\n--- Data Memory (First 16 Bytes) ---");
        $display("Addr | Value (Hex) | Value (Dec)");
        $display("-----|-------------|------------");
        for (i = 0; i < 128; i = i + 1) begin
            // Accessing internal ram array from data_memory module 
            $display("0x%02h | %h          | %d", i, uut.dmem.ram[i], uut.dmem.ram[i]);
        end

        $display("\n--- Simulation Finished ---");
        $finish;
    end

endmodule