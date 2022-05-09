`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2022 11:15:47 PM
// Design Name: 
// Module Name: assign_1_module
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


module assign_1_module(
    input SW0,
    input SW1,
    input SW2,
    input SW3,
    input SW4,
    input SW5,
    input SW6,
    input SW7,
    input SW8,
    input SW9,
    output LED0,
    output LED1,
    output LED2,
    output LED3,
    output LED4,
    output LED5,
    output LED6,
    output LED7,
    output LED8,
    output LED9,
    output LED15,
    output seg0,
    output seg1,
    output seg2,
    output seg3,
    output seg4,
    output seg5,
    output seg6,
   
    output anode1,
    output anode2,
    output anode3,
    output anode4       
    );
    assign LED0 = SW0;
    assign LED1 = SW1;
    assign LED2 = SW2;
    assign LED3 = SW3;
    assign LED4 = SW4;
    assign LED5 = SW5;
    assign LED6 = SW6;
    assign LED7 = SW7;
    assign LED8 = SW8;
    assign LED9 = SW9;
    assign LED15 = SW0 & SW1 & SW4 & SW5 & SW9 & (~SW2) & (~SW3)& (~SW6)& (~SW7)& (~SW8);
    assign anode1 =  SW0 & SW1 & SW4 & SW5 & SW9 & (~SW2) & (~SW3)& (~SW6)& (~SW7)& (~SW8);
    assign anode4 =  SW0 & SW1 & SW4 & SW5 & SW9 & (~SW2) & (~SW3)& (~SW6)& (~SW7)& (~SW8) & ~( SW0 & SW1 & SW4 & SW5 & SW9 & (~SW2) & (~SW3)& (~SW6)& (~SW7)& (~SW8));
    assign seg0 =   SW0 & SW1 & SW4 & SW5 & SW9 & (~SW2) & (~SW3)& (~SW6)& (~SW7)& (~SW8);
    assign seg1 = ((SW0 & SW1 & SW4 & SW5 & SW9 & LED15) & ~(SW0 & SW1 & SW4 & SW5 & SW9));
    assign seg2 = (SW0 & SW1 & SW4 & SW5 & SW9 & LED15) & ~(SW0 & SW1 & SW4 & SW5 & SW9);
    assign seg3 = (SW0 & SW1 & SW4 & SW5 & SW9 & LED15) & ~(SW0 & SW1 & SW4 & SW5 & SW9);
    assign seg4 = ~( SW0 & SW1 & SW4 & SW5 & SW9 & (~SW2) & (~SW3)& (~SW6)& (~SW7)& (~SW8));
    
endmodule
