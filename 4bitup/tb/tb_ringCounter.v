`timescale 1ns / 1ps
module tb_ringCounter;
   reg clk, clr;
   wire [11:0] t;

   ringCounter UUT(clk,clr,t);
 
   always #50 clk=~clk;
   initial begin
       clk=0;
       clr=0;
   end
endmodule
