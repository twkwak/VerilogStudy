`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/24 18:31:19
// Design Name: 
// Module Name: reg4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reg4(
    output [3:0] data_out,
    input [3:0] data_in,
    input inen,
    input oen,
    input clk,
    input clr 
    );
    
    reg [3:0] st;
    always @(posedge clk, posedge clr) begin
        if(clr) st=4'b0;
        else if(inen) st=data_in;
        else st=st;
    end
    assign data_out=(oen)? st: 4'bz;
endmodule
