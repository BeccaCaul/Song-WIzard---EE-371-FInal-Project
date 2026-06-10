// image_display.sv
// Reads from a ROM, overrides a rectangular region when trigger is high.
module get_image
    #(parameter WIDTH  = 640,
      parameter HEIGHT = 480,
      // Rectangle to override (in image pixels)
      parameter RECT_X0 = 100,
      parameter RECT_Y0 = 100,
      parameter RECT_X1 = 200,   // exclusive
      parameter RECT_Y1 = 200,   // exclusive
      // Color to paint when triggered
      parameter [7:0] RECT_R = 8'hFF,
      parameter [7:0] RECT_G = 8'hFF,
      parameter [7:0] RECT_B = 8'hFF)
    (input  logic        CLOCK_50,
     input  logic        reset,
     input  logic        trigger,   // when high, paint rectangle

     // VGA outputs
     output logic [7:0]  VGA_R, VGA_G, VGA_B,
     output logic        VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
    logic [9:0] x;
    logic [8:0] y;
    logic [7:0] r, g, b;

    video_driver #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) vd ( .CLOCK_50, .reset, .x, .y,
        .r, .g, .b, .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, 
		  .VGA_VS);

    logic [18:0] rom_addr;
    logic [23:0] rom_data;

    logic [9:0] x_next;
    logic [8:0] y_next;

    always_ff @(posedge vd.CLOCK_25) begin  
        x_next <= x;
        y_next <= y;
    end

    assign rom_addr = y_next * WIDTH + x_next;

    image_rom #(.WIDTH(WIDTH), .HEIGHT(HEIGHT), .MIF_FILE()) rom ( .clk  (vd.CLOCK_25),
        .addr (rom_addr), .data (rom_data));

    logic in_rect;
    assign in_rect = (x >= RECT_X0) && (x < RECT_X1) &&
                     (y >= RECT_Y0) && (y < RECT_Y1);

    always_comb begin
        if (trigger && in_rect) begin
            r = RECT_R;
            g = RECT_G;
            b = RECT_B;
        end else begin
            r = rom_data[23:16];
            g = rom_data[15: 8];
            b = rom_data[ 7: 0];
        end
    end

endmodule