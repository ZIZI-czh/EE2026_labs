`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2022 05:51:28 PM
// Design Name: 
// Module Name: select_task
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


module select_task(input basys_clock, output reg [1:0]task_id, output reg signal);
wire my_clock_5;
wire anode;
wire seg;
reg push_button;
wire check_state;
wire state;
create_tenk_hz e(basys_clock, my_clock_5);
//turn_on_leds e2(basys_clock, anode, seg);
//password(push_button,basys_clock, seg,anode, state, check_state);

always @ (posedge my_clock_5) // inside this blcok, it is sequrntially, from begin to end
begin
if(check_state == 1)
begin
signal <= 1;
end

end
endmodule
