`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 14:06:16
// Design Name: 
// Module Name: clk_6p25m
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


module clk6p25m(clock,reset,clk
    );
    input wire clock;
    input wire reset;
    output wire clk;
    
    localparam factor=16'd16;
    reg [15:0] counter=16'd0;
    reg clktmp=1'b0;
    
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
        clktmp<=1'b0;
    else if(counter==factor)
        clktmp<=!clktmp;
    else
        clktmp<=clktmp;
    end
    
    assign clk=clktmp;
endmodule
