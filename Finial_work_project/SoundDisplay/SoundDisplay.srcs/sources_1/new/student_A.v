`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 13:24:36
// Design Name: 
// Module Name: student_A
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
module student_A(input clock,
    input btnC,
    input SW15,
    input SW14,
    input SW13,
    input SW12,
    input SW11,
    input SW10,
    input SW9,
    input SW8,
    input SW7,
    input SW6,
    input SW5,
    input SW4,
    input SW3,
    input SW2,
    input SW1,
    input SW0,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    output [7:0]JC,
    output reg [15:0]led = 0,
    output reg [7:0] seg = 8'b11111111,
    output reg [3:0] an = 4'b1111,
    //output wire [15:0] sample_led
    input [3:0] state,
    output reg [3:0] state_out = 1
    );
    wire clk;
    wire clk20k;
    wire clk10;
    wire reset_sig;
    wire [12:0]index;
    wire [15:0]sample_led_tmp;
    wire [11:0]peak_data;
    wire [7:0]mic_in_grade;
    wire [11:0]sample; 
    reg  [6:0]x;
    reg  [6:0]y;
    reg  [6:0]a;
    reg  [15:0] oled_data;
    reg  [2:0] sw_on;
    //reg [11:0] peak_data=3100;
        reset instance_reset (clock,btnC,reset_sig);
        clk6p25m clk_sig (.clock(clock),.reset(1'b0),.clk(clk));
        clock_divider clock_10 (.basys_clock(clk), .m(2500000), .new_clock(clk10));
        Audio_Capture Audio_Capture (.CLK(clock), .cs(clk20k), .MISO(J_MIC3_Pin3), .clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(sample));
        clk_voice clk_voice (.clock(clock), .reset(1'b0), .clk20k(clk20k));
    
        Oled_Display  instance_OLED (.clk(clk), .reset(reset_sig), .frame_begin(), .sending_pixels(),
          .sample_pixel(), .pixel_index(index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
          .pmoden(JC[7]),.teststate());
          
        peak_volume_calcutate peak_volume_calcutate_inst (
              .clk20k(clk20k), 
              .reset(reset_sig), 
              .sample(sample), 
              .led(sample_led_tmp), 
              .peak_data(peak_data), 
              .mic_in_grade(mic_in_grade)
              ); 
              
       always @ (posedge clk)
                     begin
                         if (state == 1)
                         begin
                             if (SW15 == 1) state_out <= 0;
                         end else state_out <= 1;
                     end
    always@(posedge clk)begin
    if(state ==1)
        begin
            if (SW14==0 && SW13 == 1)
                begin
                    led[0]<= SW0;
                end
        end
    end                 
                   
    // when sw14 == 1, learn the note feature
    always@(posedge clk)begin
    if (state == 1)
        begin
            if (SW14==1 && SW13 == 0)
                begin
                    
                    sw_on <= SW12+SW11+SW10+SW9+SW8+SW7+SW6+SW5+SW4+SW3+SW2+SW1;
                        if (sw_on==1)
                            begin
                                if (SW12 == 1) //c
                                    begin
                                        an<= 4'b1110;
                                        seg <=8'b11111_001;
                                        led[15:1] <=15'b000000_00000_0001;
                                    end
                                else if (SW10 == 1) //d
                                    begin
                                        an<= 4'b1110;
                                        seg <=8'b10100_100;
                                        led[15:1] <=15'b000000_00000_0011;
                                    end
            
                                else if (SW8 == 1)//e
                                    begin
                                        seg <=8'b10110_000;
                                        an<= 4'b1110;
                                        led[15:1] <=15'b000000_00000_0111;
                                    end
            
                                else if (SW7 == 1)//f
                                    begin
                                        seg <=8'b10011_001;
                                        an<= 4'b1110;
                                        led[15:1] <=15'b000000_00000_1111;
                                    end
            
                                else if (SW5 == 1) //g
                                    begin
                                        seg <=8'b10010_010;
                                        an<= 4'b1110;
                                        led[15:1] <=15'b000000_00001_1111;
                                    end
            
                                else if (SW3 == 1)//a
                                    begin
                                        seg <=8'b10000_010;
                                        an<= 4'b1110;
                                        led[15:1] <=15'b000000_00011_1111;
                                    end
            
                                else if (SW1 == 1)//b
                                    begin
                                        seg <=8'b11111_000;
                                        an<= 4'b1110;
                                        led[15:1] <=15'b000000_00111_1111;
                                    end
                                else //half notes                               
                                    begin
                                        an<=4'b1;
                                        if (SW11 == 1) //c#
                                            begin
                                                led[15:3] <=0;                                               
                                                led[1] <=1;
                                                led[2] <=clk10;
                                            end
                                        if (SW9 == 1) //d#
                                                begin
                                                    led[15:4] <=0;                                               
                                                    led[2:1] <=2'b11;
                                                    led[3] <=clk10;
                                                end
                                        if (SW6 == 1) //f#
                                             begin
                                                 led[15:6] <=0;                                               
                                                 led[4:1] <=4'b1111;
                                                 led[5] <=clk10;
                                             end 
                                        if (SW4 == 1) //g#
                                                  begin
                                                      led[15:7] <=0;                                               
                                                      led[5:1] <=5'b11111;
                                                      led[6] <=clk10;
                                                  end   
                                        if (SW2 == 1) //a#
                                              begin
                                                  led[15:8] <=0;                                               
                                                  led[6:1] <=6'b111111;
                                                  led[7] <=clk10;
                                              end                                                                                                                                                                          
                                    end
                            end        
                        else
                            begin
                                seg <=8'b11111_111;
                                led[15:1] <= 15'b0;
                            end
                        end        
            else
                begin
                    seg <= 8'b1111_1111;
                end
        end                                                   
    end
        
    always@(posedge clk)begin
        if(state == 1)
            begin        
                x<=index%96;
                y<=index/96;
                                        
                if (SW14==1 && SW13 == 0)
                    
                    if ((x<=9||x==95) && y<=39) // c
                        begin
                            if(SW12== 1)
                                begin
                                    oled_data <= 16'hFFE0;
                                end
                            else
                                begin
                                    oled_data <= 16'hFFFF;
                                end
                        end
                    else if (x>=10 && x<=14 && y<=24) //c#
                            begin
                                if(SW11==1)
                                    begin
                                        oled_data <= 16'hFE19;
                                    end
                                else
                                    begin
                                        oled_data <= 16'hF800;
                                    end
                            end                                
                    else if (x>=15 && x<=24 && y<=39) //d
                                begin
                                    if(SW10==1)
                                        begin
                                            oled_data <= 16'hFFE0;
                                        end
                                    else
                                        begin
                                            oled_data <= 16'hFFFF;
                                        end
                                end                        
                    else if (x>=25 && x<=29 && y<=24) //d#
                                begin
                                    if(SW9==1)
                                        begin
                                            oled_data <= 16'hFE19;
                                        end
                                    else
                                        begin
                                            oled_data <= 16'hF800;
                                        end
                                end
                    else if (x>=30 && x<=39&& y<=39) //e
                                    begin
                                        if(SW8==1)
                                            begin
                                                oled_data <= 16'hFFE0;
                                            end
                                        else
                                            begin
                                                oled_data <= 16'hFFFF;
                                            end
                                    end
                    else if (x>=41 && x<=50 && y<=39) //f
                                    begin
                                        if(SW7==1)
                                            begin
                                                oled_data <= 16'hFFE0;
                                            end
                                        else
                                            begin
                                                oled_data <= 16'hFFFF;
                                            end
                                    end     
                    else if (x>=51 && x<=55 && y<=24) //f#
                                    begin
                                        if(SW6==1)
                                            begin
                                                oled_data <= 16'hFE19;
                                            end
                                        else
                                            begin
                                                oled_data <= 16'hF800;
                                            end
                                    end  
                    else if (x>=56 && x<= 65 && y<=39) //g
                                    begin
                                        if(SW5==1)
                                            begin
                                                oled_data <= 16'hFFE0;
                                            end
                                        else
                                            begin
                                                oled_data <= 16'hFFFF;
                                            end
                                    end   
                    else if (x>=66 && x<=70 && y<=24) //g#
                                        begin
                                            if(SW4==1)
                                                begin
                                                    oled_data <= 16'hFE19;
                                                end
                                            else
                                                begin
                                                    oled_data <= 16'hF800;
                                                end
                                        end  
                    else if (x>=71 && x<=80 && y<=39) //a
                                            begin
                                                if(SW3==1)
                                                    begin
                                                        oled_data <= 16'hFFE0;
                                                    end
                                                else
                                                    begin
                                                        oled_data <= 16'hFFFF;
                                                    end
                                            end                                                                                                                           
                    else if (x>=81 && x<=85 && y<=24) //a#
                                                begin
                                                    if(SW2==1)
                                                        begin
                                                            oled_data <= 16'hFE19;
                                                        end
                                                    else
                                                        begin
                                                            oled_data <= 16'hF800;
                                                        end
                                                end
                    else if (x>=86 && x <=94 && y<=39) //b
                                                begin
                                                     if(SW1==1)
                                                            begin
                                                                 oled_data <= 16'hFFE0;
                                                            end
                                                      else
                                                            begin
                                                                oled_data <= 16'hFFFF;
                                                            end
                                                 end
                    else if ((x == 10 && y == 43) || (x == 11 && y == 43) || (x == 12 && y == 43) || (x == 10 && y == 44) || (x == 13 && y == 44) || (x == 10 && y == 45) || (x == 13 && y == 45) || (x == 10 && y == 46) || (x == 13 && y == 46) || (x == 10 && y == 47) || (x == 11 && y == 47) || (x == 12 && y == 47) || (x == 15 && y == 45) || (x == 15 && y == 46) || (x == 15 && y == 47) || (x == 16 && y == 46) || (x == 16 && y == 47))
                                begin
                                    if (SW11==1)         //d@        
                                        begin                   
                                            oled_data <= 16'hFE19;
                                        end
                                    else
                                        begin
                                            oled_data <= 16'h0;
                                        end
                                end
                    else if ((x == 25 && y == 43) || (x == 26 && y == 43) || (x == 27 && y == 43) || (x == 28 && y == 43) || (x == 25 && y == 44) || (x == 25 && y == 45) || (x == 26 && y == 45) || (x == 27 && y == 45) || (x == 28 && y == 45) || (x == 25 && y == 46) || (x == 25 && y == 47) || (x == 26 && y == 47) || (x == 27 && y == 47) || (x == 28 && y == 47) || (x == 30 && y == 45) || (x == 30 && y == 46) || (x == 30 && y == 47) || (x == 31 && y == 46) || (x == 31 && y == 47))
                                begin
                                    if (SW9==1)  //e@               
                                        begin                   
                                            oled_data <= 16'hFE19;
                                        end
                                    else
                                        begin
                                            oled_data <= 16'h0;
                                        end
                                end
                    else if ((x == 52 && y == 43) || (x == 53 && y == 43) || (x == 54 && y == 43) || (x == 51 && y == 44) || (x == 51 && y == 45) || (x == 53 && y == 45) || (x == 54 && y == 45) || (x == 55 && y == 45) || (x == 51 && y == 46) || (x == 55 && y == 46) || (x == 52 && y == 47) || (x == 53 && y == 47) || (x == 54 && y == 47) || (x == 57 && y == 45) || (x == 57 && y == 46) || (x == 57 && y == 47) || (x == 58 && y == 46) || (x == 58 && y == 47))
                                    begin
                                        if (SW6==1)  //g@               
                                            begin                   
                                                oled_data <= 16'hFE19;
                                            end
                                        else
                                            begin
                                                oled_data <= 16'h0;
                                            end
                                    end  
                    else if ((x == 67 && y == 43) || (x == 68 && y == 43) || (x == 66 && y == 44) || (x == 69 && y == 44) || (x == 66 && y == 45) || (x == 67 && y == 45) || (x == 68 && y == 45) || (x == 69 && y == 45) || (x == 66 && y == 46) || (x == 69 && y == 46) || (x == 66 && y == 47) || (x == 69 && y == 47) || (x == 71 && y == 45) || (x == 71 && y == 46) || (x == 71 && y == 47) || (x == 72 && y == 46) || (x == 72 && y == 47))
                                            begin
                                                if (SW4==1)  //a@               
                                                    begin                   
                                                        oled_data <= 16'hFE19;
                                                    end
                                                else
                                                    begin
                                                        oled_data <= 16'h0;
                                                    end
                                            end
                    else if ((x == 81 && y == 43) || (x == 82 && y == 43) || (x == 83 && y == 43) || (x == 81 && y == 44) || (x == 84 && y == 44) || (x == 81 && y == 45) || (x == 82 && y == 45) || (x == 83 && y == 45) || (x == 81 && y == 46) || (x == 84 && y == 46) || (x == 81 && y == 47) || (x == 82 && y == 47) || (x == 83 && y == 47) || (x == 86 && y == 45) || (x == 86 && y == 46) || (x == 86 && y == 47) || (x == 87 && y == 46) || (x == 87 && y == 47))
                                                            begin
                                                                if (SW2==1)  //b@               
                                                                    begin                   
                                                                        oled_data <= 16'hFE19;
                                                                    end
                                                                else
                                                                    begin
                                                                        oled_data <= 16'h0;
                                                                    end
                                                            end                           
                     
                        
                    else if ((x == 2 && y == 51) || (x == 3 && y == 51) || (x == 1 && y == 52) || (x == 4 && y == 52) || (x == 1 && y == 53) || (x == 1 && y == 54) || (x == 4 && y == 54) || (x == 2 && y == 55) || (x == 3 && y == 55))
                                begin
                                    if (SW12 == 1) //c
                                        begin
                                            oled_data <= 16'hFFE0;
                                        end
                                    else
                                        begin
                                            oled_data <= 16'h0;
                                        end
                                end
                    else if ((x == 15 && y == 51) || (x == 16 && y == 51) || (x == 17 && y == 51) || (x == 15 && y == 52) || (x == 18 && y == 52) || (x == 15 && y == 53) || (x == 18 && y == 53) || (x == 15 && y == 54) || (x == 18 && y == 54) || (x == 15 && y == 55) || (x == 16 && y == 55) || (x == 17 && y == 55))
                                    begin
                                        if (SW10 == 1) //d
                                            begin
                                                oled_data <= 16'hFFE0;
                                            end
                                        else
                                            begin
                                                oled_data <= 16'h0;
                                            end
                                    end 
                    else if ((x == 30 && y == 51) || (x == 31 && y == 51) || (x == 32 && y == 51) || (x == 33 && y == 51) || (x == 30 && y == 52) || (x == 30 && y == 53) || (x == 31 && y == 53) || (x == 32 && y == 53) || (x == 33 && y == 53) || (x == 30 && y == 54) || (x == 30 && y == 55) || (x == 31 && y == 55) || (x == 32 && y == 55) || (x == 33 && y == 55))
                                            begin
                                                if (SW8 == 1) //e
                                                    begin
                                                        oled_data <= 16'hFFE0;
                                                    end
                                                else
                                                    begin
                                                        oled_data <= 16'h0;
                                                    end
                                            end 
                    else if ((x == 41 && y == 51) || (x == 42 && y == 51) || (x == 43 && y == 51) || (x == 44 && y == 51) || (x == 41 && y == 52) || (x == 41 && y == 53) || (x == 42 && y == 53) || (x == 43 && y == 53) || (x == 44 && y == 53) || (x == 41 && y == 54) || (x == 41 && y == 55))
                                begin
                                    if (SW7 == 1) //f
                                        begin
                                            oled_data <= 16'hFFE0;
                                        end
                                    else
                                        begin
                                            oled_data <= 16'h0;
                                        end
                                end
                    else if ((x == 57 && y == 51) || (x == 58 && y == 51) || (x == 59 && y == 51) || (x == 56 && y == 52) || (x == 56 && y == 53) || (x == 58 && y == 53) || (x == 59 && y == 53) || (x == 60 && y == 53) || (x == 56 && y == 54) || (x == 60 && y == 54) || (x == 57 && y == 55) || (x == 58 && y == 55) || (x == 59 && y == 55))
                                    begin
                                        if (SW5 == 1) //g
                                            begin
                                                oled_data <= 16'hFFE0;
                                            end
                                        else
                                            begin
                                                oled_data <= 16'h0;
                                            end
                                    end
                    else if ((x == 72 && y == 51) || (x == 73 && y == 51) || (x == 71 && y == 52) || (x == 74 && y == 52) || (x == 71 && y == 53) || (x == 72 && y == 53) || (x == 73 && y == 53) || (x == 74 && y == 53) || (x == 71 && y == 54) || (x == 74 && y == 54) || (x == 71 && y == 55) || (x == 74 && y == 55))
                                        begin
                                            if (SW3 == 1) //a
                                                begin
                                                    oled_data <= 16'hFFE0;
                                                end
                                            else
                                                begin
                                                    oled_data <= 16'h0;
                                                end
                                        end
                    else if ((x == 86 && y == 51) || (x == 87 && y == 51) || (x == 88 && y == 51) || (x == 86 && y == 52) || (x == 89 && y == 52) || (x == 86 && y == 53) || (x == 87 && y == 53) || (x == 88 && y == 53) || (x == 86 && y == 54) || (x == 89 && y == 54) || (x == 86 && y == 55) || (x == 87 && y == 55) || (x == 88 && y == 55))
                                            begin
                                                if (SW1 == 1) //b
                                                    begin
                                                        oled_data <= 16'hFFE0;
                                                    end
                                                else
                                                    begin
                                                        oled_data <= 16'h0;
                                                    end
                                            end                                                                              
                    else 
                            begin
                                oled_data <= 16'h0000;
                            end
            
           
     
          
                                         
                else if (SW13==1 && SW14==0)
                    begin
                         if ((x==95||x<=9 )&& y<=39) // c
                             begin
                                 if(SW12==1)
                                     begin
                                         oled_data <= 16'hFFE0;
                                     end
                                 else
                                     begin
                                         oled_data <= 16'hFFFF;
                                     end
                             end
                         else if (x>=10 && x<=14 && y<=24) //c#
                                 begin
                                     if(SW11==1)
                                         begin
                                             oled_data <= 16'hFE19;
                                         end
                                     else
                                         begin
                                             oled_data <= 16'hF800;
                                         end
                                 end                                
                         else if (x>=15 && x<=24 && y<=39) //d
                                     begin
                                         if(SW10==1)
                                             begin
                                                 oled_data <= 16'hFFE0;
                                             end
                                         else
                                             begin
                                                 oled_data <= 16'hFFFF;
                                             end
                                     end                        
                         else if (x>=25 && x<=29 && y<=24) //d#
                                     begin
                                         if(SW9==1)
                                             begin
                                                 oled_data <= 16'hFE19;
                                             end
                                         else
                                             begin
                                                 oled_data <= 16'hF800;
                                             end
                                     end
                         else if (x>=30 && x<=39&& y<=39) //e
                                         begin
                                             if(SW8==1)
                                                 begin
                                                     oled_data <= 16'hFFE0;
                                                 end
                                             else
                                                 begin
                                                     oled_data <= 16'hFFFF;
                                                 end
                                         end
                         else if (x>=41 && x<=50 && y<=39) //f
                                         begin
                                             if(SW7==1)
                                                 begin
                                                     oled_data <= 16'hFFE0;
                                                 end
                                             else
                                                 begin
                                                     oled_data <= 16'hFFFF;
                                                 end
                                         end     
                         else if (x>=51 && x<=55 && y<=24) //f#
                                         begin
                                             if(SW6==1)
                                                 begin
                                                     oled_data <= 16'hFE19;
                                                 end
                                             else
                                                 begin
                                                     oled_data <= 16'hF800;
                                                 end
                                         end  
                         else if (x>=56 && x<= 65 && y<=39) //g
                                         begin
                                             if(SW5==1)
                                                 begin
                                                     oled_data <= 16'hFFE0;
                                                 end
                                             else
                                                 begin
                                                     oled_data <= 16'hFFFF;
                                                 end
                                         end   
                         else if (x>=66 && x<=70 && y<=24) //g#
                                             begin
                                                 if(SW4==1)
                                                     begin
                                                         oled_data <= 16'hFE19;
                                                     end
                                                 else
                                                     begin
                                                         oled_data <= 16'hF800;
                                                     end
                                             end  
                         else if (x>=71 && x<=80 && y<=39) //a
                                                 begin
                                                     if(SW3==1)
                                                         begin
                                                             oled_data <= 16'hFFE0;
                                                         end
                                                     else
                                                         begin
                                                             oled_data <= 16'hFFFF;
                                                         end
                                                 end                                                                                                                           
                         else if (x>=81 && x<=85 && y<=24) //a#
                                                     begin
                                                         if(SW2==1)
                                                             begin
                                                                 oled_data <= 16'hFE19;
                                                             end
                                                         else
                                                             begin
                                                                 oled_data <= 16'hF800;
                                                             end
                                                     end
                         else if (x>=86 && x<=94 && y<=39) //b
                                                     begin
                                                          if(SW1==1)
                                                                 begin
                                                                      oled_data <= 16'hFFE0;
                                                                 end
                                                           else
                                                                 begin
                                                                     oled_data <= 16'hFFFF;
                                                                 end
                                                      end
                         else if ((x==1 && y>=48 && y<=54) || 
                         (x==2 && (y==47 || y==50 || y==55)) ||
                         (x==3 && (y==46 || y==51 || y==56)) ||
                         (x==4 && (y==46 || y==51 || y==56)) ||
                         (x==5 && (y==47 || y==50 || y==55)) ||
                         (x==6 && (y==48 || y==49 || y==54)) ||
                         (y==51&& (x>=9 && x<=13)) ||
                         (x==16 && (y>=46 && y<=59)) ||
                         (x==17 && (y==46 || y==53)) ||
                         (x==18 && (y==46 || y==53)) ||
                         (x==19 && (y==46 || y==53)) ||
                         (x==20 && (y==46 || y==53)) ||
                         (x==21 && (y==47 || y==52)) ||
                         (x==22 && (y>=48 && y<=51)) ||
                         (x==25 && (y==46 || y==47)) ||
                         (x==25 && (y>=50 && y<=56)) ||
                         (x==28 && (y>=49 && y<=54)) ||
                         (x==29 && (y==48 || y==55)) ||
                         (x==30 && (y==47 || y==56)) ||
                         (x==31 && (y==47 || y==56)) ||
                         (x==32 && (y==48 || y==55)) ||
                         (x==33 && (y>=49 && y<=56)) ||
                         (x==36 && (y>=49 && y<=56)) ||
                         (x==37 && y==48) ||
                         (x==38 && y==47) ||
                         (x==39 && y==47) ||
                         (x==40 && y==48) ||
                         (x==41 && (y>=49 && y<=56)) ||
                         (x==44 && (y>=49 && y<=54)) ||
                         (x==45 && (y==48 || y==55)) ||
                         (x==46 && (y==47 || y==56)) ||
                         (x==47 && (y==47 || y==56)) ||
                         (x==48 && (y==48 || y==55)) ||
                         (x==49 && (y>=49 && y<=54))) // e Piano
                             begin
                                 oled_data <= 16'hFFFF;
                             end
                         else if ((x==81 && (y>=49 && y<=54)) ||
                                  (x==82 && (y==48 || y==55)) ||
                                  (x==83 && (y==47 || y==56)) ||
                                  (x==84 && (y==47 || y==56)) ||
                                  (x==85 && (y==48 || y==55)) ||
                                  (x==86 && (y==49 || y==54)) ||
                                  (x==88 && (y>=53 && y<=56)) ||
                                  (x==90 && (y>=53 && y<=56)) ||
                                  (x==92 && (y>=53 && y<=56)) ||
                                  (y==52 && (x==89 || x==91))) // Cm
                             begin
                                 if (SW12==1 && SW8==1 && SW5==1 && (SW0==1||peak_data >= 8)) //chd c
                                     begin
                                         if ((x==81 && (y>=49 && y<=54)) ||
                                              (x==82 && (y==48 || y==55)) ||
                                              (x==83 && (y==47 || y==56)) ||
                                              (x==84 && (y==47 || y==56)) ||
                                              (x==85 && (y==48 || y==55)) ||
                                              (x==86 && (y==49 || y==54)))
                                             begin
                                                 oled_data <= 16'hFFFF;
                                             end
                                         else 
                                             begin
                                                 oled_data <= 16'h0000;
                                             end
                                     end
                                                  
                                 else if (SW12==1 && SW9==1 && SW5==1 && (SW0==1||peak_data >= 8))
                                     begin
                                         oled_data <= 16'hFFFF;
                                     end
                                 else
                                     begin
                                         oled_data <= 16'h0000;
                                     end
                             end
                         
                                     
                         else if ((x==69 && (y>=47 && y<=56)) ||
                         (x==70 && (y==47 || y==56)) ||
                         (x==71 && (y==47 || y==56)) ||
                         (x==72 && (y==47 || y==56)) ||
                         (x==73 && (y==48 || y==55)) ||
                         (x==74 && (y>=49 && y<=54)) ||
                         (x==76 && (y>=53 && y<=56)) ||
                         (x==78 && (y>=53 && y<=56)) ||
                         (x==80 && (y>=53 && y<=56)) ||
                         (y==52 && (x==77 || x==79))) // Dm
                             begin
                                 if (SW10==1 && SW6==1 && SW3==1 && (SW0==1||peak_data >= 8)) // Chd D
                                     begin
                                         if ((x==69 && (y>=47 && y<=56)) ||
                                                     (x==70 && (y==47 || y==56)) ||
                                                     (x==71 && (y==47 || y==56)) ||
                                                     (x==72 && (y==47 || y==56)) ||
                                                     (x==73 && (y==48 || y==55)) ||
                                                     (x==74 && (y>=49 && y<=54)))
                                             begin
                                                 oled_data <= 16'hFFFF;
                                             end
                                         else
                                             begin
                                                 oled_data <= 16'h0000;
                                             end
                                     end
                                 else if (SW10==1 && SW7==1 && SW3==1 && (SW0==1||peak_data >= 8))
                                     begin
                                         oled_data <= 16'hFFFF;
                                     end
                                 else
                                     begin
                                         oled_data <= 16'h0000;
                                     end
                             end
                         else if ((x==56 && (y>=47 && y<=56)) ||
                                             (x==57 && (y==47 || y==56 || y==51)) ||
                                             (x==58 && (y==47 || y==56 || y==51)) ||
                                             (x==59 && (y==47 || y==56 || y==51)) ||
                                             (x==60 && (y==47 || y==56 || y==51)) ||
                                             (x==62 && (y>=53 && y<=56)) ||
                                             (x==64 && (y>=53 && y<=56)) ||
                                             (x==66 && (y>=53 && y<=56)) ||
                                             (y==52 && (x==63 || x==65))) //Em
                                                 begin
                                                     if (SW8==1 && SW4==1 && SW1==1 &&(SW0==1||peak_data >= 8))//Chrd E
                                                         begin
                                                             if ((x==56 && (y>=47 && y<=56)) ||
                                                                         (x==57 && (y==47 || y==56 || y==51)) ||
                                                                         (x==58 && (y==47 || y==56 || y==51)) ||
                                                                         (x==59 && (y==47 || y==56 || y==51)) ||
                                                                         (x==60 && (y==47 || y==56 || y==51)))
                                                                 begin
                                                                     oled_data <= 16'hFFFF;
                                                                 end
                                                             else
                                                                 begin
                                                                     oled_data <= 16'h0000;
                                                                 end
                                                         end
                                                     else if (SW8==1 && SW5==1 && SW1==1 && (SW0==1||peak_data >= 8))
                                                         begin
                                                             oled_data <= 16'hFFFF;
                                                         end
                                                     else
                                                         begin
                                                             oled_data <= 16'h0000;
                                                         end
                                                 end
                         else 
                                 begin
                                     oled_data <= 16'h0000;
                                 end
                         end
                    end           
              
      end   
                 
                 
                       
                
                
                

endmodule


