`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2022 08:16:13 PM
// Design Name: 
// Module Name: five_bits_adder
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

module five_bits_adder(input [4:0]A, B, input Carry, output [6:2]S);
wire c_connection0, c_connection1, c_connection2, c_connection3 , grnd_wire;

//assign Carry_out = 0;

one_bit_adder fb0 (.A(A[0]), .B(B[0]), .CIN(Carry), .S(S[2]), .COUT(c_connection0));
one_bit_adder fb1 (.A(A[1]), .B(B[1]), .CIN(c_connection0), .S(S[3]), .COUT(c_connection1));
one_bit_adder fb2 (.A(A[2]), .B(B[2]), .CIN(c_connection1), .S(S[4]), .COUT(c_connection2));
one_bit_adder fb3 (.A(A[3]), .B(B[3]), .CIN(c_connection2), .S(S[5]), .COUT(c_connection3));
one_bit_adder fb4 (.A(A[4]), .B(B[4]), .CIN(c_connection3), .S(S[6]), .COUT(grnd_wire));




endmodule
