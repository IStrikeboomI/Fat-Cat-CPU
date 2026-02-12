module data_memory_gpio#(parameter CLOCK_INCREMENT_DELAY = 1000;)(
    input wire clk,
    input wire rst,

    input wire mem_read,
    input wire mem_write,
    input wire [7:0] address,
    input wire [15:0] write_data,
    output reg [15:0] read_data,

    //0xF4 - 0xF7 GPIO DIR, if 1 then output, if 0 then input   
    //0xF8 - 0xFB GPIO OUT
    //0xFC - 0xFF GPIO IN
    //gpio 0 is button S2, 1 is DONE LED, gpio 3 is usb_dp, 4 is usb_dn, 5,6,7 are L4,G2,J4
    // 8 - 15 is PMOD1 (closest to usb c port), 16 - 23 is PMOD2, 24 - 31 is PMOD3 (furthest from usb c port)
    inout wire [31:0] gpio;

);
     // RAM
    reg [7:0] ram [0:255];

    // GPIO
    reg [31:0] gpio_dir;
    reg [31:0] gpio_out;
    wire [31:0] gpio_in;

    // Timer
    reg [31:0] timer;

    //tri state buffer
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin
            assign gpio[i]   = gpio_dir[i] ? gpio_out[i] : 1'bz;
            assign gpio_in[i] = gpio[i];
        end
    endgenerate

    // Increment clock every CLOCK_INCREMENT_DELAY cycles
    reg [15:0] prescaler;
    always @(posedge clk) begin
        prescaler <= prescaler + 1;
        if (prescaler == CLOCK_INCREMENT_DELAY) begin
            prescaler <= 0;
            timer <= timer + 1;
        end
    end

    // WRITE logic
    always @(posedge clk) begin
        if (rst) begin
            gpio_dir <= 32'b0;
            gpio_out <= 32'b0;
        end 
        else if (mem_write) begin
            case (address)
                // TIMER reset
                8'hF0: timer[7:0]   <= write_data[7:0];
                8'hF1: timer[15:8]  <= write_data[7:0];
                8'hF2: timer[23:16] <= write_data[7:0];
                8'hF3: timer[31:24] <= write_data[7:0];

                // GPIO DIR
                8'hF4: gpio_dir[7:0]   <= write_data[7:0];
                8'hF5: gpio_dir[15:8]  <= write_data[7:0];
                8'hF6: gpio_dir[23:16] <= write_data[7:0];
                8'hF7: gpio_dir[31:24] <= write_data[7:0];

                // GPIO OUT
                8'hF8: gpio_out[7:0]   <= write_data[7:0];
                8'hF9: gpio_out[15:8]  <= write_data[7:0];
                8'hFA: gpio_out[23:16] <= write_data[7:0];
                8'hFB: gpio_out[31:24] <= write_data[7:0];

                // RAM
                default: ram[address] <= write_data[7:0];
            endcase
        end
    end

    // READ logic
    always @(*) begin
        if (mem_read) begin
            case (address)
                // TIMER
                8'hF0: read_data = {8'b0, timer[7:0]};
                8'hF1: read_data = {8'b0, timer[15:8]};
                8'hF2: read_data = {8'b0, timer[23:16]};
                8'hF3: read_data = {8'b0, timer[31:24]};

                // GPIO DIR
                8'hF4: read_data = {8'b0, gpio_dir[7:0]};
                8'hF5: read_data = {8'b0, gpio_dir[15:8]};
                8'hF6: read_data = {8'b0, gpio_dir[23:16]};
                8'hF7: read_data = {8'b0, gpio_dir[31:24]};

                // GPIO OUT
                8'hF8: read_data = {8'b0, gpio_out[7:0]};
                8'hF9: read_data = {8'b0, gpio_out[15:8]};
                8'hFA: read_data = {8'b0, gpio_out[23:16]};
                8'hFB: read_data = {8'b0, gpio_out[31:24]};

                // GPIO IN
                8'hFC: read_data = {8'b0, gpio_in[7:0]};
                8'hFD: read_data = {8'b0, gpio_in[15:8]};
                8'hFE: read_data = {8'b0, gpio_in[23:16]};
                8'hFF: read_data = {8'b0, gpio_in[31:24]};

                // RAM
                default: read_data = {8'b0, ram[address]};
            endcase
        end
        else begin
            read_data = 16'b0;
        end
    end

endmodule