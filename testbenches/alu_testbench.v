module alu_testbench;
    reg [7:0] a, b;
    reg [3:0] op;
    reg carry_in;
    wire [7:0] result;
    wire zero, carry, sign, overflow;
    reg [8*10:1] op_name; // or string op_name;

    // Instantiate the ALU
    alu uut (
        .a(a),
        .b(b),
        .op(op),
        .carry_in(carry_in),
        .result(result),
        .zero(zero),
        .carry(carry),
        .sign(sign),
        .overflow(overflow)
    );

    initial begin
        // Test cases for each operation
         $display("Op | A   | B   | Result | Zero | Carry | Sign | Overflow");
         $display("---|-----|-----|--------|------|-------|------|---------");
        
        // Test PASS THRU
        op_name = "PASS THRU";
        a = 8'h55; b = 8'h00; op = 4'b0000; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test AND
        op_name = "AND";
        a = 8'hF0; b = 8'h0F; op = 4'b0001; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test OR
        op_name = "OR";
        a = 8'hF0; b = 8'h0F; op = 4'b0010; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test NOT
        op_name = "NOT";
        a = 8'hAA; b = 8'h00; op = 4'b0011; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test XOR
        op_name = "XOR";
        a = 8'hF0; b = 8'h0F; op = 4'b0100; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test LSL
        op_name = "LSL";
        a = 8'h01; b = 8'h02; op = 4'b0101; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);

        // Test LSR
        op_name = "LSR";
        a = 8'h80; b = 8'h02; op = 4'b0110; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test ASR
        op_name = "ASR";
        a = 8'h80; b = 8'h02; op = 4'b0111; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test ADD
        op_name = "ADD";
        a = 8'h7F; b = 8'h01; op = 4'b1000; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test SUB
        op_name = "SUB";
        a = 8'h01; b = 8'h02; op = 4'b1001; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test MUL
        op_name = "MUL";
        a = 8'h10; b = 8'h10; op = 4'b1010; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test NEG
        op_name = "NEG";
        a = 8'h01; b = 8'h00; op = 4'b1011; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test ADDI
        op_name = "ADDI";
        a = 8'h7F; b = 8'h01; op = 4'b1100; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test MULI
        op_name = "MULI";
        a = 8'h10; b = 8'h10; op = 4'b1101; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test ADC
        op_name = "ADC";
        a = 8'h7F; b = 8'h01; carry_in = 1; op = 4'b1110; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        // Test CMP
        op_name = "CMP";
        a = 8'h01; b = 8'h02; op = 4'b1111; #10;
        $display("%-10s %4b | A:%8b %02h %3d | B:%8b %02h %3d | R:%8b %02h %3d | Z:%1b C:%1b S:%1b O:%1b", op_name, op, a, a, a, b, b, b, result, result, result, zero, carry, sign, overflow);
        
        $finish;
    end
endmodule