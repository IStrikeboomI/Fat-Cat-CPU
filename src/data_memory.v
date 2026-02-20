module data_memory(
    input wire clk,
    input wire rst,

    input wire mem_read,
    input wire mem_write,
    input wire [7:0] address,
    input wire [7:0] write_data,
    output reg [7:0] read_data
);
     // RAM
    reg [7:0] ram [0:255];

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            ram[i] = 8'b0;
        end
    end

    // WRITE logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize RAM to zero on reset
            for (i = 0; i < 256; i = i + 1) begin
                ram[i] <= 8'b0;
            end
            read_data <= 8'b0;
        end else if (mem_write) begin
            ram[address] <= write_data[7:0];
        end
    
    end

    // READ logic
    always @(*) begin
        if (mem_read) begin
            read_data = ram[address];
        end
        else begin
            read_data = 8'b0;
        end
    end

endmodule