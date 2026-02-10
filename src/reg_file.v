//8 registers (R0-R7) of 16 bits each
//R0 is always 0
//R7 is reserved for JAL and RET but can be used
module reg_file(
    input wire clk,
    input wire rst,

    input wire we,
    input wire [2:0] wa,
    input wire [15:0] wd,

    input wire [2:0] ra1,
    output wire [15:0] rd1,

    input wire [2:0] ra2,
    output wire [15:0] rd2
);
    // 8 registers of 16 bits each
    reg [15:0] registers [0:7];

    // Write operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] <= 16'b0;
            end
        end else if (we && (wa != 3'b0)) begin // Prevent writing to register 0 (which is always 0)
            registers[wa] <= wd;
        end
    end

    // Read operations
    assign rd1 = (ra1 == 3'd0) ? 16'h0000 : registers[ra1];
    assign rd2 = (ra2 == 3'd0) ? 16'h0000 : registers[ra2];
endmodule