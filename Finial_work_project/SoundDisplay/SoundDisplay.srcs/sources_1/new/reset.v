`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 14:04:47
// Design Name: 
// Module Name: reset
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


module reset(clock,bot,reset_sig);
parameter SAMPLE_TIME = 4;
input clock;
input bot;
output reset_sig;

reg [21:0] count_low;
reg [21:0] count_high;

reg reset_sig_reg;

always @(posedge clock)
if(bot ==1'b0)
count_low <= count_low + 1;
else
count_low <= 0;

always @(posedge clock)
if(bot ==1'b1)
count_high <= count_high + 1;
else
count_high <= 0;

always @(posedge clock)
if(count_high == SAMPLE_TIME)
reset_sig_reg <= 1;
else if(count_low == SAMPLE_TIME)
reset_sig_reg <= 0;

assign reset_sig =reset_sig_reg;
endmodule 