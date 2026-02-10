/*
    0000	PASS THRU
    0001	AND
    0010	OR
    0011	NOT
    0100	XOR
    0101	LSL
    0110	LSR
    0111	ASR
    1000	ADD
    1001	SUB
    1010	MUL
    1011	NEG
    1100	NOP (addi)
    1101	NOP (muli)
    1110	ADC
    1111	CMP

*/
module alu(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [3:0] op,
    output reg [7:0] result,
    output reg zero,
    output reg carry,
    output reg sign,
    output reg overflow
);
    reg [8:0] sum; // extended for carry
    reg [7:0] b_comp;
    reg [15:0] mul_result; // for multiplication

    always @(*) begin
        // Default flags
        zero = 0;
        carry = 0;
        sign = 0;
        overflow = 0;
        sum = 9'b0;

        case (op)
            4'b0000: result = a; // PASS THRU
            4'b0001: result = a & b; // AND
            4'b0010: result = a | b; // OR
            4'b0011: result = ~a; // NOT
            4'b0100: result = a ^ b; // XOR
            4'b0101:result = a << b; // LSL
            4'b0110:result = a >> b; // LSR
            4'b0111: result = $signed(a) >>> b; // ASR
            4'b1000: begin // ADD
                sum = a + b;
                result = sum[7:0];
                carry = sum[8];
                overflow = (a[7] == b[7]) && (result[7] != a[7]);
            end
            4'b1001: begin // SUB
                b_comp = ~b + 1; // Two's complement of b
                sum = a + b_comp;
                result = sum[7:0];
                carry = sum[8];
                overflow = (a[7] != b_comp[7]) && (result[7] != a[7]);
                zero = (result == 0);
            end
            4'b1010: begin
                mul_result = a * b; // MUL
                result = mul_result[7:0];
                carry = (mul_result > 8'hFF); // Check if upper byte is non-zero
                overflow = (mul_result > 8'hFF); // For simplicity, treat overflow same as carry
            end
            4'b1011: result = -a; // NEG
            4'b1110: begin // ADC (Add with Carry)
                sum = a + b + carry;
                result = sum[7:0];
                carry = sum[8];
                overflow = (a[7] == b[7]) && (result[7] != a[7]);
            end
            4'b1111: begin // CMP (compare)
                sum = a - b;
                zero = (sum[7:0] == 0);
                carry = sum[8];
                overflow = (a[7] != b[7]) && (sum[7] != a[7]);
                result = 8'b0; // CMP does not produce a result
            end
            default: result = 8'b0;
        endcase
        zero = (result == 0);
        sign = result[7];
    end
endmodule