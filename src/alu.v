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
    1100	ADDI
    1101	MULI
    1110	ADC
    1111	CMP

*/
module alu(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [3:0] op,
    input wire carry_in,
    input wire overflow_in,
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
            4'b1000,4'b1100: begin // ADD
                sum = a + b;
                result = sum[7:0];
				carry = sum[8];
            end
            4'b1001: begin // SUB
                b_comp = ~b + 1; // Two's complement of b
                sum = a + b_comp;
                result = sum[7:0];
				carry = sum[8];
            end
            4'b1010,4'b1101: begin
                mul_result = a * b; // MUL
                result = mul_result[7:0];
            end
            4'b1011: result = -a; // NEG
            4'b1110: begin // ADC (Add with Carry)
                sum = a + b + carry_in;
                result = sum[7:0];
				carry = sum[8];
            end
            4'b1111: begin // CMP (compare)
                sum = a -b;
                carry = sum[8];
                overflow = (a[7] == b[7]) && (sum[7] != a[7]);
                zero = (sum[7:0] == 0);
                sign = sum[7];
                result = 8'b0; // CMP does not produce a result
            end
            default: result = 8'b0;
        endcase
    end
endmodule