`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2022 02:57:01 PM
// Design Name: 
// Module Name: create_diff_frequency
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


module create_diff_frequency(input basys_clock, output reg my_clock = 0);
reg [50:0]count = 0;
//parameter state0 = 3'd0,state1 =3'd1,state2 = 3'd2;

always @ (posedge basys_clock) // inside this blcok, it is sequrntially, from begin to end
begin

  count <= (count == 50'd17999999) ? 0 : count + 1;  //set the period to 0.36s
  my_clock <= (count == 0) ? ~my_clock : my_clock; //my_clcok must be reg
  
  
 
end
endmodule
