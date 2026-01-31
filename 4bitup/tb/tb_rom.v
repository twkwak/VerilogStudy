`timescale 1ns / 1ps
module tb_rom;
    reg [7:0] addr;
    reg rom_en;
    wire [7:0] data; 
    
   integer i;
   rom UUT(.addr(addr), .rom_en(rom_en), .data(data));
   initial begin
        rom_en=0;
        for(i=0;i<256;i=i+1) begin
          #300000; addr=i;
          #30000; $display("rom[%d] = %d\n",i,data);
        end
   end
endmodule
