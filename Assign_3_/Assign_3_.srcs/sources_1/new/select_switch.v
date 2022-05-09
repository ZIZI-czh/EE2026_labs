`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2022 05:16:02 PM
// Design Name: 
// Module Name: select_switch
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


module select_switch(
   input [15:0]switch,
    input basys_clock,
   output reg my_clock
    );
  wire my_clock_1;
   wire my_clock_2;
   wire my_clock_3;
 //  reg my_clock;
    two_hz one(basys_clock, my_clock_1);
    twenty_hz two(basys_clock, my_clock_2);
    two_hu_hz thre(basys_clock, my_clock_3);
    
    always @ (posedge basys_clock)
    begin
    if(switch[0] == 1 && switch[1] == 0 && switch[2] == 0)
    begin
    my_clock <= my_clock_1;
    end
   else if(switch[1] == 1 && switch[2] == 0)
        begin
        my_clock <= my_clock_2;
        end
     else if(switch[2] == 1)
            begin
            my_clock <= my_clock_3;
            end
    end
     
    //assign my_clock = ((switch[0] == 1) ? my_clock_1 : (switch[1] == 1 && switich[0] == 0) ? my_clcok_2 : (my_switch[2] == 1) ? my_clcok_3);            
endmodule
