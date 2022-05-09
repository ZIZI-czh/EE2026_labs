`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2022 02:27:43 PM
// Design Name: 
// Module Name: Main_menu
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

module main_menu(
    input [3:0] state,
    input CLK100MHZ,
    input [15:0] sw,
    input btnD, btnU, btnC,
    output [7:0] JC,
    output reg [3:0] state_out = 0
    );

    
    wire clk6p25m, clk10;
    
    clock_divider clock_6p25m (.basys_clock(CLK100MHZ), .m(7), .new_clock(clk6p25m));
    clock_divider clock_10 (.basys_clock(CLK100MHZ), .m(4999999), .new_clock(clk10));


    reg [15:0] oled_data = 0;
    wire frame_begin, sending_pixels, sample_pixel, teststate;
    wire [12:0] pixel_index;
    Oled_Display oled(
        .clk(clk6p25m), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),
        .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
        .pmoden(JC[7]),.teststate(teststate)
    );
    
    wire [12:0] x, y;
    wire down, up, enter;
    
    find_row_col row_col (pixel_index, y, x);
    single_pulse go_down (.clock(clk10),.BTNC(btnD),.OUT(down));
    single_pulse go_up (.clock(clk10),.BTNC(btnU),.OUT(up));
    single_pulse enter_0 (.clock(clk10),.BTNC(btnC),.OUT(enter));

    
    wire student_a, student_b, teamwork, schoolwork;
    assign student_a = ((x == 29 && y == 15) || (x == 30 && y == 15) || (x == 31 && y == 15) || (x == 32 && y == 15) || (x == 29 && y == 16) || (x == 29 && y == 17) || (x == 30 && y == 17) || (x == 31 && y == 17) || (x == 32 && y == 17) || (x == 32 && y == 18) || (x == 29 && y == 19) || (x == 30 && y == 19) || (x == 31 && y == 19) || (x == 32 && y == 19) || (x == 34 && y == 15) || (x == 35 && y == 15) || (x == 36 && y == 15) || (x == 35 && y == 16) || (x == 35 && y == 17) || (x == 35 && y == 18) || (x == 35 && y == 19) || (x == 38 && y == 15) || (x == 41 && y == 15) || (x == 38 && y == 16) || (x == 41 && y == 16) || (x == 38 && y == 17) || (x == 41 && y == 17) || (x == 38 && y == 18) || (x == 41 && y == 18) || (x == 39 && y == 19) || (x == 40 && y == 19) || (x == 43 && y == 15) || (x == 44 && y == 15) || (x == 45 && y == 15) || (x == 43 && y == 16) || (x == 46 && y == 16) || (x == 43 && y == 17) || (x == 46 && y == 17) || (x == 43 && y == 18) || (x == 46 && y == 18) || (x == 43 && y == 19) || (x == 44 && y == 19) || (x == 45 && y == 19) || (x == 48 && y == 15) || (x == 49 && y == 15) || (x == 50 && y == 15) || (x == 51 && y == 15) || (x == 48 && y == 16) || (x == 48 && y == 17) || (x == 49 && y == 17) || (x == 50 && y == 17) || (x == 51 && y == 17) || (x == 48 && y == 18) || (x == 48 && y == 19) || (x == 49 && y == 19) || (x == 50 && y == 19) || (x == 51 && y == 19) || (x == 53 && y == 15) || (x == 56 && y == 15) || (x == 53 && y == 16) || (x == 54 && y == 16) || (x == 56 && y == 16) || (x == 53 && y == 17) || (x == 55 && y == 17) || (x == 56 && y == 17) || (x == 53 && y == 18) || (x == 56 && y == 18) || (x == 53 && y == 19) || (x == 56 && y == 19) || (x == 58 && y == 15) || (x == 59 && y == 15) || (x == 60 && y == 15) || (x == 59 && y == 16) || (x == 59 && y == 17) || (x == 59 && y == 18) || (x == 59 && y == 19) || (x == 64 && y == 15) || (x == 65 && y == 15) || (x == 63 && y == 16) || (x == 66 && y == 16) || (x == 63 && y == 17) || (x == 64 && y == 17) || (x == 65 && y == 17) || (x == 66 && y == 17) || (x == 63 && y == 18) || (x == 66 && y == 18) || (x == 63 && y == 19) || (x == 66 && y == 19));
    assign student_b = ((x == 29 && y == 25) || (x == 30 && y == 25) || (x == 31 && y == 25) || (x == 32 && y == 25) || (x == 29 && y == 26) || (x == 29 && y == 27) || (x == 30 && y == 27) || (x == 31 && y == 27) || (x == 32 && y == 27) || (x == 32 && y == 28) || (x == 29 && y == 29) || (x == 30 && y == 29) || (x == 31 && y == 29) || (x == 32 && y == 29) || (x == 34 && y == 25) || (x == 35 && y == 25) || (x == 36 && y == 25) || (x == 35 && y == 26) || (x == 35 && y == 27) || (x == 35 && y == 28) || (x == 35 && y == 29) || (x == 38 && y == 25) || (x == 41 && y == 25) || (x == 38 && y == 26) || (x == 41 && y == 26) || (x == 38 && y == 27) || (x == 41 && y == 27) || (x == 38 && y == 28) || (x == 41 && y == 28) || (x == 39 && y == 29) || (x == 40 && y == 29) || (x == 43 && y == 25) || (x == 44 && y == 25) || (x == 45 && y == 25) || (x == 43 && y == 26) || (x == 46 && y == 26) || (x == 43 && y == 27) || (x == 46 && y == 27) || (x == 43 && y == 28) || (x == 46 && y == 28) || (x == 43 && y == 29) || (x == 44 && y == 29) || (x == 45 && y == 29) || (x == 48 && y == 25) || (x == 49 && y == 25) || (x == 50 && y == 25) || (x == 51 && y == 25) || (x == 48 && y == 26) || (x == 48 && y == 27) || (x == 49 && y == 27) || (x == 50 && y == 27) || (x == 51 && y == 27) || (x == 48 && y == 28) || (x == 48 && y == 29) || (x == 49 && y == 29) || (x == 50 && y == 29) || (x == 51 && y == 29) || (x == 53 && y == 25) || (x == 56 && y == 25) || (x == 53 && y == 26) || (x == 54 && y == 26) || (x == 56 && y == 26) || (x == 53 && y == 27) || (x == 55 && y == 27) || (x == 56 && y == 27) || (x == 53 && y == 28) || (x == 56 && y == 28) || (x == 53 && y == 29) || (x == 56 && y == 29) || (x == 58 && y == 25) || (x == 59 && y == 25) || (x == 60 && y == 25) || (x == 59 && y == 26) || (x == 59 && y == 27) || (x == 59 && y == 28) || (x == 59 && y == 29) || (x == 63 && y == 25) || (x == 64 && y == 25) || (x == 65 && y == 25) || (x == 63 && y == 26) || (x == 66 && y == 26) || (x == 63 && y == 27) || (x == 64 && y == 27) || (x == 65 && y == 27) || (x == 63 && y == 28) || (x == 66 && y == 28) || (x == 63 && y == 29) || (x == 64 && y == 29) || (x == 65 && y == 29));
    assign teamwork =((x == 28 && y == 35) || (x == 29 && y == 35) || (x == 30 && y == 35) || (x == 29 && y == 36) || (x == 29 && y == 37) || (x == 29 && y == 38) || (x == 29 && y == 39) || (x == 32 && y == 35) || (x == 33 && y == 35) || (x == 34 && y == 35) || (x == 35 && y == 35) || (x == 32 && y == 36) || (x == 32 && y == 37) || (x == 33 && y == 37) || (x == 34 && y == 37) || (x == 35 && y == 37) || (x == 32 && y == 38) || (x == 32 && y == 39) || (x == 33 && y == 39) || (x == 34 && y == 39) || (x == 35 && y == 39) || (x == 38 && y == 35) || (x == 39 && y == 35) || (x == 37 && y == 36) || (x == 40 && y == 36) || (x == 37 && y == 37) || (x == 38 && y == 37) || (x == 39 && y == 37) || (x == 40 && y == 37) || (x == 37 && y == 38) || (x == 40 && y == 38) || (x == 37 && y == 39) || (x == 40 && y == 39) || (x == 42 && y == 35) || (x == 46 && y == 35) || (x == 42 && y == 36) || (x == 43 && y == 36) || (x == 45 && y == 36) || (x == 46 && y == 36) || (x == 42 && y == 37) || (x == 44 && y == 37) || (x == 46 && y == 37) || (x == 42 && y == 38) || (x == 46 && y == 38) || (x == 42 && y == 39) || (x == 46 && y == 39) || (x == 48 && y == 35) || (x == 52 && y == 35) || (x == 48 && y == 36) || (x == 52 && y == 36) || (x == 48 && y == 37) || (x == 52 && y == 37) || (x == 48 && y == 38) || (x == 50 && y == 38) || (x == 52 && y == 38) || (x == 49 && y == 39) || (x == 51 && y == 39) || (x == 55 && y == 35) || (x == 56 && y == 35) || (x == 54 && y == 36) || (x == 57 && y == 36) || (x == 54 && y == 37) || (x == 57 && y == 37) || (x == 54 && y == 38) || (x == 57 && y == 38) || (x == 55 && y == 39) || (x == 56 && y == 39) || (x == 59 && y == 35) || (x == 60 && y == 35) || (x == 61 && y == 35) || (x == 59 && y == 36) || (x == 62 && y == 36) || (x == 59 && y == 37) || (x == 60 && y == 37) || (x == 61 && y == 37) || (x == 59 && y == 38) || (x == 61 && y == 38) || (x == 59 && y == 39) || (x == 62 && y == 39) || (x == 64 && y == 35) || (x == 67 && y == 35) || (x == 64 && y == 36) || (x == 66 && y == 36) || (x == 64 && y == 37) || (x == 65 && y == 37) || (x == 64 && y == 38) || (x == 66 && y == 38) || (x == 64 && y == 39) || (x == 67 && y == 39));
    assign schoolwork = ((x == 23 && y == 45) || (x == 24 && y == 45) || (x == 25 && y == 45) || (x == 26 && y == 45) || (x == 23 && y == 46) || (x == 23 && y == 47) || (x == 24 && y == 47) || (x == 25 && y == 47) || (x == 26 && y == 47) || (x == 26 && y == 48) || (x == 23 && y == 49) || (x == 24 && y == 49) || (x == 25 && y == 49) || (x == 26 && y == 49) || (x == 29 && y == 45) || (x == 30 && y == 45) || (x == 28 && y == 46) || (x == 31 && y == 46) || (x == 28 && y == 47) || (x == 28 && y == 48) || (x == 31 && y == 48) || (x == 29 && y == 49) || (x == 30 && y == 49) || (x == 33 && y == 45) || (x == 36 && y == 45) || (x == 33 && y == 46) || (x == 36 && y == 46) || (x == 33 && y == 47) || (x == 34 && y == 47) || (x == 35 && y == 47) || (x == 36 && y == 47) || (x == 33 && y == 48) || (x == 36 && y == 48) || (x == 33 && y == 49) || (x == 36 && y == 49) || (x == 39 && y == 45) || (x == 40 && y == 45) || (x == 38 && y == 46) || (x == 41 && y == 46) || (x == 38 && y == 47) || (x == 41 && y == 47) || (x == 38 && y == 48) || (x == 41 && y == 48) || (x == 39 && y == 49) || (x == 40 && y == 49) || (x == 44 && y == 45) || (x == 45 && y == 45) || (x == 43 && y == 46) || (x == 46 && y == 46) || (x == 43 && y == 47) || (x == 46 && y == 47) || (x == 43 && y == 48) || (x == 46 && y == 48) || (x == 44 && y == 49) || (x == 45 && y == 49) || (x == 48 && y == 45) || (x == 48 && y == 46) || (x == 48 && y == 47) || (x == 48 && y == 48) || (x == 48 && y == 49) || (x == 49 && y == 49) || (x == 50 && y == 49) || (x == 51 && y == 49) || (x == 53 && y == 45) || (x == 57 && y == 45) || (x == 53 && y == 46) || (x == 57 && y == 46) || (x == 53 && y == 47) || (x == 57 && y == 47) || (x == 53 && y == 48) || (x == 55 && y == 48) || (x == 57 && y == 48) || (x == 54 && y == 49) || (x == 56 && y == 49) || (x == 60 && y == 45) || (x == 61 && y == 45) || (x == 59 && y == 46) || (x == 62 && y == 46) || (x == 59 && y == 47) || (x == 62 && y == 47) || (x == 59 && y == 48) || (x == 62 && y == 48) || (x == 60 && y == 49) || (x == 61 && y == 49) || (x == 64 && y == 45) || (x == 65 && y == 45) || (x == 66 && y == 45) || (x == 64 && y == 46) || (x == 67 && y == 46) || (x == 64 && y == 47) || (x == 65 && y == 47) || (x == 66 && y == 47) || (x == 64 && y == 48) || (x == 66 && y == 48) || (x == 64 && y == 49) || (x == 67 && y == 49) || (x == 69 && y == 45) || (x == 72 && y == 45) || (x == 69 && y == 46) || (x == 71 && y == 46) || (x == 69 && y == 47) || (x == 70 && y == 47) || (x == 69 && y == 48) || (x == 71 && y == 48) || (x == 69 && y == 49) || (x == 72 && y == 49));
    reg [3:0] box_menu = 0; // 0: Student A; 1: Student B; 2: Teamwork; 3. School Work

    always @ (posedge clk10)
    begin
        if (state == 0)
        begin
            if (down == 1) 
                begin box_menu <= (box_menu < 3)? box_menu + 1 : 0; end
            else if (up == 1)
                begin box_menu <= (box_menu > 0)? box_menu - 1 : 3; end
        end else box_menu <= 0;
    end
      
    
    always @ (posedge clk10)
    begin
        if (state == 0) // menu
        begin
            if (box_menu == 3 && enter) state_out <= 4; // student A
            else if (box_menu == 2 && enter) state_out <= 3; // student B
            else if (box_menu == 1 && enter) state_out <= 2; // teamwork
             else if (box_menu == 0 && enter) state_out <= 1; // schoolwork
        end else state_out <= 0;
    end
    

    always @ (posedge CLK100MHZ)    
    begin
        if (state == 0)
        begin
            if (!(student_a || student_b || teamwork || schoolwork))
            begin
         if (((pixel_index >= 90) && (pixel_index <= 91)) || pixel_index == 419 || ((pixel_index >= 516) && (pixel_index <= 520)) || ((pixel_index >= 612) && (pixel_index <= 615)) || ((pixel_index >= 710) && (pixel_index <= 711)) || pixel_index == 3809 || pixel_index == 3904 || pixel_index == 4721 || ((pixel_index >= 4813) && (pixel_index <= 4815)) || pixel_index == 4817 || pixel_index == 4910 || ((pixel_index >= 4912) && (pixel_index <= 4914)) || (pixel_index >= 5008) && (pixel_index <= 5010)) oled_data = 16'b1111011110010100;
            else if (((pixel_index >= 92) && (pixel_index <= 93)) || pixel_index == 617 || pixel_index == 3810 || ((pixel_index >= 3905) && (pixel_index <= 3906)) || pixel_index == 4002 || pixel_index == 4911) oled_data = 16'b1111010100010100;
            else if (pixel_index == 94 || pixel_index == 286 || pixel_index == 382 || pixel_index == 478 || pixel_index == 618 || pixel_index == 708 || pixel_index == 713 || pixel_index == 804 || pixel_index == 807 || pixel_index == 905 || pixel_index == 1092 || pixel_index == 3907 || pixel_index == 4099 || pixel_index == 4195 || pixel_index == 4291 || pixel_index == 4717 || pixel_index == 4916 || pixel_index == 5011 || pixel_index == 5102 || pixel_index == 5203) oled_data = 16'b1010010100001010;
            else if (pixel_index == 95 || pixel_index == 190 || pixel_index == 281 || pixel_index == 378 || pixel_index == 619 || ((pixel_index >= 714) && (pixel_index <= 715)) || ((pixel_index >= 809) && (pixel_index <= 810)) || pixel_index == 903 || pixel_index == 998 || pixel_index == 1091 || pixel_index == 1095 || pixel_index == 1192 || pixel_index == 3908 || pixel_index == 4003 || ((pixel_index >= 4192) && (pixel_index <= 4193)) || ((pixel_index >= 5012) && (pixel_index <= 5013)) || ((pixel_index >= 5107) && (pixel_index <= 5108)) || pixel_index == 5293 || pixel_index == 5391 || pixel_index == 5485 || pixel_index == 5586) oled_data = 16'b1010010100000000;
            else if (pixel_index == 136 || pixel_index == 231 || ((pixel_index >= 420) && (pixel_index <= 422)) || pixel_index == 515 || pixel_index == 806 || pixel_index == 1001 || pixel_index == 1097 || pixel_index == 1193 || pixel_index == 3713 || pixel_index == 3807 || ((pixel_index >= 4529) && (pixel_index <= 4530)) || pixel_index == 4626 || pixel_index == 4720 || pixel_index == 4722 || pixel_index == 4818 || pixel_index == 4909 || pixel_index == 4915 || pixel_index == 5006 || pixel_index == 5105 || pixel_index == 5491 || pixel_index == 5587) oled_data = 16'b1010010100010100;
            else if (pixel_index == 186 || ((pixel_index >= 188) && (pixel_index <= 189)) || pixel_index == 808 || pixel_index == 900 || pixel_index == 5106 || (pixel_index >= 5198) && (pixel_index <= 5201)) oled_data = 16'b1010011110001010;
            else if (pixel_index == 187) oled_data = 16'b1111011110001010;
            else if (pixel_index == 191 || pixel_index == 521 || pixel_index == 620 || pixel_index == 1093 || pixel_index == 1289 || pixel_index == 3522 || pixel_index == 3711 || pixel_index == 3811 || pixel_index == 3909 || pixel_index == 4004 || pixel_index == 4387 || pixel_index == 4716 || pixel_index == 4718 || pixel_index == 5014 || pixel_index == 5299) oled_data = 16'b0101001010001010;
            else if (pixel_index == 232 || ((pixel_index >= 327) && (pixel_index <= 328)) || ((pixel_index >= 423) && (pixel_index <= 424)) || pixel_index == 3714 || pixel_index == 3808 || pixel_index == 4625 || pixel_index == 4816) oled_data = 16'b1111011110011110;
            else if (((pixel_index >= 282) && (pixel_index <= 285)) || pixel_index == 377 || pixel_index == 381 || ((pixel_index >= 901) && (pixel_index <= 902)) || pixel_index == 904 || ((pixel_index >= 996) && (pixel_index <= 997)) || ((pixel_index >= 999) && (pixel_index <= 1000)) || pixel_index == 1096 || ((pixel_index >= 4096) && (pixel_index <= 4098)) || pixel_index == 4194 || pixel_index == 5202 || ((pixel_index >= 5294) && (pixel_index <= 5298)) || ((pixel_index >= 5389) && (pixel_index <= 5390)) || ((pixel_index >= 5393) && (pixel_index <= 5394)) || pixel_index == 5490) oled_data = 16'b1010011110000000;
            else if (pixel_index == 326) oled_data = 16'b0101000000001010;
            else if (pixel_index == 375 || pixel_index == 716 || pixel_index == 4434 || pixel_index == 4951) oled_data = 16'b0000000000001010;
            else if (pixel_index == 380 || pixel_index == 4812 || pixel_index == 4917 || pixel_index == 5109 || pixel_index == 5392 || pixel_index == 5489) oled_data = 16'b0101001010000000;
            else if (pixel_index == 418 || pixel_index == 522 || pixel_index == 4719) oled_data = 16'b0101000000000000;
            else if (pixel_index == 477 || pixel_index == 995 || pixel_index == 4191 || pixel_index == 4290) oled_data = 16'b0101010100000000;
            else if (pixel_index == 616 || pixel_index == 709 || pixel_index == 712 || pixel_index == 805 || pixel_index == 3618 || ((pixel_index >= 4000) && (pixel_index <= 4001)) || pixel_index == 5007 || (pixel_index >= 5103) && (pixel_index <= 5104)) oled_data = 16'b1010011110010100;
            else if (pixel_index == 4287) oled_data = 16'b0000001010000000;
            else if (pixel_index == 5395) oled_data = 16'b1010001010010100;
            else oled_data = 0;
            
            end else  oled_data = 16'hFFFF;
                  
            if (box_menu == 3'd0) 
            begin
                if ((x >= 28 && x <= 67) && (y >= 14 && y <= 20)) oled_data = 16'hFFFF;
                if (student_a) oled_data = 0;
            end else if (box_menu == 2'd1)
            begin
                if ((x >= 28 && x <= 66) && (y >= 24 && y <= 30)) oled_data = 16'hFFFF;
                if (student_b) oled_data = 0;
            end else if(box_menu == 2'd2)
            begin
                if ((x >= 27 && x <= 68) && (y >= 34 && y <= 40)) oled_data = 16'hFFFF;
                if (teamwork) oled_data = 0;
            end else 
            begin
          if ((x >= 22 && x <= 73) && (y >= 44 && y <= 50)) oled_data = 16'hFFFF;
           if (schoolwork) oled_data = 0;
            end      
      end   
end

endmodule
