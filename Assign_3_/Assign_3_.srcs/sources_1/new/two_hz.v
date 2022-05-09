`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2022 02:46:40 PM
// Design Name: 
// Module Name: two_hz
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


module two_hz( input basys_clock,output reg my_clock_4 = 0
    );
     reg [50:0]count = 0;
           always @ (posedge basys_clock) // inside this blcok, it is sequrntially, from begin to end                  
          begin                                                                                                                                                                                                     
         count <= (count == 50'd24999999) ? 0 : count + 1;                               
          my_clock_4 <= (count == 0) ? ~my_clock_4 : my_clock_4; //my_clcok must be reg
          end
endmodule



