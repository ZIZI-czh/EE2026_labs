`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2022 03:47:29 PM
// Design Name: 
// Module Name: main
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


module main(input basys_clock,[15:0]sw, input [4:0]push_button, output  [7:0]seg,output  [3:0]anode,output [15:0]led);
wire state_check;
wire [5:0]state;


password l1(push_button,basys_clock, seg, anode, state, state_check, sw, led);


endmodule
