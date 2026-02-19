module fat_cat_cpu_testbench;
    reg clk;
    reg rst;

    // Instantiate the CPU
    fat_cat_cpu cpu (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Test sequence
    initial begin
        // Initialize reset
        rst = 1;
        #10; // Hold reset for a few cycles
        rst = 0;

        // Wait for some time to let the CPU execute instructions
        #100;
        
        // Finish simulation
        $finish;
    end
endmodule