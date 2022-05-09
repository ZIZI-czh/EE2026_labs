`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2022 05:33:14 PM
// Design Name: 
// Module Name: turn_on_leds
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


module turn_on_leds(input basys_clock, output reg anode, output reg [7:0]seg);

wire count;
wire my_clock_5;
check_count_module f1(count,basys_clock);
create_tenk_hz fe5(basys_clock, my_clock_5);

always @ (posedge basys_clock)
begin
case(count)
2'd1:
begin
anode <= 4'b1110;
seg <= 8'b11100011;  //pushbutton[0] up
end

2'd2:
begin
anode <= 4'b1101;
seg <= 8'b11001111;//pushbutton[1] left
end

2'd3:
begin;
//anode <= 4'b1101;
anode <= 4'b1011;
seg <= 8'b11100011;  //pushbutton[0] up

end
endcase
end
endmodule
