// image_rom.sv
// custom single-port ROM initialized from a MIF file.

module background_rom
    #(parameter WIDTH = 640, parameter HEIGHT = 480,
      parameter MIF_FILE = "song_wizard_wip.mif")
    (input  logic        clk,
     input  logic [18:0] addr,   // log2(640*480) = 19 bits
     output logic [23:0] data);  // {R, G, B}

    logic [23:0] mem [0 : WIDTH*HEIGHT - 1];

    initial $readmemh(MIF_FILE, mem);  // use hex MIF/MEM format

    always_ff @(posedge clk)
        data <= mem[addr];

endmodule