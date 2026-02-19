`timescale 1ns / 1ps

module reg_file_testbench;

    // Inputs
    reg clk;
    reg rst;
    reg we;
    reg [2:0] wa;
    reg [15:0] wd;
    reg [2:0] ra1;
    reg [2:0] ra2;

    // Outputs
    wire [15:0] rd1;
    wire [15:0] rd2;

    // Instantiate the Unit Under Test (UUT)
    reg_file uut (
        .clk(clk), 
        .rst(rst), 
        .we(we), 
        .wa(wa), 
        .wd(wd), 
        .ra1(ra1), 
        .rd1(rd1), 
        .ra2(ra2), 
        .rd2(rd2)
    );

    // Clock generation (100MHz)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("testbenches/reg_file_testbench.vcd");
        $dumpvars(0, reg_file_testbench);
        // Initialize Inputs
        clk = 0;
        rst = 1;
        we = 0;
        wa = 0;
        wd = 0;
        ra1 = 0;
        ra2 = 0;

        // 1. Reset Test
        #20 rst = 0;
        $display("--- Reset Complete ---");

        // 2. Write to R1 and R2
        #10;
        we = 1; wa = 3'd1; wd = 16'hAAAA; // Write 0xAAAA to R1
        #10;
        wa = 3'd2; wd = 16'h5555;        // Write 0x5555 to R2
        #10;
        we = 0;

        // 3. Read from R1 and R2 simultaneously
        ra1 = 3'd1;
        ra2 = 3'd2;
        #10;
        $display("R1 (expected AAAA): %h", rd1);
        $display("R2 (expected 5555): %h", rd2);

        // 4. Test R0 Invariant (Attempt to write to R0)
        we = 1; wa = 3'd0; wd = 16'hFFFF; 
        #10;
        we = 0; ra1 = 3'd0;
        #10;
        if (rd1 == 16'h0000) 
            $display("R0 Test Passed: R0 remains 0 despite write attempt.");
        else 
            $display("R0 Test Failed: R0 was overwritten with %h!", rd1);

        // 5. Test JAL/RET Register (R7)
        we = 1; wa = 3'd7; wd = 16'h1234;
        #10;
        we = 0; ra2 = 3'd7;
        #10;
        $display("R7 Test: %h", rd2);

        #50;
        $finish;
    end
      
endmodule