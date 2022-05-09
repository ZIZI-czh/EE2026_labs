`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 14:11:10
// Design Name: 
// Module Name: clk_voice
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

module clk_voice(clock,reset,clk20k
    );
    input wire clock;
    input wire reset;
    output wire clk20k;
    
    localparam factor=16'd02499;
    reg [15:0] counter=16'd0;
    reg clk20k_tmp=1'b0;
    
    always@(posedge clock)begin
    if(reset)
        counter<=16'd0;
    else begin
        if(counter==factor)
        counter<=16'd0;
        else
        counter<=counter+1'b1;
    end
end
always@(posedge clock)begin
    if(reset)
        clk20k_tmp<=1'b0;
    else if(counter==factor)
        clk20k_tmp<=!clk20k_tmp;
    else
        clk20k_tmp<=clk20k_tmp;
    end
    
    assign clk20k=clk20k_tmp;
endmodule
