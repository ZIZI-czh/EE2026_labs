`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 10:15:23 PM
// Design Name: 
// Module Name: blink_title
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


module blink_title(input basys_clock, output reg check = 0, input [15:0]sw);

    reg [31:0] count = 0;
    wire [30:0]clk1;
    clock_divider clock_1 (basys_clock, 49999999, clk1);
    always @ (posedge clk1)
    begin
    if(sw[14] == 0)
        check <= !check;
        else
        check <= check;
    end

endmodule
