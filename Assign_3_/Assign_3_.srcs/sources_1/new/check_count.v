`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2022 04:44:03 PM
// Design Name: 
// Module Name: check_count_module
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


module check_count_module(
 
    output reg [2:0]count = 0,
    input basys_clock,
     input [15:0]switch
    );
    wire my_clock;
     reg add;
    select_switch f1(switch,basys_clock, my_clock);
     //assign my_clock = ((switch[0] == 1) ? my_clock_1 : (switch[1] == 1 && switich[0] == 0) ? my_clcok_2 : (my_switch[2] == 1) ? my_clcok_3);                                                                           
     always @ (posedge my_clock)
     begin
     if(count < 3)
     begin
     count <= count + 1;
     end
    else
    begin
 
  
   count <= 0;
  
    end
    end
endmodule
