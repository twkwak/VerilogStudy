module prog_module(clk, rom_en, addr, data);
    input clk, rom_en;
    input [7:0] addr;
    output [7:0] data;
    
    prog_rom u0 (.clka(clk), .ena(rom_en), .addra(addr), .douta(data));
    
endmodule
