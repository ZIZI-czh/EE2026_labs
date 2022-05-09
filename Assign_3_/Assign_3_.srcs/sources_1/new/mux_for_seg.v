`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2022 06:04:30 PM
// Design Name: 
// Module Name: mux_for_seg
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


module mux_for_seg(input basys_clock,output reg [3:0]my_anode, output reg [7:0]my_seg);
 wire led;
 wire check_state;
 wire state;
 wire my_clock_5;
 reg push_button;
 wire task_id;
 wire signal;
 wire seg1;
 wire anode1;
 wire anode;
 wire seg;
 
    turn_on_leds w1(basys_clock, anode1, seg1);
    password w2(push_button,basys_clock, seg,anode, state, check_state);
    create_tenk_hz w3(basys_clock, my_clock_5);
    select_task w4(basys_clock, task_id, signal);
  
    always @ (posedge my_clock_5)
    begin
    if(signal == 1)
    begin
     my_seg = seg1;
       my_anode = anode1;
    end
    else
    begin
    my_seg = seg;
   my_anode = anode;
    end
    end
endmodule
