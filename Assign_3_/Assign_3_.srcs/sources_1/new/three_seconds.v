`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2022 02:51:28 PM
// Design Name: 
// Module Name: three_seconds
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

module three_seconds(
    input basys_clock,
    output reg three_s = 0,
    output reg finish_wait = 0,
    input [15:0]switch
    );
    reg [50:0]count = 0;
     always @ (posedge basys_clock) // inside this blcok, it is sequrntially, from begin to end                  
    begin                                                                                            
                                                                                                     
 //count <= (count == 50'd149999999) ? 0 : count + 1;  //set the period to 0.36s                  
 if(switch[15] == 1)
 begin   
 if (count >= 50'd149999999)
 begin
 finish_wait <= 1;
 end
 else
 begin
 count <= count + 1;
 end
    end

 else
    begin
    finish_wait <= 0;
    count <= 0;
    end
    end
endmodule