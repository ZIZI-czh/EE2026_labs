`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 10:26:25 AM
// Design Name: 
// Module Name: D_FF
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


module D_FF(input clk, input D, output reg Q, output reg Qbar );

always @(posedge clk)
begin
Q <= D;
Qbar <= !Q;
end
endmodule
