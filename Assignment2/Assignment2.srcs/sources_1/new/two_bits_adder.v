`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2022 07:21:23 PM
// Design Name: 
// Module Name: two_bits_adder
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


module two_bits_adder(input [1:0]A, B, output Carry_out1, output [1:0]S);
wire c_connection;

one_bit_adder fa0 (.A(A[0]), .B(B[0]), .CIN(0), .S(S[0]), .COUT(c_connection));
one_bit_adder fa1 (.A(A[1]), .B(B[1]), .CIN(c_connection), .S(S[1]), .COUT(Carry_out1));

endmodule
