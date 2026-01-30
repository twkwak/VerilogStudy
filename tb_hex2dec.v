`timescale 1ns / 1ps
module tb_hex2dec;
// Inputs
   reg [7:0] h;
   integer i;
// Output
   wire [3:0] dec_h;
   wire [3:0] dec_l;

// Instantiate the UUT
   hex2dec UUT (
		.h(h), 
		.dec_h(dec_h), 
		.dec_l(dec_l)
   );
   
// Initialize Inputs
  initial begin
	h = 0;
	for(i=0;i<82;i=i+1)
	begin
          h = i; #100;
	end
   end
endmodule
