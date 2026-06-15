/* Testbench for DE1_SoC
 */
module DE1_SoC_tb ();

    logic        CLOCK_50, CLOCK2_50;
    logic [3:0]  KEY;
    logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [9:0]  LEDR;
    wire  [35:4] V_GPIO;

    // Audio
    logic FPGA_I2C_SCLK;
    wire  FPGA_I2C_SDAT;
    logic AUD_XCK;
    logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
    logic AUD_ADCDAT;
    logic AUD_DACDAT;

    // VGA (declared here to match DUT's output ports)
    logic [7:0]  VGA_R, VGA_G, VGA_B;
    logic        VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;

    DE1_SoC #(.MAX(4)) dut (
        .CLOCK_50,
        .CLOCK2_50,
        .FPGA_I2C_SCLK,
        .FPGA_I2C_SDAT,
        .AUD_XCK,
        .AUD_DACLRCK,
        .AUD_ADCLRCK,
        .AUD_BCLK,
        .AUD_ADCDAT,
        .AUD_DACDAT,
        .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5,
        .LEDR,
        .V_GPIO,
        .KEY,
        .VGA_R, .VGA_G, .VGA_B,
        .VGA_BLANK_N,
        .VGA_CLK,
        .VGA_HS,
        .VGA_SYNC_N,
        .VGA_VS
    );

    parameter PERIOD = 20;

    initial CLOCK_50  = 0;
    always #(PERIOD/2) CLOCK_50  = ~CLOCK_50;

    initial CLOCK2_50 = 0;
    always #(PERIOD/2) CLOCK2_50 = ~CLOCK2_50;

    initial begin
        AUD_DACLRCK = 0;
        AUD_ADCLRCK = 0;
        AUD_BCLK    = 0;
        AUD_ADCDAT  = 0;
    end

    logic gpio28_drive;
    assign V_GPIO[28] = gpio28_drive;
		
		//TESTS ----------------------
    initial begin

        KEY          = 4'hF;
        gpio28_drive = 1'b0;

        // ---- TEST 1: test reset
        KEY[3] = 0;
        @(posedge CLOCK_50);
        $display("T1 reset asserted.   T=%0t | LEDR=%b | HEX0=%h (expect 7F)", $time, LEDR, HEX0);

        repeat(4) @(posedge CLOCK_50);

        // ---- TEST 2: release reset ---- //
        KEY[3] = 1;
        @(posedge CLOCK_50);
        $display("T2 reset released.   T=%0t | LEDR=%b", $time, LEDR);

        repeat(4) @(posedge CLOCK_50);

        // ---- TEST 3: HEX segments 
        $display("T3 HEX blank check.  T=%0t | HEX0=%h HEX1=%h HEX2=%h HEX3=%h HEX4=%h HEX5=%h (all expect 7F)",
                 $time, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

        repeat(4) @(posedge CLOCK_50);

        // ---- TEST 4: GPIO outputs
        $display("T4 GPIO driver outputs. T=%0t | (GPIO27)=%b  (GPIO26)=%b",
                 $time, V_GPIO[27], V_GPIO[26]);

        repeat(4) @(posedge CLOCK_50);

        // ---- TEST 5: data being passed through
        gpio28_drive = 1'b0; @(posedge CLOCK_50);
        $display("T5a GPIO28=0 -> LEDR[2]=%b (expect 0)", $time, LEDR[2]);
        gpio28_drive = 1'b1; @(posedge CLOCK_50);
        $display("T5b GPIO28=1 -> LEDR[2]=%b (expect 1)", $time, LEDR[2]);
        gpio28_drive = 1'b0; @(posedge CLOCK_50);

        repeat(4) @(posedge CLOCK_50);

        // ---- TEST 6: VGA outputs
        $display("T6 VGA outputs.      T=%0t | CLK=%b HS=%b VS=%b BLANK_N=%b",
                 $time, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N);

        repeat(4) @(posedge CLOCK_50);

        // ---- TEST 7: LEDR 
        $display("T7 LEDR note bits.   T=%0t | LEDR[9:3]=%b (expect 0000000)",
                 $time, LEDR[9:3]);

        repeat(4) @(posedge CLOCK_50);

        // ---- TEST 8: status bits full/all_done 0 at startup 
        $display("T8 LEDR status.      T=%0t | full(LEDR1)=%b  all_done(LEDR0)=%b (expect 0 0)",
                 $time, LEDR[1], LEDR[0]);

        repeat(4) @(posedge CLOCK_50);

        // ---- TEST 9: reset 
        KEY[3] = 0; @(posedge CLOCK_50);
        $display("T9 reset .  T=%0t | LEDR=%b", $time, LEDR);
        KEY[3] = 1; @(posedge CLOCK_50);
        $display("T9 reset released.   T=%0t | LEDR=%b", $time, LEDR);

        repeat(8) @(posedge CLOCK_50);

        $display("done");
        $stop;

    end

endmodule