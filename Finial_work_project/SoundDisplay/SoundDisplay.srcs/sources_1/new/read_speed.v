`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 03:41:36 PM
// Design Name: 
// Module Name: read_speed
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

module read_speed(input CLK100MHZ, input clk6p25, output reg [50:0]count_speed = 0, input [15:0]sw,  input [4:0]num, input [4:0]count_1, input check_state);
wire [50:0]clk_20, m;
reg [50:0]count = 0;
// [4:0]count_1;
wire [50:0]clk10;
always @(posedge CLK100MHZ)
begin

if(sw[2] == 1)
count <= 49999999; //1s
else 
count <= 99999999;//2s

end

//  clock_divider clock_10 ((CLK100MHZ), (4999999), (clk10));

 increase_speed_clk cloc (.basys_clock(CLK100MHZ), .m(count), .new_clock(clk_20), .sw(sw));
//if()
 //change_image R(clk10, clk10, btnR,  btnL, count_1);   

always @(posedge clk_20)
begin
if(check_state == 1)
begin
if(count_1 == num)
begin
if(count_speed < 9 )
count_speed <= count_speed + 1;
else 
count_speed <= 8;
end
end else
count_speed <= 0;
end
endmodule

