`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2022 09:54:08 AM
// Design Name: 
// Module Name: schoolwork
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


module schoolwork(
   input [3:0]state,
   input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
   output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
   output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
   input CLK100MHZ,
   input [15:0] sw,
   output reg [15:0] led,
   output reg [7:0] seg,
   output reg [3:0] an,
   output [7:0] JC,
   output reg [3:0]state_out = 4
 );
  reg [13:0]pixel_add;
    wire [12:0]background_color;
   wire clk20k, clk100, clk10, clk6p25m, clk3, clk381, clk60, clk30;
  clock_divider clock_20k (.basys_clock(CLK100MHZ), .m(2499), .new_clock(clk20k));
      clock_divider clock_10 (.basys_clock(CLK100MHZ), .m(4999999), .new_clock(clk10));
      clock_divider clock_6p25m (.basys_clock(CLK100MHZ), .m(7), .new_clock(clk6p25m));
   
      wire [16:0] frame1;
      
         reg [11:0]led_20k;
         reg [11:0]led_10;
      
           wire [11:0] mic_in;
         Audio_Capture audio_copy(.CLK(CLK100MHZ),.cs(clk20k),.MISO(J_MIC3_Pin3),.clk_samp(J_MIC3_Pin1),
                                     .sclk(J_MIC3_Pin4),.sample(mic_in));
  
         wire reset_sig, frame_beg_sig, send_pix_sig, sample_pix_sig;
         wire [12:0] pix_index_out;
         reg [15:0] pix_data_in ;
   
               initial
               begin
               seg = 8'b11111111;
               an = 4'b1111;
               led = 0;
               end
               reg [21:0]current_peak = 0;
               reg [15:0]count_time = 0;
               reg [15:0]mic_data = 0;
               reg [3:0] level = 0;

   
      wire frame_begin, sending_pixels, sample_pixel, teststate;
      wire [12:0] pixel_index;
      Oled_Display oled(
          .clk(clk6p25m), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
          .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(pix_data_in), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),
          .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
          .pmoden(JC[7]),.teststate(teststate)
      );
 //     back_pink back_ground(sw, clk6p25m,pixel_index, background_color);  //set the video capture as different color

     reg [60:0]COUNT = 0;
     Audio_Capture audio(.CLK(CLK100MHZ),.cs(clk20k),.MISO(J_MIC3_Pin3),.clk_samp(J_MIC3_Pin1),
                                   .sclk(J_MIC3_Pin4),.sample(mic_in));
                            
          wire [20:0]x, y;
                            
      find_row_col row_col (pixel_index, y, x);                         
                       
   always @ (posedge CLK100MHZ)
          begin
              if (state == 4)
              begin
                  if (sw[15] == 1) state_out <= 0;
              end else state_out <= 4;
          end
          
          
      always @(posedge clk20k)
          if(state == 4)begin
                         begin
                         count_time <= count_time + 1;
                         mic_data <= mic_in;
                         if(mic_data > current_peak )
                         begin
                         current_peak <= mic_data;
                         end
                         if(count_time == 2000)
                         begin
                         if(sw[5] == 0)
                         begin
                         an = 4'b1111;
                         end
                         if(current_peak < 2078)
                         begin
                         level <= 0;
                         if(sw[5] == 1)
                        begin
                         an <= 4'b1110;
                        seg <= 8'b1100_0000; //level
                      //  led <= 5'b00001;
                        end
                        if(sw[4] == 1)
                        begin
                        led <= 4'b00000;
                        end
                         end
                         else if(current_peak >=  100  && current_peak < 2090)
                          begin
                          level <= 1;
                           if(sw[5] == 1)
                           begin
                           an <= 4'b1110;
                          seg <= 8'b1111_1001; //level 1
                          end
                        if(sw[4] == 1)
                        begin
                          led <= 4'b00001;
                          end
                         end
                          else if(current_peak >=  2300 && current_peak <2600)
                             begin
                             level <= 2;
                              if(sw[5] == 1)
                              begin
                              an <= 4'b1110;
                              seg <= 8'b1010_0100;  //level 2
                              end
                              if (sw[4] == 1)
                              led <= 4'b00011;
                              end
                           else if(current_peak >=  2600 && current_peak < 2900)
                              begin
                              level <= 3;
                               if(sw[5] == 1)
                               begin  
                               an <= 4'b1110;              
                               seg <= 8'b1011_0000; // level 3
                               end
                               if(sw[4] == 1)
                               led <= 5'b00111;
                               end
                            else if(current_peak >=  2900 && current_peak < 3100)
                               begin
                               level <= 4;
                                 if(sw[5] == 1)
                                 begin
                                 an <= 4'b1110;
                                seg <= 8'b1011_1001; // level 4
                                end
                                if(sw[4] == 1)
                                begin
                                led <= 5'b01111;
                                end
                                end   
                           else if(current_peak >=  3100 && current_peak < 3300)
                             begin
                             level <= 5;
                             if(sw[5] == 1)
                             begin
                             an <= 4'b1110;
                             seg <= 8'b1001_0010; // level 5
                             end
                              if(sw[4] == 1)
                             begin
                             led <= 5'b11111;
                             end
                              end  
                                count_time <= 0;
                                current_peak <= 0;
                         end
                        
                         end
                         end 
              //task 1 
              //switch[0] for both student A and B to show oled for peak sound
              //switch[1] for student A to hide or show the display
              //switch[2] show student B work
              //switch[3] to hide or display orange color           
               always @(posedge clk6p25m)   
               if(state == 4)
               begin
               begin 
               if(sw[1] == 1 && sw[0] == 0 && sw[2] == 0)
               begin
                if (x == 0 || x == 95 || y == 0 || y == 63)
                           begin
                               pix_data_in <= 16'b00000_111111_00000;
                           end
                       else if ({(x == 5 ||x == 90) && (y >= 5 && y <= 58)} ||
                                    {(y == 5 || y == 58) && (x>=5 && x<= 90) })
                           begin
                               pix_data_in <= 16'b11111_100000_00000;
                           end
                       else if ({((10<= x && x <= 12) || (83<= x && x <= 85))&& (y >= 10 && y <= 53) }||
                                    {((10 <= y && y <= 12) ||( 51<= y && y <= 53))&& (x>=10 && x<= 85)}  )
                           begin
                               pix_data_in <= 16'b11111_000000_00000;
                           end
                       else
                           begin
                               pix_data_in <= 16'b00000_000000_00000;
                           end
                           end
                           else if(sw[1] == 0 && sw[0] == 0 && sw[2] == 0)
                           begin
                            pix_data_in <= 16'b00000_000000_00000;
                           end
                          // end
                                     
             if(sw[2] == 1 && sw[0] == 0 && sw[1] == 0)  // use switch 2 to display student B'work
                         begin
                          if( x >= 20 && x < 80 && y >= 16 && y <= 54)
                          begin
                         pix_data_in = 16'b00000_111111_00000;
                          if( x >= 20 && x < 80 && y >= 23 && y <= 47)
                              begin
                              if(sw[3] == 1)
                              begin
                              pix_data_in = 16'b11111_100000_00000;
                              end
                              if( x >= 20 && x < 80 && y >= 30 && y <= 40)
                                    begin
                                         pix_data_in = 16'b11111_000000_00000;
                                    end
                                    end
                                    end
                                    else
                                    begin
                                    pix_data_in = 16'b00000_000000_00000;
                                    end
                                    end
                                    else if(sw[1] == 0 && sw[0] == 0 && sw[2] == 0)
                                    begin
                                     pix_data_in = 16'b00000_000000_00000;
                                    end   
                      //use switch[0] to display oled based on the sound input              
                                    
                   if(sw[0] == 1 && sw[2] == 0 && sw[1] == 0)
                   begin
                   if(level == 0)
                   begin
                    pix_data_in = 16'b00000_000000_00000;
                   end
                   else if(level == 1 || level == 2)
                   begin
                   if ((x == 0 || x == 95 || y == 0 || y == 63) || ( x >= 20 && x < 80 && y >= 16 && y <= 54))
                       begin
                         pix_data_in <= 16'b00000_111111_00000;
                        end
                        
                      else
                        begin
                        pix_data_in = 16'b00000_000000_00000;
                        end
                   end
                   else if(level == 3 || level == 4)
                   begin
                      if ({(x == 5 ||x == 90) && (y >= 5 && y <= 58)} ||  {(y == 5 || y == 58) && (x>=5 && x<= 90) } || ( x >= 20 && x < 80 && y >= 23 && y <= 47) )
                          begin
                                 pix_data_in <= 16'b11111_100000_00000;
                           end
                       else
                         begin
                         pix_data_in = 16'b00000_000000_00000;
                         end
                   end
                   else if(level == 5)
                   begin
                   if ({((10<= x && x <= 12) || (83<= x && x <= 85))&& (y >= 10 && y <= 53) }||
                        {((10 <= y && y <= 12) ||( 51<= y && y <= 53))&& (x>=10 && x<= 85)} || (x >= 20 && x < 80 && y >= 30 && y <= 40))
                        begin
                        pix_data_in = 16'b11111_000000_00000;
                        end
                    else
                        begin
                         pix_data_in = 16'b00000_000000_00000;
                        end
                   end
     
             end
                
         end
         end
 
 
endmodule
