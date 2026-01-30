`timescale 1ns / 1ps
module tb_reg8;
// Inputs
   reg [7:0] data_in;
   reg inen;
   reg oen;
   reg clk;
   reg clr;

// Output
   wire [7:0] data_out;

// Instantiate the UUT
    reg8 UUT (
		.data_in(data_in), 
		.data_out(data_out), 
		.inen(inen), 
		.oen(oen), 
		.clk(clk), 
		.clr(clr)
   );

// Initialize Inputs
  always #50 clk=~clk;
   initial begin
	data_in = 8'h48;
	inen = 0;
	oen = 0;
	clk = 0;
	clr = 1;
	#100; 	clr = 0;
	#200; 	inen = 1;
	#100; 	oen = 1;
	#100;	oen = 0;
	#100;	inen = 0; oen = 1;
	#100;	clr = 1;
	#100;	clr = 0;
	#100;
	   end
endmodule
