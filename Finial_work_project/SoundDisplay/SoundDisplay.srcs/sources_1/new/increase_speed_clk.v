`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 09:59:26 AM
// Design Name: 
// Module Name: increase_speed_clk
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


module increase_speed_clk(input basys_clock, input [31:0] m, output reg new_clock = 0, input [15:0]sw);

    reg [31:0] count = 0;
    
    always @ (posedge basys_clock)
    begin
     if(sw[2] == 1 && count > m)
     begin count <= m;end
     else  if(sw[2] == 1 && count < m)
     count <= count + 1;
     else if(sw[2] == 0 && count > m)
    begin count <= m; end
    else if (sw[2] == 0 && count < m)
    begin count <= count + 1;end
    
    
     if(count == m)
     count <= 0;
     
       // count <= (count == m) ? 0 : count + 1;
        new_clock <= (count == 0) ? ~new_clock : new_clock;
    end
endmodule