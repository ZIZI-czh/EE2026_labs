`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2022 03:16:43 PM
// Design Name: 
// Module Name: create_ten_hz
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


module create_ten_hz(
    input basys_clock,
    output reg my_clock_3 = 0
    );
    
     reg [50:0]count = 0;
        always @ (posedge basys_clock) // inside this blcok, it is sequrntially, from begin to end                  
       begin                                                                                            
                                                                                                        
      count <= (count == 50'd4999999) ? 0 : count + 1;                               
       my_clock_3 <= (count == 0) ? ~my_clock_3 : my_clock_3; //my_clcok must be reg
       end
endmodule
