`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2022 02:48:08 PM
// Design Name: 
// Module Name: simulation_bits
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


module simulation_bits();
    

    
    reg [6:0]sim_A;
    reg [6:0]sim_B;
    reg pb_sim;
    wire [6:0]S_sim;
    wire [3:0]an_sim;
    wire [7:0]seg_sim;
    wire [1:0]T_sim;

    
  
   seven_bits_adder test_seven_bits(.A(sim_A), .B(sim_B), .button(pb_sim),.S(S_sim),.anode(an_sim), .seg(seg_sim), .my_led(T_sim));
    
    initial begin
    sim_A = 7'b0000001; sim_B = 7'b0000000; pb_sim = 1'b0; #10;
    sim_A = 7'b0000011; sim_B = 7'b0000001; pb_sim = 1'b0; #10;
    sim_A = 7'b0000100; sim_B = 7'b0000010; pb_sim = 1'b0; #10;
    sim_A = 7'b0000101; sim_B = 7'b0001000; pb_sim = 1'b1; #10;
    sim_A = 7'b0000110; sim_B = 7'b0000010; pb_sim = 1'b1; #10;
    sim_A = 7'b0000111; sim_B = 7'b0000010; pb_sim = 1'b1; #10;
    
    end
    
endmodule
