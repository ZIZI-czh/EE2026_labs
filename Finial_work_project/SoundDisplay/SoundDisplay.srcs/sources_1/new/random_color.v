`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 07:15:59 PM
// Design Name: 
// Module Name: random_color
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

module random_clor(input clock, reset, output reg [3:0] Q = 4'b0000);
    
    always @ (posedge clock, posedge reset)
    begin
        if (reset) Q <= 0;
        else begin
            Q[3] <= Q[2];
            Q[2] <= Q[1];
            Q[1] <= Q[0];
            Q[0] <= ~(Q[2] ^ Q[3]);
        end
    end

endmodule
