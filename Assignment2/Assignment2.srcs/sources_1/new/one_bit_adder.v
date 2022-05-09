`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2022 07:20:17 PM
// Design Name: 
// Module Name: one_bit_adder
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


module one_bit_adder( input A, B, CIN,output S, COUT);

assign S = A ^ B ^CIN;
//assign OUTPUT_R = A ^ B ^CIN;
//assign OUTPUT_D = A ^ B ^CIN;

assign COUT = (A & B) | (CIN & (A^B));


endmodule
