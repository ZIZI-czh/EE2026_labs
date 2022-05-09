`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2022 03:54:46 PM
// Design Name: 
// Module Name: my_2_to_1_mux
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


module my_2_to_1_mux(input [6:1]AR, input [6:0]DR, input pb, output [6:0]Z);


//assign AR[0] = 0;
assign Z = (pb == 1) ? AR : DR;

endmodule
