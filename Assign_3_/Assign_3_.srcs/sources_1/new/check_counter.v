`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2022 03:22:27 PM
// Design Name: 
// Module Name: check_counter
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


module check_counter(
    output reg [13:0]my_sequence = 0,
    input basys_clock
    );
    wire my_clock;
    create_diff_frequency(basys_clock, my_clock);
    
                                                                                 
     always @ (posedge my_clock)
     begin
     if(my_sequence <= 14)
     begin
     my_sequence = my_sequence + 1;
     end
    
    end
endmodule
