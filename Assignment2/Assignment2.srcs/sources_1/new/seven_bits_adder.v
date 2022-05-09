`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2022 08:55:54 PM
// Design Name: 
// Module Name: seven_bits_adder
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


module seven_bits_adder(input [6:0]A, B, input button,output [6:0]S, output [3:0]anode, output [7:0]seg, output[1:0]my_led);
wire C0;
wire [6:0]AR;
wire [6:0]DR;
wire [6:0]S_out; 

assign anode = 4'b1110;
assign seg = 8'b11101010;




two_bits_adder fc0 (.A(A[1:0]), .B(B[1:0]), .S(S_out[1:0]), .Carry_out1(C0));
five_bits_adder fc1 (.A(A[6:2]), .B(B[6:2]), .Carry(C0), .S(S_out[6:2]));

// COUT = 0;

assign my_led[0] = button;
assign my_led[1] = button;

assign AR[0] = 0;
assign AR[6:1] = S_out[5:0];   //assign S1 to AR
assign DR[6:0]= S_out[6:0]; //assign S1 to DR


 assign S = (button == 1) ? AR : DR; //Assign either S1 to AR OR DR
///assign S1 = DR^(~button) + AR^button;

endmodule
