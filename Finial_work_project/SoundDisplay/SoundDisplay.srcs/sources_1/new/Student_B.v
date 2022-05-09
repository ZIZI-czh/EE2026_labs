`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2022 12:59:22 PM
// Design Name: 
// Module Name: Student_B
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


module Student_B(
    input [3:0] state,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    input CLK100MHZ,
    input [15:0] sw,
    input btnR,
    input btnL,
    output reg [15:0] led = 0,
    output reg [7:0] seg = 8'b11111111,
    output reg [3:0] an = 4'b1111,
    output [7:0] JC,
    output reg [3:0] state_out = 2
    );
    reg check_state_1;
    always @ (posedge CLK100MHZ)
    begin
        if (state == 2)
        begin
        check_state_1 <= 1;
            if (sw[15] == 1) begin state_out <= 0; check_state_1 <= 0; end
        end else state_out <= 2;
    end
    
        
        wire clk20k, clk100, clk10, clk6p25m, clk3, clk381, clk60, clk30;
        clock_divider clock_20k (.basys_clock(CLK100MHZ), .m(2499), .new_clock(clk20k));
        clock_divider clock_100 (.basys_clock(CLK100MHZ), .m(499999), .new_clock(clk100));
        clock_divider clock_10 (.basys_clock(CLK100MHZ), .m(4999999), .new_clock(clk10));
        clock_divider clock_6p25m (.basys_clock(CLK100MHZ), .m(7), .new_clock(clk6p25m));
        clock_divider clock_3 (.basys_clock(CLK100MHZ), .m(16666666), .new_clock(clk3));
        clock_divider clock_381 (.basys_clock(CLK100MHZ), .m(131233), .new_clock(clk381));
        clock_divider clock_60 (.basys_clock(CLK100MHZ), .m(833332), .new_clock(clk60));
        clock_divider clock_30 (.basys_clock(CLK100MHZ), .m(1666665), .new_clock(clk30));
       // clock_divider clock_1 (.basys_clock(CLK100MHZ), .m(49999999), .new_clock(clk10));
        wire [12:0]background_color;
          wire check;
     blink_title blink(CLK100MHZ, check, sw);
        
        reg [15:0] oled_data = 0;
        wire frame_begin, sending_pixels, sample_pixel, teststate;
        wire [12:0] pixel_index;
        Oled_Display oled(
            .clk(clk6p25m), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels),
            .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),
            .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
            .pmoden(JC[7]),.teststate(teststate)
        );
       
      //  back_pink back_ground(sw, CLK100MHZ, pixel_index, background_color);  //set the video capture as different color
        wire [11:0] mic_in;
        Audio_Capture audio0 (.CLK(CLK100MHZ), .cs(clk20k), .MISO(J_MIC3_Pin3), 
                              .clk_samp(J_MIC3_Pin1), .sclk(J_MIC3_Pin4), .sample(mic_in));
        
   
        
        reg [5:0] encoded_audio = 0; // encode the value of peak [0 -> 15]
        
        wire [12:0] x, y; 
        find_row_col row_col (pixel_index, y, x);
        
        reg [11:0] peak = 0; // store the value of peak
        reg [13:0] samples = 0; // count the number of samples taken
        reg [11:0] current = 0; // store the value of current sample
        reg [5:0] encoded_peak = 0; // encode the value of peak [0 -> 15]
        
        always @ (posedge clk20k)
            begin
            if (state == 2)
            begin
                if (samples < 14'd4000) // find peak every 0.2sec
                //if (samples < 14'd12000) // find peak every 0.6sec
                begin
                    current = mic_in;
                    if (current > peak) peak <= current;
                    samples <= samples + 1;
                end else 
                begin 
                    samples <= 0;
                    peak <= 0;
                end
            end
            end
            
            always @ (posedge CLK100MHZ)
            begin
            if (state == 2)
            begin
                if (peak < 2048) encoded_peak <= 0;
                else encoded_peak <= (peak - 2048) / 128 + 1;
            end
            end
            
            
            // Encode mic_in data
            always @ (posedge clk20k)
            begin
            if (state == 2)
            begin
                if (mic_in < 2048) encoded_audio = 0;
                else encoded_audio = (mic_in - 2048) / 128 + 1;
            end
            end
            
            reg [4:0] wave [0:95];
            
            always @ (posedge clk30)
            begin
            if (state == 2)
            begin
             if(sw[13] == 0)begin
                wave[0] <= encoded_audio * 3;
                wave[1] <= wave[0]; wave[2] <= wave[1]; wave[3] <= wave[2]; wave[4] <= wave[3]; wave[5] <= wave[4]; wave[6] <= wave[5]; wave[7] <= wave[6]; wave[8] <= wave[7]; wave[9] <= wave[8]; wave[10] <= wave[9]; wave[11] <= wave[10]; wave[12] <= wave[11]; wave[13] <= wave[12]; wave[14] <= wave[13]; wave[15] <= wave[14]; wave[16] <= wave[15]; wave[17] <= wave[16]; wave[18] <= wave[17]; wave[19] <= wave[18]; wave[20] <= wave[19]; wave[21] <= wave[20]; wave[22] <= wave[21]; wave[23] <= wave[22]; wave[24] <= wave[23]; wave[25] <= wave[24]; wave[26] <= wave[25]; wave[27] <= wave[26]; wave[28] <= wave[27]; wave[29] <= wave[28]; wave[30] <= wave[29]; wave[31] <= wave[30]; wave[32] <= wave[31]; wave[33] <= wave[32]; wave[34] <= wave[33]; wave[35] <= wave[34]; wave[36] <= wave[35]; wave[37] <= wave[36]; wave[38] <= wave[37]; wave[39] <= wave[38]; wave[40] <= wave[39]; wave[41] <= wave[40]; wave[42] <= wave[41]; wave[43] <= wave[42]; wave[44] <= wave[43]; wave[45] <= wave[44]; wave[46] <= wave[45]; wave[47] <= wave[46]; wave[48] <= wave[47]; wave[49] <= wave[48]; wave[50] <= wave[49]; wave[51] <= wave[50]; wave[52] <= wave[51]; wave[53] <= wave[52]; wave[54] <= wave[53]; wave[55] <= wave[54]; wave[56] <= wave[55]; wave[57] <= wave[56]; wave[58] <= wave[57]; wave[59] <= wave[58]; wave[60] <= wave[59]; wave[61] <= wave[60]; wave[62] <= wave[61]; wave[63] <= wave[62]; wave[64] <= wave[63]; wave[65] <= wave[64]; wave[66] <= wave[65]; wave[67] <= wave[66]; wave[68] <= wave[67]; wave[69] <= wave[68]; wave[70] <= wave[69]; wave[71] <= wave[70]; wave[72] <= wave[71]; wave[73] <= wave[72]; wave[74] <= wave[73]; wave[75] <= wave[74]; wave[76] <= wave[75]; wave[77] <= wave[76]; wave[78] <= wave[77]; wave[79] <= wave[78]; wave[80] <= wave[79]; wave[81] <= wave[80]; wave[82] <= wave[81]; wave[83] <= wave[82]; wave[84] <= wave[83]; wave[85] <= wave[84]; wave[86] <= wave[85]; wave[87] <= wave[86]; wave[88] <= wave[87]; wave[89] <= wave[88]; wave[90] <= wave[89]; wave[91] <= wave[90]; wave[92] <= wave[91]; wave[93] <= wave[92]; wave[94] <= wave[93]; wave[95] <= wave[94]; 
            end
            end    
            end
            
            wire [3:0] color;
            random_clor col (clk3, 0, color);
            reg [15:0] wave_color [0:15];
            
        initial
        begin
            wave_color[0] = 16'b11000_011000_11111;
            wave_color[1] = 16'b01111_000000_01111;
            wave_color[3] = 16'b00110_000111_11111;
            wave_color[4] = 16'b00000_001111_11111;
            wave_color[5] = 16'b00011_011111_11111;
            wave_color[6] = 16'b01100_111111_11111;
            wave_color[7] = 16'b00011_111111_11111;
            wave_color[8] = 16'b00111_000000_11111;
            wave_color[9] = 16'b11111_000000_00111;
            wave_color[10] = 16'b01100_111111_00011;
            wave_color[11] = 16'b01111_111111_00011;
            wave_color[12] = 16'b11000_111111_00000;
            wave_color[13] = 16'b00110_100111_01000;
            wave_color[14] = 16'b10111_111111_00000;
            wave_color[15] = 16'b11111_001111_00011;
        end
        
        
        
        
        
            
        reg [15:0] peak_color = 16'b11111_011001_00000;
        
        reg [4:0] visual_peak [0:95];
        
        always @ (posedge clk30)
        begin
        if (state == 2)
        begin
            if(sw[14] == 0)
            begin
            visual_peak[0] <= encoded_peak * 2;
            visual_peak[1] <= visual_peak[0]; visual_peak[2] <= visual_peak[1]; visual_peak[3] <= visual_peak[2]; visual_peak[4] <= visual_peak[3]; visual_peak[5] <= visual_peak[4]; visual_peak[6] <= visual_peak[5]; visual_peak[7] <= visual_peak[6]; visual_peak[8] <= visual_peak[7]; visual_peak[9] <= visual_peak[8]; visual_peak[10] <= visual_peak[9]; visual_peak[11] <= visual_peak[10]; visual_peak[12] <= visual_peak[11]; visual_peak[13] <= visual_peak[12]; visual_peak[14] <= visual_peak[13]; visual_peak[15] <= visual_peak[14]; visual_peak[16] <= visual_peak[15]; visual_peak[17] <= visual_peak[16]; visual_peak[18] <= visual_peak[17]; visual_peak[19] <= visual_peak[18]; visual_peak[20] <= visual_peak[19]; visual_peak[21] <= visual_peak[20]; visual_peak[22] <= visual_peak[21]; visual_peak[23] <= visual_peak[22]; visual_peak[24] <= visual_peak[23]; visual_peak[25] <= visual_peak[24]; visual_peak[26] <= visual_peak[25]; visual_peak[27] <= visual_peak[26]; visual_peak[28] <= visual_peak[27]; visual_peak[29] <= visual_peak[28]; visual_peak[30] <= visual_peak[29]; visual_peak[31] <= visual_peak[30]; visual_peak[32] <= visual_peak[31]; visual_peak[33] <= visual_peak[32]; visual_peak[34] <= visual_peak[33]; visual_peak[35] <= visual_peak[34]; visual_peak[36] <= visual_peak[35]; visual_peak[37] <= visual_peak[36]; visual_peak[38] <= visual_peak[37]; visual_peak[39] <= visual_peak[38]; visual_peak[40] <= visual_peak[39]; visual_peak[41] <= visual_peak[40]; visual_peak[42] <= visual_peak[41]; visual_peak[43] <= visual_peak[42]; visual_peak[44] <= visual_peak[43]; visual_peak[45] <= visual_peak[44]; visual_peak[46] <= visual_peak[45]; visual_peak[47] <= visual_peak[46]; visual_peak[48] <= visual_peak[47]; visual_peak[49] <= visual_peak[48]; visual_peak[50] <= visual_peak[49]; visual_peak[51] <= visual_peak[50]; visual_peak[52] <= visual_peak[51]; visual_peak[53] <= visual_peak[52]; visual_peak[54] <= visual_peak[53]; visual_peak[55] <= visual_peak[54]; visual_peak[56] <= visual_peak[55]; visual_peak[57] <= visual_peak[56]; visual_peak[58] <= visual_peak[57]; visual_peak[59] <= visual_peak[58]; visual_peak[60] <= visual_peak[59]; visual_peak[61] <= visual_peak[60]; visual_peak[62] <= visual_peak[61]; visual_peak[63] <= visual_peak[62]; visual_peak[64] <= visual_peak[63]; visual_peak[65] <= visual_peak[64]; visual_peak[66] <= visual_peak[65]; visual_peak[67] <= visual_peak[66]; visual_peak[68] <= visual_peak[67]; visual_peak[69] <= visual_peak[68]; visual_peak[70] <= visual_peak[69]; visual_peak[71] <= visual_peak[70]; visual_peak[72] <= visual_peak[71]; visual_peak[73] <= visual_peak[72]; visual_peak[74] <= visual_peak[73]; visual_peak[75] <= visual_peak[74]; visual_peak[76] <= visual_peak[75]; visual_peak[77] <= visual_peak[76]; visual_peak[78] <= visual_peak[77]; visual_peak[79] <= visual_peak[78]; visual_peak[80] <= visual_peak[79]; visual_peak[81] <= visual_peak[80]; visual_peak[82] <= visual_peak[81]; visual_peak[83] <= visual_peak[82]; visual_peak[84] <= visual_peak[83]; visual_peak[85] <= visual_peak[84]; visual_peak[86] <= visual_peak[85]; visual_peak[87] <= visual_peak[86]; visual_peak[88] <= visual_peak[87]; visual_peak[89] <= visual_peak[88]; visual_peak[90] <= visual_peak[89]; visual_peak[91] <= visual_peak[90]; visual_peak[92] <= visual_peak[91]; visual_peak[93] <= visual_peak[92]; visual_peak[94] <= visual_peak[93]; visual_peak[95] <= visual_peak[94]; 
            end
            
        end
        end
        
        
        reg [2:0] count = 0;
        always @ (posedge clk381)
        begin
        if (state == 2)
        begin
            if (count != 3'd3) count <= count + 1;
            else count <= 0;
        end
        end
        
        
        reg [5:0] encoded_audio_slow = 0;
        always @ (posedge clk10)
        begin
        if (state == 2)
            encoded_audio_slow <= encoded_audio;
        end
        
        //add on new functions
               //decalration 
               
               reg [11:0] mic_data [96-1:0];
                   integer i;
                   initial begin
                       for (i = 0; i <64; i = i+1) begin
                          mic_data[i] = 0;
                       end
                   end
                   
                 wire [5:0] num; // value from 0 to 63
                   reg [95:0] countx = 0; // 0 to 95
                   
                      wire [5:0]count_press_r, count_press_g, count_press_b;
                               reg[5:0] count_press;
                             
                  
                        reg [15:0] change_col [0:15];
                     
                         change_color color_R( clk10,  CLK100MHZ,  btnR,  btnL, count_press_r, count_press_g, count_press_b, sw, check_state_1);
                        
                          always @ (posedge clk6p25m)
                          if (state==2)
                          begin
                            begin
                            if(sw[6]==1)
                            begin
                              change_col[0] = 16'b00000_000000_00000;
                           change_col[1] = 16'b00001_000000_00001;
                             change_col[2] = 16'b00011_000000_00000;
                                  change_col[3] = 16'b00111_000000_00000;
                                      change_col[4] = 16'b01111_000000_00000;
                                       change_col[5] = 16'b11111_000000_00000; 
                                          count_press = count_press_g;
                                count_press <= count_press_r;
                                end
                             else if(sw[7]==1)
                             begin
                               change_col[0] = 16'b00000_000000_00000;
                             change_col[1] = 16'b00000_000001_00001;
                                                      change_col[2] = 16'b00000_000011_00011;
                                                       change_col[3] = 16'b00000_000111_00111;
                                                        change_col[4] = 16'b00000_001111_01111;
                                                         change_col[5] = 16'b00000_011111_11111; 
                                            count_press = count_press_g;
                            end else
                            begin
                         //    change_col[0] = 16'b00000_000000_00001;
                           change_col[0] = 16'b00000_000000_00000;
                            change_col[1] = 16'b00001_000000_00001;
                                         change_col[2] = 16'b00000_000000_00011;
                                          change_col[3] = 16'b00000_000000_00111;
                                           change_col[4] = 16'b00000_000000_01111;
                                            change_col[5] = 16'b00000_000000_11111; 
                                            count_press <= count_press_b;
                            end
                            
                            end
                            end
                    
           
        
        always @ (posedge clk6p25m)
        begin
        if (state == 2)
        begin
            // control led and seg display
            if (sw[3]==0)
            begin
            if (sw[0] == 1) // led change wrt encoded_audio
            begin
                case (encoded_audio_slow)
                    5'd0:
                begin
                    led <= 16'b0000_0000_0000_0000;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b11000000; end // 0
                    endcase
                end
                
                5'd1:
                begin
                    led <= 16'b0000_0000_0000_0001;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b11111001; end // 1       
                    endcase
                end
                
                5'd2:
                begin
                    led <= 16'b0000_0000_0000_0011;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10100100; end // 2    
                    endcase
                end  
                
                5'd3:
                begin
                    led <= 16'b0000_0000_0000_0111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10110000; end // 3       
                    endcase 
                end
                
                5'd4:
                begin
                    led <= 16'b0000_0000_0000_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10011001; end // 4       
                    endcase 
                end
                
                5'd5:
                begin
                    led <= 16'b0000_0000_0001_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10010010; end // 5       
                    endcase 
                end
                
                5'd6:
                begin
                    led <= 16'b0000_0000_0011_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10000010; end // 6      
                    endcase 
                end
                
                5'd7:
                begin
                    led <= 16'b0000_0000_0111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b11111000; end // 7       
                    endcase 
                end
                
                5'd8:
                begin
                    led <= 16'b0000_0000_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10000000; end // 8       
                    endcase 
                end                                                
            
                5'd9:
                begin
                    led <= 16'b0000_0001_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                        3'd3: begin an <= 4'b1110; seg <= 8'b10010000; end // 9       
                    endcase 
                end 
               
                5'd10:
                begin
                    led <= 16'b0000_0011_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b11000000; end // 0       
                    endcase 
                end 
        
                5'd11:
                begin
                    led <= 16'b0000_0111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b11111001; end // 1       
                    endcase 
                end                                             
            
                5'd12:
                begin
                    led <= 16'b0000_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10100100; end // 2       
                    endcase 
                end    
                
                5'd13:
                begin
                    led <= 16'b0001_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10110000; end // 3       
                    endcase 
                end    
                
                5'd14:
                begin
                    led <= 16'b0011_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10011001; end // 4       
                    endcase 
                end    
                
                5'd15:
                begin
                    led <= 16'b0111_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10010010; end // 5       
                    endcase 
                end    
               
                5'd16:
                begin
                    led <= 16'b1111_1111_1111_1111;
                    case (count)
                        3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                        3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                        3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                        3'd3: begin an <= 4'b1110; seg <= 8'b10000010; end // 6       
                    endcase 
                end
                
                endcase        
            end else // led change wrt peak
            begin
                case (encoded_peak)
                    5'd0:
                    begin
                        led <= 16'b0000_0000_0000_0000;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b11000000; end // 0
                        endcase
                    end
                    
                    5'd1:
                    begin
                        led <= 16'b0000_0000_0000_0001;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b11111001; end // 1       
                        endcase
                    end
                    
                    5'd2:
                    begin
                        led <= 16'b0000_0000_0000_0011;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b10100100; end // 2    
                        endcase
                    end  
                    
                    5'd3:
                    begin
                        led <= 16'b0000_0000_0000_0111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b10110000; end // 3       
                        endcase 
                    end
                    
                    5'd4:
                    begin
                        led <= 16'b0000_0000_0000_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b10011001; end // 4       
                        endcase 
                    end
                    
                    5'd5:
                    begin
                        led <= 16'b0000_0000_0001_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11000111; end // L
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b10010010; end // 5       
                        endcase 
                    end
                    
                    5'd6:
                    begin
                        led <= 16'b0000_0000_0011_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b10000010; end // 6      
                        endcase 
                    end
                    
                    5'd7:
                    begin
                        led <= 16'b0000_0000_0111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b11111000; end // 7       
                        endcase 
                    end
                    
                    5'd8:
                    begin
                        led <= 16'b0000_0000_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b10000000; end // 8       
                        endcase 
                    end                                                
                
                    5'd9:
                    begin
                        led <= 16'b0000_0001_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111111; end
                            3'd3: begin an <= 4'b1110; seg <= 8'b10010000; end // 9       
                        endcase 
                    end 
                   
                    5'd10:
                    begin
                        led <= 16'b0000_0011_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                            3'd3: begin an <= 4'b1110; seg <= 8'b11000000; end // 0       
                        endcase 
                    end 
        
                    5'd11:
                    begin
                        led <= 16'b0000_0111_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b11101010; end // M
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                            3'd3: begin an <= 4'b1110; seg <= 8'b11111001; end // 1       
                        endcase 
                    end                                             
                
                    5'd12:
                    begin
                        led <= 16'b0000_1111_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                            3'd3: begin an <= 4'b1110; seg <= 8'b10100100; end // 2       
                        endcase 
                    end    
                    
                    5'd13:
                    begin
                        led <= 16'b0001_1111_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                            3'd3: begin an <= 4'b1110; seg <= 8'b10110000; end // 3       
                        endcase 
                    end    
                    
                    5'd14:
                    begin
                        led <= 16'b0011_1111_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                            3'd3: begin an <= 4'b1110; seg <= 8'b10011001; end // 4       
                        endcase 
                    end    
                    
                    5'd15:
                    begin
                        led <= 16'b0111_1111_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                            3'd3: begin an <= 4'b1110; seg <= 8'b10010010; end // 5       
                        endcase 
                    end    
                   
                    5'd16:
                    begin
                        led <= 16'b1111_1111_1111_1111;
                        case (count)
                            3'd0: begin an <= 4'b0111; seg <= 8'b10001001; end // H
                            3'd1: begin an <= 4'b1011; seg <= 8'b11111111; end
                            3'd2: begin an <= 4'b1101; seg <= 8'b11111001; end // 1
                            3'd3: begin an <= 4'b1110; seg <= 8'b10000010; end // 6       
                        endcase 
                    end                
        
                endcase  
             
            end  
          
        
            // control oled
                    if (sw[2] == 0)
                    begin
                        if (sw[1] == 1 )
                        begin
                      //  if (((y > 65 - wave[0]) && (x == 0)) || ((y > 65 - wave[1]) && (x == 1)) || ((y > 65 - wave[2]) && (x == 2)) || ((y > 65 - wave[3]) && (x == 3)) || ((y > 65 - wave[4]) && (x == 4)) || ((y > 65 - wave[5]) && (x == 5)) || ((y > 65 - wave[6]) && (x == 6)) || ((y > 65 - wave[7]) && (x == 7)) || ((y > 65 - wave[8]) && (x == 8)) || ((y > 65 - wave[9]) && (x == 9)) || ((y > 65 - wave[10]) && (x == 10)) || ((y > 65 - wave[11]) && (x == 11)) || ((y > 65 - wave[12]) && (x == 12)) || ((y > 65 - wave[13]) && (x == 13)) || ((y > 65 - wave[14]) && (x == 14)) || ((y > 65 - wave[15]) && (x == 15)) || ((y > 65 - wave[16]) && (x == 16)) || ((y > 65 - wave[17]) && (x == 17)) || ((y > 65 - wave[18]) && (x == 18)) || ((y > 65 - wave[19]) && (x == 19)) || ((y > 65 - wave[20]) && (x == 20)) || ((y > 65 - wave[21]) && (x == 21)) || ((y > 65 - wave[22]) && (x == 22)) || ((y > 65 - wave[23]) && (x == 23)) || ((y > 65 - wave[24]) && (x == 24)) || ((y > 65 - wave[25]) && (x == 25)) || ((y > 65 - wave[26]) && (x == 26)) || ((y > 65 - wave[27]) && (x == 27)) || ((y > 65 - wave[28]) && (x == 28)) || ((y > 65 - wave[29]) && (x == 29)) || ((y > 65 - wave[30]) && (x == 30)) || ((y > 65 - wave[31]) && (x == 31)) || ((y > 65 - wave[32]) && (x == 32)) || ((y > 65 - wave[33]) && (x == 33)) || ((y > 65 - wave[34]) && (x == 34)) || ((y > 65 - wave[35]) && (x == 35)) || ((y > 65 - wave[36]) && (x == 36)) || ((y > 65 - wave[37]) && (x == 37)) || ((y > 65 - wave[38]) && (x == 38)) || ((y > 65 - wave[39]) && (x == 39)) || ((y > 65 - wave[40]) && (x == 40)) || ((y > 65 - wave[41]) && (x == 41)) || ((y > 65 - wave[42]) && (x == 42)) || ((y > 65 - wave[43]) && (x == 43)) || ((y > 65 - wave[44]) && (x == 44)) || ((y > 65 - wave[45]) && (x == 45)) || ((y > 65 - wave[46]) && (x == 46)) || ((y > 65 - wave[47]) && (x == 47)) || ((y > 65 - wave[48]) && (x == 48)) || ((y > 65 - wave[49]) && (x == 49)) || ((y > 65 - wave[50]) && (x == 50)) || ((y > 65 - wave[51]) && (x == 51)) || ((y > 65 - wave[52]) && (x == 52)) || ((y > 65 - wave[53]) && (x == 53)) || ((y > 65 - wave[54]) && (x == 54)) || ((y > 65 - wave[55]) && (x == 55)) || ((y > 65 - wave[56]) && (x == 56)) || ((y > 65 - wave[57]) && (x == 57)) || ((y > 65 - wave[58]) && (x == 58)) || ((y > 65 - wave[59]) && (x == 59)) || ((y > 65 - wave[60]) && (x == 60)) || ((y > 65 - wave[61]) && (x == 61)) || ((y > 65 - wave[62]) && (x == 62)) || ((y > 65 - wave[63]) && (x == 63)) || ((y > 65 - wave[64]) && (x == 64)) || ((y > 65 - wave[65]) && (x == 65)) || ((y > 65 - wave[66]) && (x == 66)) || ((y > 65 - wave[67]) && (x == 67)) || ((y > 65 - wave[68]) && (x == 68)) || ((y > 65 - wave[69]) && (x == 69)) || ((y > 65 - wave[70]) && (x == 70)) || ((y > 65 - wave[71]) && (x == 71)) || ((y > 65 - wave[72]) && (x == 72)) || ((y > 65 - wave[73]) && (x == 73)) || ((y > 65 - wave[74]) && (x == 74)) || ((y > 65 - wave[75]) && (x == 75)) || ((y > 65 - wave[76]) && (x == 76)) || ((y > 65 - wave[77]) && (x == 77)) || ((y > 65 - wave[78]) && (x == 78)) || ((y > 65 - wave[79]) && (x == 79)) || ((y > 65 - wave[80]) && (x == 80)) || ((y > 65 - wave[81]) && (x == 81)) || ((y > 65 - wave[82]) && (x == 82)) || ((y > 65 - wave[83]) && (x == 83)) || ((y > 65 - wave[84]) && (x == 84)) || ((y > 65 - wave[85]) && (x == 85)) || ((y > 65 - wave[86]) && (x == 86)) || ((y > 65 - wave[87]) && (x == 87)) || ((y > 65 - wave[88]) && (x == 88)) || ((y > 65 - wave[89]) && (x == 89)) || ((y > 65 - wave[90]) && (x == 90)) || ((y > 65 - wave[91]) && (x == 91)) || ((y > 65 - wave[92]) && (x == 92)) || ((y > 65 - wave[93]) && (x == 93)) || ((y > 65 - wave[94]) && (x == 94)) || ((y > 65 - wave[95]) && (x == 95)) )
                       // if (((y > 31 - wave[0]) && (x == 0)) || ((y > 31 - wave[1]) && (x == 1)) || ((y > 31 - wave[2]) && (x == 2)) || ((y > 31 - wave[3]) && (x == 3)) || ((y > 31 - wave[4]) && (x == 4)) || ((y > 31 - wave[5]) && (x == 5)) || ((y > 31 - wave[6]) && (x == 6)) || ((y > 31 - wave[7]) && (x == 7)) || ((y > 31 - wave[8]) && (x == 8)) || ((y > 31 - wave[9]) && (x == 9)) || ((y > 31 - wave[10]) && (x == 10)) || ((y > 31 - wave[11]) && (x == 11)) || ((y > 31 - wave[12]) && (x == 12)) || ((y > 31 - wave[13]) && (x == 13)) || ((y > 31 - wave[14]) && (x == 14)) || ((y > 31 - wave[15]) && (x == 15)) || ((y > 31 - wave[16]) && (x == 16)) || ((y > 31 - wave[17]) && (x == 17)) || ((y > 31 - wave[18]) && (x == 18)) || ((y > 31 - wave[19]) && (x == 19)) || ((y > 31 - wave[20]) && (x == 20)) || ((y > 31 - wave[21]) && (x == 21)) || ((y > 31 - wave[22]) && (x == 22)) || ((y > 31 - wave[23]) && (x == 23)) || ((y > 31 - wave[24]) && (x == 24)) || ((y > 31 - wave[25]) && (x == 25)) || ((y > 31 - wave[26]) && (x == 26)) || ((y > 31 - wave[27]) && (x == 27)) || ((y > 31 - wave[28]) && (x == 28)) || ((y > 31 - wave[29]) && (x == 29)) || ((y > 31 - wave[30]) && (x == 30)) || ((y > 31 - wave[31]) && (x == 31)) || ((y > 31 - wave[32]) && (x == 32)) || ((y > 31 - wave[33]) && (x == 33)) || ((y > 31 - wave[34]) && (x == 34)) || ((y > 31 - wave[35]) && (x == 35)) || ((y > 31 - wave[36]) && (x == 36)) || ((y > 31 - wave[37]) && (x == 37)) || ((y > 31 - wave[38]) && (x == 38)) || ((y > 31 - wave[39]) && (x == 39)) || ((y > 31 - wave[40]) && (x == 40)) || ((y > 31 - wave[41]) && (x == 41)) || ((y > 31 - wave[42]) && (x == 42)) || ((y > 31 - wave[43]) && (x == 43)) || ((y > 31 - wave[44]) && (x == 44)) || ((y > 31 - wave[45]) && (x == 45)) || ((y > 31 - wave[46]) && (x == 46)) || ((y > 31 - wave[47]) && (x == 47)) || ((y > 31 - wave[48]) && (x == 48)) || ((y > 31 - wave[49]) && (x == 49)) || ((y > 31 - wave[50]) && (x == 50)) || ((y > 31 - wave[51]) && (x == 51)) || ((y > 31 - wave[52]) && (x == 52)) || ((y > 31 - wave[53]) && (x == 53)) || ((y > 31 - wave[54]) && (x == 54)) || ((y > 31 - wave[55]) && (x == 55)) || ((y > 31 - wave[56]) && (x == 56)) || ((y > 31 - wave[57]) && (x == 57)) || ((y > 31 - wave[58]) && (x == 58)) || ((y > 31 - wave[59]) && (x == 59)) || ((y > 31 - wave[60]) && (x == 60)) || ((y > 31 - wave[61]) && (x == 61)) || ((y > 31 - wave[62]) && (x == 62)) || ((y > 31 - wave[63]) && (x == 63)) || ((y > 31 - wave[64]) && (x == 64)) || ((y > 31 - wave[65]) && (x == 65)) || ((y > 31 - wave[66]) && (x == 66)) || ((y > 31 - wave[67]) && (x == 67)) || ((y > 31 - wave[68]) && (x == 68)) || ((y > 31 - wave[69]) && (x == 69)) || ((y > 31 - wave[70]) && (x == 70)) || ((y > 31 - wave[71]) && (x == 71)) || ((y > 31 - wave[72]) && (x == 72)) || ((y > 31 - wave[73]) && (x == 73)) || ((y > 31 - wave[74]) && (x == 74)) || ((y > 31 - wave[75]) && (x == 75)) || ((y > 31 - wave[76]) && (x == 76)) || ((y > 31 - wave[77]) && (x == 77)) || ((y > 31 - wave[78]) && (x == 78)) || ((y > 31 - wave[79]) && (x == 79)) || ((y > 31 - wave[80]) && (x == 80)) || ((y > 31 - wave[81]) && (x == 81)) || ((y > 31 - wave[82]) && (x == 82)) || ((y > 31 - wave[83]) && (x == 83)) || ((y > 31 - wave[84]) && (x == 84)) || ((y > 31 - wave[85]) && (x == 85)) || ((y > 31 - wave[86]) && (x == 86)) || ((y > 31 - wave[87]) && (x == 87)) || ((y > 31 - wave[88]) && (x == 88)) || ((y > 31 - wave[89]) && (x == 89)) || ((y > 31 - wave[90]) && (x == 90)) || ((y > 31 - wave[91]) && (x == 91)) || ((y > 31 - wave[92]) && (x == 92)) || ((y > 31 - wave[93]) && (x == 93)) || ((y > 31 - wave[94]) && (x == 94)) || ((y > 31 - wave[95]) && (x == 95)) )
                        if (((y > 65 - visual_peak[0]) && (x == 0)) || ((y > 65 - visual_peak[1]) && (x == 1)) || ((y > 65 - visual_peak[2]) && (x == 2)) || ((y > 65 - visual_peak[3]) && (x == 3)) || ((y > 65 - visual_peak[4]) && (x == 4)) || ((y > 65 - visual_peak[5]) && (x == 5)) || ((y > 65 - visual_peak[6]) && (x == 6)) || ((y > 65 - visual_peak[7]) && (x == 7)) || ((y > 65 - visual_peak[8]) && (x == 8)) || ((y > 65 - visual_peak[9]) && (x == 9)) || ((y > 65 - visual_peak[10]) && (x == 10)) || ((y > 65 - visual_peak[11]) && (x == 11)) || ((y > 65 - visual_peak[12]) && (x == 12)) || ((y > 65 - visual_peak[13]) && (x == 13)) || ((y > 65 - visual_peak[14]) && (x == 14)) || ((y > 65 - visual_peak[15]) && (x == 15)) || ((y > 65 - visual_peak[16]) && (x == 16)) || ((y > 65 - visual_peak[17]) && (x == 17)) || ((y > 65 - visual_peak[18]) && (x == 18)) || ((y > 65 - visual_peak[19]) && (x == 19)) || ((y > 65 - visual_peak[20]) && (x == 20)) || ((y > 65 - visual_peak[21]) && (x == 21)) || ((y > 65 - visual_peak[22]) && (x == 22)) || ((y > 65 - visual_peak[23]) && (x == 23)) || ((y > 65 - visual_peak[24]) && (x == 24)) || ((y > 65 - visual_peak[25]) && (x == 25)) || ((y > 65 - visual_peak[26]) && (x == 26)) || ((y > 65 - visual_peak[27]) && (x == 27)) || ((y > 65 - visual_peak[28]) && (x == 28)) || ((y > 65 - visual_peak[29]) && (x == 29)) || ((y > 65 - visual_peak[30]) && (x == 30)) || ((y > 65 - visual_peak[31]) && (x == 31)) || ((y > 65 - visual_peak[32]) && (x == 32)) || ((y > 65 - visual_peak[33]) && (x == 33)) || ((y > 65 - visual_peak[34]) && (x == 34)) || ((y > 65 - visual_peak[35]) && (x == 35)) || ((y > 65 - visual_peak[36]) && (x == 36)) || ((y > 65 - visual_peak[37]) && (x == 37)) || ((y > 65 - visual_peak[38]) && (x == 38)) || ((y > 65 - visual_peak[39]) && (x == 39)) || ((y > 65 - visual_peak[40]) && (x == 40)) || ((y > 65 - visual_peak[41]) && (x == 41)) || ((y > 65 - visual_peak[42]) && (x == 42)) || ((y > 65 - visual_peak[43]) && (x == 43)) || ((y > 65 - visual_peak[44]) && (x == 44)) || ((y > 65 - visual_peak[45]) && (x == 45)) || ((y > 65 - visual_peak[46]) && (x == 46)) || ((y > 65 - visual_peak[47]) && (x == 47)) || ((y > 65 - visual_peak[48]) && (x == 48)) || ((y > 65 - visual_peak[49]) && (x == 49)) || ((y > 65 - visual_peak[50]) && (x == 50)) || ((y > 65 - visual_peak[51]) && (x == 51)) || ((y > 65 - visual_peak[52]) && (x == 52)) || ((y > 65 - visual_peak[53]) && (x == 53)) || ((y > 65 - visual_peak[54]) && (x == 54)) || ((y > 65 - visual_peak[55]) && (x == 55)) || ((y > 65 - visual_peak[56]) && (x == 56)) || ((y > 65 - visual_peak[57]) && (x == 57)) || ((y > 65 - visual_peak[58]) && (x == 58)) || ((y > 65 - visual_peak[59]) && (x == 59)) || ((y > 65 - visual_peak[60]) && (x == 60)) || ((y > 65 - visual_peak[61]) && (x == 61)) || ((y > 65 - visual_peak[62]) && (x == 62)) || ((y > 65 - visual_peak[63]) && (x == 63)) || ((y > 65 - visual_peak[64]) && (x == 64)) || ((y > 65 - visual_peak[65]) && (x == 65)) || ((y > 65 - visual_peak[66]) && (x == 66)) || ((y > 65 - visual_peak[67]) && (x == 67)) || ((y > 65 - visual_peak[68]) && (x == 68)) || ((y > 65 - visual_peak[69]) && (x == 69)) || ((y > 65 - visual_peak[70]) && (x == 70)) || ((y > 65 - visual_peak[71]) && (x == 71)) || ((y > 65 - visual_peak[72]) && (x == 72)) || ((y > 65 - visual_peak[73]) && (x == 73)) || ((y > 65 - visual_peak[74]) && (x == 74)) || ((y > 65 - visual_peak[75]) && (x == 75)) || ((y > 65 - visual_peak[76]) && (x == 76)) || ((y > 65 - visual_peak[77]) && (x == 77)) || ((y > 65 - visual_peak[78]) && (x == 78)) || ((y > 65 - visual_peak[79]) && (x == 79)) || ((y > 65 - visual_peak[80]) && (x == 80)) || ((y > 65 - visual_peak[81]) && (x == 81)) || ((y > 65 - visual_peak[82]) && (x == 82)) || ((y > 65 - visual_peak[83]) && (x == 83)) || ((y > 65 - visual_peak[84]) && (x == 84)) || ((y > 65 - visual_peak[85]) && (x == 85)) || ((y > 65 - visual_peak[86]) && (x == 86)) || ((y > 65 - visual_peak[87]) && (x == 87)) || ((y > 65 - visual_peak[88]) && (x == 88)) || ((y > 65 - visual_peak[89]) && (x == 89)) || ((y > 65 - visual_peak[90]) && (x == 90)) || ((y > 65 - visual_peak[91]) && (x == 91)) || ((y > 65 - visual_peak[92]) && (x == 92)) || ((y > 65 - visual_peak[93]) && (x == 93)) || ((y > 65 - visual_peak[94]) && (x == 94)) || ((y > 65 - visual_peak[95]) && (x == 95)) )
            
                                oled_data <= wave_color[color];
                                      if(check == 1)begin
                              
                                
                                      if ((x == 21 && y == 6) || (x == 22 && y == 6) || (x == 23 && y == 6) || (x == 21 && y == 7) || (x == 24 && y == 7) || (x == 21 && y == 8) || (x == 24 && y == 8) || (x == 21 && y == 9) || (x == 24 && y == 9) || (x == 21 && y == 10) || (x == 22 && y == 10) || (x == 23 && y == 10) || (x == 26 && y == 6) || (x == 26 && y == 7) || (x == 26 && y == 8) || (x == 26 && y == 9) || (x == 26 && y == 10) || (x == 28 && y == 6) || (x == 29 && y == 6) || (x == 30 && y == 6) || (x == 31 && y == 6) || (x == 28 && y == 7) || (x == 28 && y == 8) || (x == 29 && y == 8) || (x == 30 && y == 8) || (x == 31 && y == 8) || (x == 31 && y == 9) || (x == 28 && y == 10) || (x == 29 && y == 10) || (x == 30 && y == 10) || (x == 31 && y == 10) || (x == 33 && y == 6) || (x == 34 && y == 6) || (x == 35 && y == 6) || (x == 33 && y == 7) || (x == 36 && y == 7) || (x == 33 && y == 8) || (x == 34 && y == 8) || (x == 35 && y == 8) || (x == 33 && y == 9) || (x == 33 && y == 10) || (x == 38 && y == 6) || (x == 38 && y == 7) || (x == 38 && y == 8) || (x == 38 && y == 9) || (x == 38 && y == 10) || (x == 39 && y == 10) || (x == 40 && y == 10) || (x == 41 && y == 10) || (x == 44 && y == 6) || (x == 45 && y == 6) || (x == 43 && y == 7) || (x == 46 && y == 7) || (x == 43 && y == 8) || (x == 44 && y == 8) || (x == 45 && y == 8) || (x == 46 && y == 8) || (x == 43 && y == 9) || (x == 46 && y == 9) || (x == 43 && y == 10) || (x == 46 && y == 10) || (x == 48 && y == 6) || (x == 50 && y == 6) || (x == 48 && y == 7) || (x == 50 && y == 7) || (x == 49 && y == 8) || (x == 49 && y == 9) || (x == 49 && y == 10) || (x == 55 && y == 6) || (x == 56 && y == 6) || (x == 54 && y == 7) || (x == 57 && y == 7) || (x == 54 && y == 8) || (x == 55 && y == 8) || (x == 56 && y == 8) || (x == 57 && y == 8) || (x == 54 && y == 9) || (x == 57 && y == 9) || (x == 54 && y == 10) || (x == 57 && y == 10) || (x == 59 && y == 6) || (x == 62 && y == 6) || (x == 59 && y == 7) || (x == 62 && y == 7) || (x == 59 && y == 8) || (x == 62 && y == 8) || (x == 59 && y == 9) || (x == 62 && y == 9) || (x == 60 && y == 10) || (x == 61 && y == 10) || (x == 64 && y == 6) || (x == 65 && y == 6) || (x == 66 && y == 6) || (x == 64 && y == 7) || (x == 67 && y == 7) || (x == 64 && y == 8) || (x == 67 && y == 8) || (x == 64 && y == 9) || (x == 67 && y == 9) || (x == 64 && y == 10) || (x == 65 && y == 10) || (x == 66 && y == 10) || (x == 69 && y == 6) || (x == 69 && y == 7) || (x == 69 && y == 8) || (x == 69 && y == 9) || (x == 69 && y == 10) || (x == 72 && y == 6) || (x == 73 && y == 6) || (x == 71 && y == 7) || (x == 74 && y == 7) || (x == 71 && y == 8) || (x == 74 && y == 8) || (x == 71 && y == 9) || (x == 74 && y == 9) || (x == 72 && y == 10) || (x == 73 && y == 10))
                                                    oled_data = 16'b10001_100000_00111; // "audio capture"
                                                   else oled_data = 0;
                                        end
                                        else  if ((x == 26 && y == 5) || (x == 27 && y == 5) || (x == 25 && y == 6) || (x == 28 && y == 6) || (x == 25 && y == 7) || (x == 26 && y == 7) || (x == 27 && y == 7) || (x == 28 && y == 7) || (x == 25 && y == 8) || (x == 28 && y == 8) || (x == 25 && y == 9) || (x == 28 && y == 9) || (x == 30 && y == 5) || (x == 33 && y == 5) || (x == 30 && y == 6) || (x == 33 && y == 6) || (x == 30 && y == 7) || (x == 33 && y == 7) || (x == 30 && y == 8) || (x == 33 && y == 8) || (x == 31 && y == 9) || (x == 32 && y == 9) || (x == 35 && y == 5) || (x == 36 && y == 5) || (x == 37 && y == 5) || (x == 35 && y == 6) || (x == 38 && y == 6) || (x == 35 && y == 7) || (x == 38 && y == 7) || (x == 35 && y == 8) || (x == 38 && y == 8) || (x == 35 && y == 9) || (x == 36 && y == 9) || (x == 37 && y == 9) || (x == 40 && y == 5) || (x == 40 && y == 6) || (x == 40 && y == 7) || (x == 40 && y == 8) || (x == 40 && y == 9) || (x == 43 && y == 5) || (x == 44 && y == 5) || (x == 42 && y == 6) || (x == 45 && y == 6) || (x == 42 && y == 7) || (x == 45 && y == 7) || (x == 42 && y == 8) || (x == 45 && y == 8) || (x == 43 && y == 9) || (x == 44 && y == 9) || (x == 51 && y == 5) || (x == 52 && y == 5) || (x == 50 && y == 6) || (x == 53 && y == 6) || (x == 50 && y == 7) || (x == 50 && y == 8) || (x == 53 && y == 8) || (x == 51 && y == 9) || (x == 52 && y == 9) || (x == 56 && y == 5) || (x == 57 && y == 5) || (x == 55 && y == 6) || (x == 58 && y == 6) || (x == 55 && y == 7) || (x == 56 && y == 7) || (x == 57 && y == 7) || (x == 58 && y == 7) || (x == 55 && y == 8) || (x == 58 && y == 8) || (x == 55 && y == 9) || (x == 58 && y == 9) || (x == 60 && y == 5) || (x == 61 && y == 5) || (x == 62 && y == 5) || (x == 60 && y == 6) || (x == 63 && y == 6) || (x == 60 && y == 7) || (x == 61 && y == 7) || (x == 62 && y == 7) || (x == 60 && y == 8) || (x == 60 && y == 9) || (x == 65 && y == 5) || (x == 66 && y == 5) || (x == 67 && y == 5) || (x == 66 && y == 6) || (x == 66 && y == 7) || (x == 66 && y == 8) || (x == 66 && y == 9) || (x == 69 && y == 5) || (x == 72 && y == 5) || (x == 69 && y == 6) || (x == 72 && y == 6) || (x == 69 && y == 7) || (x == 72 && y == 7) || (x == 69 && y == 8) || (x == 72 && y == 8) || (x == 70 && y == 9) || (x == 71 && y == 9) || (x == 74 && y == 5) || (x == 75 && y == 5) || (x == 76 && y == 5) || (x == 74 && y == 6) || (x == 77 && y == 6) || (x == 74 && y == 7) || (x == 75 && y == 7) || (x == 76 && y == 7) || (x == 74 && y == 8) || (x == 76 && y == 8) || (x == 74 && y == 9) || (x == 77 && y == 9) || (x == 79 && y == 5) || (x == 80 && y == 5) || (x == 81 && y == 5) || (x == 82 && y == 5) || (x == 79 && y == 6) || (x == 79 && y == 7) || (x == 80 && y == 7) || (x == 81 && y == 7) || (x == 82 && y == 7) || (x == 79 && y == 8) || (x == 79 && y == 9) || (x == 80 && y == 9) || (x == 81 && y == 9) || (x == 82 && y == 9))   
                                           oled_data = 0 ;
                                           
                                      else oled_data = 0;
                       
                        end else begin // (sw[1] == 0)
                       if (visual_peak[32] > 5 || visual_peak[63] > 5) // quite face
                       begin
                        if (((pixel_index >= 0) && (pixel_index <= 231)) || ((pixel_index >= 248) && (pixel_index <= 322)) || ((pixel_index >= 350) && (pixel_index <= 414)) || ((pixel_index >= 449) && (pixel_index <= 507)) || ((pixel_index >= 548) && (pixel_index <= 600)) || ((pixel_index >= 647) && (pixel_index <= 694)) || ((pixel_index >= 745) && (pixel_index <= 788)) || ((pixel_index >= 843) && (pixel_index <= 883)) || ((pixel_index >= 941) && (pixel_index <= 977)) || ((pixel_index >= 1038) && (pixel_index <= 1072)) || ((pixel_index >= 1136) && (pixel_index <= 1166)) || ((pixel_index >= 1233) && (pixel_index <= 1261)) || ((pixel_index >= 1330) && (pixel_index <= 1356)) || ((pixel_index >= 1427) && (pixel_index <= 1451)) || ((pixel_index >= 1524) && (pixel_index <= 1546)) || ((pixel_index >= 1621) && (pixel_index <= 1642)) || ((pixel_index >= 1718) && (pixel_index <= 1737)) || ((pixel_index >= 1814) && (pixel_index <= 1832)) || ((pixel_index >= 1911) && (pixel_index <= 1928)) || ((pixel_index >= 2008) && (pixel_index <= 2023)) || ((pixel_index >= 2104) && (pixel_index <= 2119)) || ((pixel_index >= 2201) && (pixel_index <= 2214)) || ((pixel_index >= 2297) && (pixel_index <= 2310)) || ((pixel_index >= 2393) && (pixel_index <= 2406)) || ((pixel_index >= 2489) && (pixel_index <= 2501)) || ((pixel_index >= 2586) && (pixel_index <= 2597)) || ((pixel_index >= 2682) && (pixel_index <= 2693)) || ((pixel_index >= 2778) && (pixel_index <= 2789)) || ((pixel_index >= 2874) && (pixel_index <= 2885)) || ((pixel_index >= 2970) && (pixel_index <= 2981)) || ((pixel_index >= 3066) && (pixel_index <= 3077)) || ((pixel_index >= 3162) && (pixel_index <= 3173)) || ((pixel_index >= 3258) && (pixel_index <= 3270)) || ((pixel_index >= 3353) && (pixel_index <= 3366)) || ((pixel_index >= 3449) && (pixel_index <= 3462)) || ((pixel_index >= 3545) && (pixel_index <= 3559)) || ((pixel_index >= 3640) && (pixel_index <= 3655)) || ((pixel_index >= 3736) && (pixel_index <= 3752)) || ((pixel_index >= 3832) && (pixel_index <= 3848)) || ((pixel_index >= 3927) && (pixel_index <= 3945)) || ((pixel_index >= 4022) && (pixel_index <= 4042)) || ((pixel_index >= 4118) && (pixel_index <= 4138)) || ((pixel_index >= 4213) && (pixel_index <= 4235)) || ((pixel_index >= 4308) && (pixel_index <= 4332)) || ((pixel_index >= 4403) && (pixel_index <= 4429)) || ((pixel_index >= 4498) && (pixel_index <= 4526)) || ((pixel_index >= 4593) && (pixel_index <= 4624)) || ((pixel_index >= 4688) && (pixel_index <= 4721)) || ((pixel_index >= 4782) && (pixel_index <= 4819)) || ((pixel_index >= 4877) && (pixel_index <= 4916)) || ((pixel_index >= 4971) && (pixel_index <= 5015)) || ((pixel_index >= 5065) && (pixel_index <= 5113)) || ((pixel_index >= 5159) && (pixel_index <= 5211)) || ((pixel_index >= 5255) && (pixel_index <= 5308)) || ((pixel_index >= 5351) && (pixel_index <= 5404)) || ((pixel_index >= 5447) && (pixel_index <= 5501)) || ((pixel_index >= 5541) && (pixel_index <= 5597)) || ((pixel_index >= 5628) && (pixel_index <= 5694)) || ((pixel_index >= 5721) && (pixel_index <= 5791)) || ((pixel_index >= 5815) && (pixel_index <= 5889)) || ((pixel_index >= 5909) && (pixel_index <= 5988)) || (pixel_index >= 6002) && (pixel_index <= 6143)) oled_data = 16'b1111011110011110;
                       else if (pixel_index == 232 || pixel_index == 247 || pixel_index == 349 || pixel_index == 1135 || pixel_index == 2007 || pixel_index == 2502 || pixel_index == 3174 || pixel_index == 3831 || pixel_index == 4117 || pixel_index == 4527 || pixel_index == 4687 || pixel_index == 4876) oled_data = 16'b1010010100010100;
                       else if (pixel_index == 429 || pixel_index == 434 || pixel_index == 1418 || pixel_index == 1456 || pixel_index == 1551 || pixel_index == 1666 || pixel_index == 1713 || pixel_index == 1764 || pixel_index == 1851 || pixel_index == 1978 || pixel_index == 2053 || pixel_index == 2243 || pixel_index == 2389 || pixel_index == 3019 || pixel_index == 3217 || pixel_index == 3313 || pixel_index == 3409 || pixel_index == 3445 || pixel_index == 3505 || pixel_index == 3513 || pixel_index == 3601 || pixel_index == 3697 || pixel_index == 3756 || pixel_index == 3793 || pixel_index == 3889 || pixel_index == 3985 || pixel_index == 4072 || pixel_index == 4113 || pixel_index == 4143 || pixel_index == 4240 || pixel_index == 4269 || pixel_index == 4381 || pixel_index == 4398 || pixel_index == 4478 || pixel_index == 4660 || pixel_index == 4682 || pixel_index == 4829 || pixel_index == 4944 || pixel_index == 5132 || pixel_index == 5233 || pixel_index == 5418 || pixel_index == 5423 || pixel_index == 5505 || pixel_index == 5602 || pixel_index == 5807) oled_data = 16'b0101001010000000;
                       else if (((pixel_index >= 430) && (pixel_index <= 433)) || pixel_index == 795 || pixel_index == 836 || ((pixel_index >= 992) && (pixel_index <= 993)) || pixel_index == 1023 || pixel_index == 1093 || pixel_index == 1130 || pixel_index == 1189 || pixel_index == 1370 || pixel_index == 1413 || pixel_index == 1422 || pixel_index == 1519 || pixel_index == 1616 || pixel_index == 1693 || pixel_index == 1787 || pixel_index == 2074 || pixel_index == 2123 || pixel_index == 2268 || pixel_index == 3319 || pixel_index == 3563 || pixel_index == 3605 || pixel_index == 4071 || pixel_index == 4161 || pixel_index == 4208 || pixel_index == 4303 || pixel_index == 4351 || pixel_index == 4355 || pixel_index == 4374 || pixel_index == 4466 || pixel_index == 4470 || pixel_index == 4727 || pixel_index == 4839 || pixel_index == 4858 || pixel_index == 5024 || pixel_index == 5312 || pixel_index == 5428 || pixel_index == 5433 || pixel_index == 5515 || pixel_index == 5613 || pixel_index == 5799) oled_data = 16'b1010010100000000;
                       else if (pixel_index == 435) oled_data = 16'b0101000000000000;
                       else if (((pixel_index >= 517) && (pixel_index <= 538)) || ((pixel_index >= 609) && (pixel_index <= 638)) || ((pixel_index >= 702) && (pixel_index <= 737)) || ((pixel_index >= 796) && (pixel_index <= 835)) || ((pixel_index >= 889) && (pixel_index <= 934)) || ((pixel_index >= 983) && (pixel_index <= 991)) || ((pixel_index >= 994) && (pixel_index <= 1022)) || ((pixel_index >= 1024) && (pixel_index <= 1032)) || ((pixel_index >= 1078) && (pixel_index <= 1082)) || ((pixel_index >= 1094) && (pixel_index <= 1114)) || ((pixel_index >= 1125) && (pixel_index <= 1129)) || ((pixel_index >= 1172) && (pixel_index <= 1175)) || ((pixel_index >= 1190) && (pixel_index <= 1210)) || ((pixel_index >= 1224) && (pixel_index <= 1227)) || ((pixel_index >= 1267) && (pixel_index <= 1270)) || ((pixel_index >= 1277) && (pixel_index <= 1314)) || ((pixel_index >= 1321) && (pixel_index <= 1324)) || ((pixel_index >= 1362) && (pixel_index <= 1365)) || ((pixel_index >= 1371) && (pixel_index <= 1412)) || ((pixel_index >= 1419) && (pixel_index <= 1421)) || ((pixel_index >= 1457) && (pixel_index <= 1460)) || ((pixel_index >= 1465) && (pixel_index <= 1510)) || ((pixel_index >= 1515) && (pixel_index <= 1518)) || ((pixel_index >= 1552) && (pixel_index <= 1556)) || ((pixel_index >= 1560) && (pixel_index <= 1607)) || ((pixel_index >= 1611) && (pixel_index <= 1615)) || ((pixel_index >= 1647) && (pixel_index <= 1661)) || ((pixel_index >= 1667) && (pixel_index <= 1692)) || ((pixel_index >= 1698) && (pixel_index <= 1712)) || ((pixel_index >= 1742) && (pixel_index <= 1755)) || ((pixel_index >= 1765) && (pixel_index <= 1786)) || ((pixel_index >= 1796) && (pixel_index <= 1809)) || ((pixel_index >= 1837) && (pixel_index <= 1850)) || ((pixel_index >= 1861) && (pixel_index <= 1882)) || ((pixel_index >= 1893) && (pixel_index <= 1906)) || ((pixel_index >= 1933) && (pixel_index <= 1946)) || ((pixel_index >= 1958) && (pixel_index <= 1977)) || ((pixel_index >= 1989) && (pixel_index <= 2003)) || ((pixel_index >= 2028) && (pixel_index <= 2042)) || ((pixel_index >= 2054) && (pixel_index <= 2073)) || ((pixel_index >= 2085) && (pixel_index <= 2099)) || ((pixel_index >= 2124) && (pixel_index <= 2139)) || ((pixel_index >= 2149) && (pixel_index <= 2170)) || ((pixel_index >= 2180) && (pixel_index <= 2196)) || ((pixel_index >= 2219) && (pixel_index <= 2236)) || ((pixel_index >= 2244) && (pixel_index <= 2267)) || ((pixel_index >= 2275) && (pixel_index <= 2292)) || ((pixel_index >= 2315) && (pixel_index <= 2388)) || ((pixel_index >= 2410) && (pixel_index <= 2485)) || ((pixel_index >= 2506) && (pixel_index <= 2581)) || ((pixel_index >= 2602) && (pixel_index <= 2677)) || ((pixel_index >= 2698) && (pixel_index <= 2773)) || ((pixel_index >= 2794) && (pixel_index <= 2869)) || ((pixel_index >= 2890) && (pixel_index <= 2924)) || ((pixel_index >= 2931) && (pixel_index <= 2965)) || ((pixel_index >= 2986) && (pixel_index <= 3018)) || ((pixel_index >= 3028) && (pixel_index <= 3061)) || ((pixel_index >= 3082) && (pixel_index <= 3114)) || ((pixel_index >= 3119) && (pixel_index <= 3120)) || ((pixel_index >= 3125) && (pixel_index <= 3157)) || ((pixel_index >= 3178) && (pixel_index <= 3210)) || ((pixel_index >= 3214) && (pixel_index <= 3216)) || ((pixel_index >= 3221) && (pixel_index <= 3253)) || ((pixel_index >= 3274) && (pixel_index <= 3299)) || ((pixel_index >= 3304) && (pixel_index <= 3306)) || ((pixel_index >= 3310) && (pixel_index <= 3312)) || ((pixel_index >= 3317) && (pixel_index <= 3318)) || ((pixel_index >= 3324) && (pixel_index <= 3349)) || ((pixel_index >= 3371) && (pixel_index <= 3395)) || ((pixel_index >= 3406) && (pixel_index <= 3408)) || ((pixel_index >= 3420) && (pixel_index <= 3444)) || ((pixel_index >= 3467) && (pixel_index <= 3493)) || ((pixel_index >= 3502) && (pixel_index <= 3504)) || ((pixel_index >= 3514) && (pixel_index <= 3540)) || ((pixel_index >= 3564) && (pixel_index <= 3593)) || ((pixel_index >= 3598) && (pixel_index <= 3600)) || ((pixel_index >= 3606) && (pixel_index <= 3636)) || ((pixel_index >= 3660) && (pixel_index <= 3690)) || ((pixel_index >= 3694) && (pixel_index <= 3696)) || ((pixel_index >= 3701) && (pixel_index <= 3731)) || ((pixel_index >= 3757) && (pixel_index <= 3786)) || ((pixel_index >= 3790) && (pixel_index <= 3792)) || ((pixel_index >= 3797) && (pixel_index <= 3827)) || ((pixel_index >= 3853) && (pixel_index <= 3882)) || ((pixel_index >= 3886) && (pixel_index <= 3888)) || ((pixel_index >= 3893) && (pixel_index <= 3922)) || ((pixel_index >= 3950) && (pixel_index <= 3978)) || ((pixel_index >= 3982) && (pixel_index <= 3984)) || ((pixel_index >= 3989) && (pixel_index <= 4017)) || ((pixel_index >= 4047) && (pixel_index <= 4070)) || ((pixel_index >= 4085) && (pixel_index <= 4112)) || ((pixel_index >= 4144) && (pixel_index <= 4160)) || ((pixel_index >= 4185) && (pixel_index <= 4207)) || ((pixel_index >= 4241) && (pixel_index <= 4255)) || ((pixel_index >= 4284) && (pixel_index <= 4302)) || ((pixel_index >= 4338) && (pixel_index <= 4350)) || ((pixel_index >= 4356) && (pixel_index <= 4373)) || ((pixel_index >= 4382) && (pixel_index <= 4397)) || ((pixel_index >= 4435) && (pixel_index <= 4446)) || ((pixel_index >= 4451) && (pixel_index <= 4465)) || ((pixel_index >= 4471) && (pixel_index <= 4473)) || ((pixel_index >= 4479) && (pixel_index <= 4492)) || ((pixel_index >= 4532) && (pixel_index <= 4542)) || ((pixel_index >= 4546) && (pixel_index <= 4555)) || pixel_index == 4561 || ((pixel_index >= 4568) && (pixel_index <= 4570)) || ((pixel_index >= 4575) && (pixel_index <= 4587)) || ((pixel_index >= 4630) && (pixel_index <= 4637)) || ((pixel_index >= 4642) && (pixel_index <= 4651)) || ((pixel_index >= 4658) && (pixel_index <= 4659)) || ((pixel_index >= 4665) && (pixel_index <= 4667)) || ((pixel_index >= 4671) && (pixel_index <= 4681)) || ((pixel_index >= 4728) && (pixel_index <= 4733)) || ((pixel_index >= 4738) && (pixel_index <= 4750)) || ((pixel_index >= 4755) && (pixel_index <= 4757)) || ((pixel_index >= 4762) && (pixel_index <= 4763)) || ((pixel_index >= 4767) && (pixel_index <= 4776)) || ((pixel_index >= 4825) && (pixel_index <= 4828)) || ((pixel_index >= 4833) && (pixel_index <= 4838)) || ((pixel_index >= 4842) && (pixel_index <= 4847)) || ((pixel_index >= 4852) && (pixel_index <= 4854)) || ((pixel_index >= 4863) && (pixel_index <= 4873)) || ((pixel_index >= 4921) && (pixel_index <= 4924)) || ((pixel_index >= 4929) && (pixel_index <= 4934)) || ((pixel_index >= 4939) && (pixel_index <= 4943)) || ((pixel_index >= 4948) && (pixel_index <= 4950)) || ((pixel_index >= 4964) && (pixel_index <= 4969)) || ((pixel_index >= 5016) && (pixel_index <= 5020)) || ((pixel_index >= 5025) && (pixel_index <= 5031)) || ((pixel_index >= 5036) && (pixel_index <= 5040)) || ((pixel_index >= 5045) && (pixel_index <= 5046)) || ((pixel_index >= 5062) && (pixel_index <= 5063)) || ((pixel_index >= 5114) && (pixel_index <= 5116)) || ((pixel_index >= 5120) && (pixel_index <= 5128)) || ((pixel_index >= 5133) && (pixel_index <= 5136)) || ((pixel_index >= 5216) && (pixel_index <= 5224)) || ((pixel_index >= 5229) && (pixel_index <= 5232)) || ((pixel_index >= 5241) && (pixel_index <= 5251)) || ((pixel_index >= 5313) && (pixel_index <= 5321)) || ((pixel_index >= 5326) && (pixel_index <= 5328)) || ((pixel_index >= 5333) && (pixel_index <= 5346)) || ((pixel_index >= 5409) && (pixel_index <= 5417)) || ((pixel_index >= 5429) && (pixel_index <= 5432)) || ((pixel_index >= 5506) && (pixel_index <= 5514)) || ((pixel_index >= 5524) && (pixel_index <= 5526)) || ((pixel_index >= 5603) && (pixel_index <= 5612)) || ((pixel_index >= 5618) && (pixel_index <= 5620)) || ((pixel_index >= 5700) && (pixel_index <= 5714)) || (pixel_index >= 5800) && (pixel_index <= 5806)) oled_data = 16'b1111010100000000;
                       else if (pixel_index == 601 || pixel_index == 940 || pixel_index == 1167 || pixel_index == 1717 || pixel_index == 4139 || pixel_index == 4917 || pixel_index == 5446 || pixel_index == 5792 || pixel_index == 6001) oled_data = 16'b0101001010001010;
                       else if (pixel_index == 1176 || pixel_index == 1932) oled_data = 16'b1010001010000000;
                       else if (pixel_index == 2200 || pixel_index == 4970) oled_data = 16'b1010011110010100;
                       else if (pixel_index == 5064) oled_data = 16'b1111011110010100;
                       else if (pixel_index == 5212) oled_data = 16'b1111011110001010;
                       else oled_data = 0;
                       
                      end else //smile face
                                                     
                       if (((pixel_index >= 0) && (pixel_index <= 40)) || ((pixel_index >= 55) && (pixel_index <= 129)) || ((pixel_index >= 158) && (pixel_index <= 221)) || ((pixel_index >= 258) && (pixel_index <= 314)) || ((pixel_index >= 357) && (pixel_index <= 407)) || ((pixel_index >= 456) && (pixel_index <= 501)) || ((pixel_index >= 555) && (pixel_index <= 594)) || ((pixel_index >= 653) && (pixel_index <= 689)) || ((pixel_index >= 751) && (pixel_index <= 783)) || ((pixel_index >= 848) && (pixel_index <= 877)) || ((pixel_index >= 946) && (pixel_index <= 972)) || ((pixel_index >= 1043) && (pixel_index <= 1067)) || ((pixel_index >= 1141) && (pixel_index <= 1161)) || ((pixel_index >= 1238) && (pixel_index <= 1256)) || ((pixel_index >= 1335) && (pixel_index <= 1351)) || ((pixel_index >= 1432) && (pixel_index <= 1446)) || ((pixel_index >= 1529) && (pixel_index <= 1541)) || ((pixel_index >= 1626) && (pixel_index <= 1637)) || ((pixel_index >= 1723) && (pixel_index <= 1732)) || ((pixel_index >= 1820) && (pixel_index <= 1827)) || ((pixel_index >= 1916) && (pixel_index <= 1923)) || ((pixel_index >= 2013) && (pixel_index <= 2018)) || ((pixel_index >= 2109) && (pixel_index <= 2113)) || ((pixel_index >= 2206) && (pixel_index <= 2209)) || ((pixel_index >= 2302) && (pixel_index <= 2305)) || ((pixel_index >= 2399) && (pixel_index <= 2400)) || ((pixel_index >= 2495) && (pixel_index <= 2496)) || ((pixel_index >= 2591) && (pixel_index <= 2592)) || pixel_index == 2688 || pixel_index == 3360 || pixel_index == 3456 || pixel_index == 3552 || ((pixel_index >= 3647) && (pixel_index <= 3648)) || ((pixel_index >= 3743) && (pixel_index <= 3745)) || ((pixel_index >= 3839) && (pixel_index <= 3841)) || ((pixel_index >= 3934) && (pixel_index <= 3937)) || ((pixel_index >= 4030) && (pixel_index <= 4034)) || ((pixel_index >= 4125) && (pixel_index <= 4130)) || ((pixel_index >= 4221) && (pixel_index <= 4227)) || ((pixel_index >= 4316) && (pixel_index <= 4324)) || ((pixel_index >= 4412) && (pixel_index <= 4420)) || ((pixel_index >= 4507) && (pixel_index <= 4517)) || ((pixel_index >= 4602) && (pixel_index <= 4614)) || ((pixel_index >= 4697) && (pixel_index <= 4711)) || ((pixel_index >= 4792) && (pixel_index <= 4808)) || ((pixel_index >= 4887) && (pixel_index <= 4905)) || ((pixel_index >= 4982) && (pixel_index <= 5002)) || ((pixel_index >= 5077) && (pixel_index <= 5100)) || ((pixel_index >= 5172) && (pixel_index <= 5197)) || ((pixel_index >= 5266) && (pixel_index <= 5295)) || ((pixel_index >= 5361) && (pixel_index <= 5392)) || ((pixel_index >= 5455) && (pixel_index <= 5490)) || ((pixel_index >= 5549) && (pixel_index <= 5588)) || ((pixel_index >= 5643) && (pixel_index <= 5687)) || ((pixel_index >= 5737) && (pixel_index <= 5785)) || ((pixel_index >= 5830) && (pixel_index <= 5885)) || ((pixel_index >= 5923) && (pixel_index <= 5985)) || ((pixel_index >= 6015) && (pixel_index <= 6087)) || (pixel_index >= 6105) && (pixel_index <= 6143)) oled_data = 16'b1111011110011110;
                      else if (pixel_index == 41 || pixel_index == 54 || pixel_index == 130 || pixel_index == 554 || pixel_index == 595 || pixel_index == 2114 || pixel_index == 2687 || pixel_index == 3551 || pixel_index == 6014 || pixel_index == 6104) oled_data = 16'b1010010100010100;
                      else if (pixel_index == 157 || pixel_index == 750 || pixel_index == 1542 || pixel_index == 2398 || pixel_index == 2784 || pixel_index == 3264 || pixel_index == 3938 || pixel_index == 4131 || pixel_index == 4421 || pixel_index == 5171 || pixel_index == 5360 || pixel_index == 5736 || pixel_index == 5786 || pixel_index == 5922) oled_data = 16'b0101001010001010;
                      else if (pixel_index == 237 || pixel_index == 242 || pixel_index == 324 || pixel_index == 508 || pixel_index == 646 || pixel_index == 1038 || pixel_index == 2361 || pixel_index == 2438 || pixel_index == 2500 || pixel_index == 2629 || pixel_index == 2972 || pixel_index == 3086 || pixel_index == 3567 || pixel_index == 3739 || pixel_index == 3845 || pixel_index == 4038 || pixel_index == 4312 || pixel_index == 4328 || pixel_index == 4540 || pixel_index == 4584 || pixel_index == 4767 || pixel_index == 4952 || pixel_index == 5230 || pixel_index == 5233 || pixel_index == 5795 || pixel_index == 5898 || pixel_index == 5909) oled_data = 16'b0101001010000000;
                      else if (pixel_index == 238 || pixel_index == 241 || pixel_index == 1641 || pixel_index == 1758 || pixel_index == 2142 || pixel_index == 3182 || pixel_index == 3260 || pixel_index == 4345 || pixel_index == 5105 || pixel_index == 5234) oled_data = 16'b1010001010000000;
                      else if (((pixel_index >= 239) && (pixel_index <= 240)) || ((pixel_index >= 325) && (pixel_index <= 347)) || ((pixel_index >= 416) && (pixel_index <= 447)) || ((pixel_index >= 509) && (pixel_index <= 547)) || ((pixel_index >= 602) && (pixel_index <= 645)) || ((pixel_index >= 695) && (pixel_index <= 744)) || ((pixel_index >= 789) && (pixel_index <= 842)) || ((pixel_index >= 883) && (pixel_index <= 940)) || ((pixel_index >= 978) && (pixel_index <= 1037)) || ((pixel_index >= 1072) && (pixel_index <= 1135)) || ((pixel_index >= 1167) && (pixel_index <= 1184)) || ((pixel_index >= 1189) && (pixel_index <= 1210)) || ((pixel_index >= 1215) && (pixel_index <= 1232)) || ((pixel_index >= 1262) && (pixel_index <= 1279)) || ((pixel_index >= 1286) && (pixel_index <= 1306)) || ((pixel_index >= 1312) && (pixel_index <= 1330)) || ((pixel_index >= 1356) && (pixel_index <= 1375)) || ((pixel_index >= 1382) && (pixel_index <= 1401)) || ((pixel_index >= 1409) && (pixel_index <= 1427)) || ((pixel_index >= 1451) && (pixel_index <= 1470)) || ((pixel_index >= 1479) && (pixel_index <= 1497)) || ((pixel_index >= 1505) && (pixel_index <= 1524)) || ((pixel_index >= 1546) && (pixel_index <= 1566)) || ((pixel_index >= 1575) && (pixel_index <= 1592)) || ((pixel_index >= 1601) && (pixel_index <= 1621)) || ((pixel_index >= 1642) && (pixel_index <= 1662)) || ((pixel_index >= 1671) && (pixel_index <= 1688)) || ((pixel_index >= 1698) && (pixel_index <= 1718)) || ((pixel_index >= 1737) && (pixel_index <= 1757)) || ((pixel_index >= 1767) && (pixel_index <= 1784)) || ((pixel_index >= 1794) && (pixel_index <= 1815)) || ((pixel_index >= 1832) && (pixel_index <= 1853)) || ((pixel_index >= 1863) && (pixel_index <= 1880)) || ((pixel_index >= 1890) && (pixel_index <= 1911)) || ((pixel_index >= 1927) && (pixel_index <= 1949)) || ((pixel_index >= 1959) && (pixel_index <= 1976)) || ((pixel_index >= 1986) && (pixel_index <= 2008)) || ((pixel_index >= 2023) && (pixel_index <= 2045)) || ((pixel_index >= 2055) && (pixel_index <= 2072)) || ((pixel_index >= 2082) && (pixel_index <= 2105)) || ((pixel_index >= 2118) && (pixel_index <= 2141)) || ((pixel_index >= 2151) && (pixel_index <= 2168)) || ((pixel_index >= 2178) && (pixel_index <= 2201)) || ((pixel_index >= 2214) && (pixel_index <= 2238)) || ((pixel_index >= 2247) && (pixel_index <= 2264)) || ((pixel_index >= 2274) && (pixel_index <= 2298)) || ((pixel_index >= 2309) && (pixel_index <= 2334)) || ((pixel_index >= 2343) && (pixel_index <= 2360)) || ((pixel_index >= 2369) && (pixel_index <= 2394)) || ((pixel_index >= 2405) && (pixel_index <= 2430)) || ((pixel_index >= 2439) && (pixel_index <= 2457)) || ((pixel_index >= 2465) && (pixel_index <= 2490)) || ((pixel_index >= 2501) && (pixel_index <= 2527)) || ((pixel_index >= 2534) && (pixel_index <= 2553)) || ((pixel_index >= 2561) && (pixel_index <= 2587)) || ((pixel_index >= 2596) && (pixel_index <= 2623)) || ((pixel_index >= 2630) && (pixel_index <= 2650)) || ((pixel_index >= 2656) && (pixel_index <= 2683)) || ((pixel_index >= 2692) && (pixel_index <= 2720)) || ((pixel_index >= 2725) && (pixel_index <= 2747)) || ((pixel_index >= 2751) && (pixel_index <= 2779)) || ((pixel_index >= 2788) && (pixel_index <= 2875)) || ((pixel_index >= 2884) && (pixel_index <= 2971)) || ((pixel_index >= 2980) && (pixel_index <= 3068)) || ((pixel_index >= 3076) && (pixel_index <= 3085)) || ((pixel_index >= 3090) && (pixel_index <= 3149)) || ((pixel_index >= 3154) && (pixel_index <= 3164)) || ((pixel_index >= 3172) && (pixel_index <= 3181)) || ((pixel_index >= 3186) && (pixel_index <= 3245)) || ((pixel_index >= 3250) && (pixel_index <= 3259)) || ((pixel_index >= 3268) && (pixel_index <= 3278)) || ((pixel_index >= 3282) && (pixel_index <= 3341)) || ((pixel_index >= 3346) && (pixel_index <= 3355)) || ((pixel_index >= 3364) && (pixel_index <= 3374)) || ((pixel_index >= 3378) && (pixel_index <= 3437)) || ((pixel_index >= 3441) && (pixel_index <= 3451)) || ((pixel_index >= 3460) && (pixel_index <= 3470)) || ((pixel_index >= 3475) && (pixel_index <= 3533)) || ((pixel_index >= 3537) && (pixel_index <= 3547)) || ((pixel_index >= 3556) && (pixel_index <= 3566)) || ((pixel_index >= 3571) && (pixel_index <= 3628)) || ((pixel_index >= 3633) && (pixel_index <= 3643)) || ((pixel_index >= 3653) && (pixel_index <= 3663)) || ((pixel_index >= 3667) && (pixel_index <= 3724)) || ((pixel_index >= 3728) && (pixel_index <= 3738)) || ((pixel_index >= 3749) && (pixel_index <= 3759)) || ((pixel_index >= 3764) && (pixel_index <= 3819)) || ((pixel_index >= 3824) && (pixel_index <= 3834)) || ((pixel_index >= 3846) && (pixel_index <= 3856)) || ((pixel_index >= 3861) && (pixel_index <= 3915)) || ((pixel_index >= 3919) && (pixel_index <= 3930)) || ((pixel_index >= 3942) && (pixel_index <= 3953)) || ((pixel_index >= 3957) && (pixel_index <= 4010)) || ((pixel_index >= 4015) && (pixel_index <= 4025)) || ((pixel_index >= 4039) && (pixel_index <= 4049)) || ((pixel_index >= 4054) && (pixel_index <= 4105)) || ((pixel_index >= 4110) && (pixel_index <= 4121)) || ((pixel_index >= 4135) && (pixel_index <= 4146)) || ((pixel_index >= 4151) && (pixel_index <= 4200)) || ((pixel_index >= 4205) && (pixel_index <= 4216)) || ((pixel_index >= 4232) && (pixel_index <= 4243)) || ((pixel_index >= 4248) && (pixel_index <= 4295)) || ((pixel_index >= 4300) && (pixel_index <= 4311)) || ((pixel_index >= 4329) && (pixel_index <= 4340)) || ((pixel_index >= 4346) && (pixel_index <= 4390)) || ((pixel_index >= 4395) && (pixel_index <= 4407)) || ((pixel_index >= 4425) && (pixel_index <= 4437)) || ((pixel_index >= 4443) && (pixel_index <= 4484)) || ((pixel_index >= 4490) && (pixel_index <= 4502)) || ((pixel_index >= 4522) && (pixel_index <= 4535)) || ((pixel_index >= 4541) && (pixel_index <= 4579)) || ((pixel_index >= 4585) && (pixel_index <= 4597)) || ((pixel_index >= 4619) && (pixel_index <= 4632)) || ((pixel_index >= 4638) && (pixel_index <= 4673)) || ((pixel_index >= 4679) && (pixel_index <= 4692)) || ((pixel_index >= 4716) && (pixel_index <= 4730)) || ((pixel_index >= 4737) && (pixel_index <= 4766)) || ((pixel_index >= 4773) && (pixel_index <= 4787)) || ((pixel_index >= 4813) && (pixel_index <= 4828)) || ((pixel_index >= 4836) && (pixel_index <= 4860)) || ((pixel_index >= 4867) && (pixel_index <= 4882)) || ((pixel_index >= 4911) && (pixel_index <= 4926)) || ((pixel_index >= 4936) && (pixel_index <= 4951)) || ((pixel_index >= 4961) && (pixel_index <= 4977)) || ((pixel_index >= 5008) && (pixel_index <= 5025)) || ((pixel_index >= 5054) && (pixel_index <= 5071)) || ((pixel_index >= 5106) && (pixel_index <= 5125)) || ((pixel_index >= 5146) && (pixel_index <= 5166)) || ((pixel_index >= 5203) && (pixel_index <= 5229)) || ((pixel_index >= 5235) && (pixel_index <= 5260)) || ((pixel_index >= 5301) && (pixel_index <= 5354)) || ((pixel_index >= 5399) && (pixel_index <= 5448)) || ((pixel_index >= 5497) && (pixel_index <= 5542)) || ((pixel_index >= 5596) && (pixel_index <= 5635)) || ((pixel_index >= 5695) && (pixel_index <= 5728)) || ((pixel_index >= 5796) && (pixel_index <= 5820)) || (pixel_index >= 5899) && (pixel_index <= 5908)) oled_data = 16'b1010010100000000;
                      else if (pixel_index == 878) oled_data = 16'b0000001010000000;
                      else if (pixel_index == 1478 || pixel_index == 1854 || pixel_index == 2046 || pixel_index == 2491 || (pixel_index >= 5231) && (pixel_index <= 5232)) oled_data = 16'b0101000000000000;
                      else if (pixel_index == 1819) oled_data = 16'b1010011110010100;
                      else if (pixel_index == 4411) oled_data = 16'b0101010100001010;
                      else oled_data = 0;
                                                
                        end
                                    
                    
                        
                    end else // sw[2] == 1 -> display the audio in the middle
                    begin
                     //  if (((y < 31 + wave[0]) && (y > 31 - wave[0]) && (x == 0)) || ((y < 31 + wave[1]) && (y > 31 - wave[1]) && (x == 1)) || ((y < 31 + wave[2]) && (y > 31 - wave[2]) && (x == 2)) || ((y < 31 + wave[3]) && (y > 31 - wave[3]) && (x == 3)) || ((y < 31 + wave[4]) && (y > 31 - wave[4]) && (x == 4)) || ((y < 31 + wave[5]) && (y > 31 - wave[5]) && (x == 5)) || ((y < 31 + wave[6]) && (y > 31 - wave[6]) && (x == 6)) || ((y < 31 + wave[7]) && (y > 31 - wave[7]) && (x == 7)) || ((y < 31 + wave[8]) && (y > 31 - wave[8]) && (x == 8)) || ((y < 31 + wave[9]) && (y > 31 - wave[9]) && (x == 9)) || ((y < 31 + wave[10]) && (y > 31 - wave[10]) && (x == 10)) || ((y < 31 + wave[11]) && (y > 31 - wave[11]) && (x == 11)) || ((y < 31 + wave[12]) && (y > 31 - wave[12]) && (x == 12)) || ((y < 31 + wave[13]) && (y > 31 - wave[13]) && (x == 13)) || ((y < 31 + wave[14]) && (y > 31 - wave[14]) && (x == 14)) || ((y < 31 + wave[15]) && (y > 31 - wave[15]) && (x == 15)) || ((y < 31 + wave[16]) && (y > 31 - wave[16]) && (x == 16)) || ((y < 31 + wave[17]) && (y > 31 - wave[17]) && (x == 17)) || ((y < 31 + wave[18]) && (y > 31 - wave[18]) && (x == 18)) || ((y < 31 + wave[19]) && (y > 31 - wave[19]) && (x == 19)) || ((y < 31 + wave[20]) && (y > 31 - wave[20]) && (x == 20)) || ((y < 31 + wave[21]) && (y > 31 - wave[21]) && (x == 21)) || ((y < 31 + wave[22]) && (y > 31 - wave[22]) && (x == 22)) || ((y < 31 + wave[23]) && (y > 31 - wave[23]) && (x == 23)) || ((y < 31 + wave[24]) && (y > 31 - wave[24]) && (x == 24)) || ((y < 31 + wave[25]) && (y > 31 - wave[25]) && (x == 25)) || ((y < 31 + wave[26]) && (y > 31 - wave[26]) && (x == 26)) || ((y < 31 + wave[27]) && (y > 31 - wave[27]) && (x == 27)) || ((y < 31 + wave[28]) && (y > 31 - wave[28]) && (x == 28)) || ((y < 31 + wave[29]) && (y > 31 - wave[29]) && (x == 29)) || ((y < 31 + wave[30]) && (y > 31 - wave[30]) && (x == 30)) || ((y < 31 + wave[31]) && (y > 31 - wave[31]) && (x == 31)) || ((y < 31 + wave[32]) && (y > 31 - wave[32]) && (x == 32)) || ((y < 31 + wave[33]) && (y > 31 - wave[33]) && (x == 33)) || ((y < 31 + wave[34]) && (y > 31 - wave[34]) && (x == 34)) || ((y < 31 + wave[35]) && (y > 31 - wave[35]) && (x == 35)) || ((y < 31 + wave[36]) && (y > 31 - wave[36]) && (x == 36)) || ((y < 31 + wave[37]) && (y > 31 - wave[37]) && (x == 37)) || ((y < 31 + wave[38]) && (y > 31 - wave[38]) && (x == 38)) || ((y < 31 + wave[39]) && (y > 31 - wave[39]) && (x == 39)) || ((y < 31 + wave[40]) && (y > 31 - wave[40]) && (x == 40)) || ((y < 31 + wave[41]) && (y > 31 - wave[41]) && (x == 41)) || ((y < 31 + wave[42]) && (y > 31 - wave[42]) && (x == 42)) || ((y < 31 + wave[43]) && (y > 31 - wave[43]) && (x == 43)) || ((y < 31 + wave[44]) && (y > 31 - wave[44]) && (x == 44)) || ((y < 31 + wave[45]) && (y > 31 - wave[45]) && (x == 45)) || ((y < 31 + wave[46]) && (y > 31 - wave[46]) && (x == 46)) || ((y < 31 + wave[47]) && (y > 31 - wave[47]) && (x == 47)) || ((y < 31 + wave[48]) && (y > 31 - wave[48]) && (x == 48)) || ((y < 31 + wave[49]) && (y > 31 - wave[49]) && (x == 49)) || ((y < 31 + wave[50]) && (y > 31 - wave[50]) && (x == 50)) || ((y < 31 + wave[51]) && (y > 31 - wave[51]) && (x == 51)) || ((y < 31 + wave[52]) && (y > 31 - wave[52]) && (x == 52)) || ((y < 31 + wave[53]) && (y > 31 - wave[53]) && (x == 53)) || ((y < 31 + wave[54]) && (y > 31 - wave[54]) && (x == 54)) || ((y < 31 + wave[55]) && (y > 31 - wave[55]) && (x == 55)) || ((y < 31 + wave[56]) && (y > 31 - wave[56]) && (x == 56)) || ((y < 31 + wave[57]) && (y > 31 - wave[57]) && (x == 57)) || ((y < 31 + wave[58]) && (y > 31 - wave[58]) && (x == 58)) || ((y < 31 + wave[59]) && (y > 31 - wave[59]) && (x == 59)) || ((y < 31 + wave[60]) && (y > 31 - wave[60]) && (x == 60)) || ((y < 31 + wave[61]) && (y > 31 - wave[61]) && (x == 61)) || ((y < 31 + wave[62]) && (y > 31 - wave[62]) && (x == 62)) || ((y < 31 + wave[63]) && (y > 31 - wave[63]) && (x == 63)) || ((y < 31 + wave[64]) && (y > 31 - wave[64]) && (x == 64)) || ((y < 31 + wave[65]) && (y > 31 - wave[65]) && (x == 65)) || ((y < 31 + wave[66]) && (y > 31 - wave[66]) && (x == 66)) || ((y < 31 + wave[67]) && (y > 31 - wave[67]) && (x == 67)) || ((y < 31 + wave[68]) && (y > 31 - wave[68]) && (x == 68)) || ((y < 31 + wave[69]) && (y > 31 - wave[69]) && (x == 69)) || ((y < 31 + wave[70]) && (y > 31 - wave[70]) && (x == 70)) || ((y < 31 + wave[71]) && (y > 31 - wave[71]) && (x == 71)) || ((y < 31 + wave[72]) && (y > 31 - wave[72]) && (x == 72)) || ((y < 31 + wave[73]) && (y > 31 - wave[73]) && (x == 73)) || ((y < 31 + wave[74]) && (y > 31 - wave[74]) && (x == 74)) || ((y < 31 + wave[75]) && (y > 31 - wave[75]) && (x == 75)) || ((y < 31 + wave[76]) && (y > 31 - wave[76]) && (x == 76)) || ((y < 31 + wave[77]) && (y > 31 - wave[77]) && (x == 77)) || ((y < 31 + wave[78]) && (y > 31 - wave[78]) && (x == 78)) || ((y < 31 + wave[79]) && (y > 31 - wave[79]) && (x == 79)) || ((y < 31 + wave[80]) && (y > 31 - wave[80]) && (x == 80)) || ((y < 31 + wave[81]) && (y > 31 - wave[81]) && (x == 81)) || ((y < 31 + wave[82]) && (y > 31 - wave[82]) && (x == 82)) || ((y < 31 + wave[83]) && (y > 31 - wave[83]) && (x == 83)) || ((y < 31 + wave[84]) && (y > 31 - wave[84]) && (x == 84)) || ((y < 31 + wave[85]) && (y > 31 - wave[85]) && (x == 85)) || ((y < 31 + wave[86]) && (y > 31 - wave[86]) && (x == 86)) || ((y < 31 + wave[87]) && (y > 31 - wave[87]) && (x == 87)) || ((y < 31 + wave[88]) && (y > 31 - wave[88]) && (x == 88)) || ((y < 31 + wave[89]) && (y > 31 - wave[89]) && (x == 89)) || ((y < 31 + wave[90]) && (y > 31 - wave[90]) && (x == 90)) || ((y < 31 + wave[91]) && (y > 31 - wave[91]) && (x == 91)) || ((y < 31 + wave[92]) && (y > 31 - wave[92]) && (x == 92)) || ((y < 31 + wave[93]) && (y > 31 - wave[93]) && (x == 93)) || ((y < 31 + wave[94]) && (y > 31 - wave[94]) && (x == 94)) || ((y < 31 + wave[95]) && (y > 31 - wave[95]) && (x == 95)))
                       if (((y < 31 + visual_peak[0]) && (y > 31 - visual_peak[0]) && (x == 0)) || ((y < 31 + visual_peak[1]) && (y > 31 - visual_peak[1]) && (x == 1)) || ((y < 31 + visual_peak[2]) && (y > 31 - visual_peak[2]) && (x == 2)) || ((y < 31 + visual_peak[3]) && (y > 31 - visual_peak[3]) && (x == 3)) || ((y < 31 + visual_peak[4]) && (y > 31 - visual_peak[4]) && (x == 4)) || ((y < 31 + visual_peak[5]) && (y > 31 - visual_peak[5]) && (x == 5)) || ((y < 31 + visual_peak[6]) && (y > 31 - visual_peak[6]) && (x == 6)) || ((y < 31 + visual_peak[7]) && (y > 31 - visual_peak[7]) && (x == 7)) || ((y < 31 + visual_peak[8]) && (y > 31 - visual_peak[8]) && (x == 8)) || ((y < 31 + visual_peak[9]) && (y > 31 - visual_peak[9]) && (x == 9)) || ((y < 31 + visual_peak[10]) && (y > 31 - visual_peak[10]) && (x == 10)) || ((y < 31 + visual_peak[11]) && (y > 31 - visual_peak[11]) && (x == 11)) || ((y < 31 + visual_peak[12]) && (y > 31 - visual_peak[12]) && (x == 12)) || ((y < 31 + visual_peak[13]) && (y > 31 - visual_peak[13]) && (x == 13)) || ((y < 31 + visual_peak[14]) && (y > 31 - visual_peak[14]) && (x == 14)) || ((y < 31 + visual_peak[15]) && (y > 31 - visual_peak[15]) && (x == 15)) || ((y < 31 + visual_peak[16]) && (y > 31 - visual_peak[16]) && (x == 16)) || ((y < 31 + visual_peak[17]) && (y > 31 - visual_peak[17]) && (x == 17)) || ((y < 31 + visual_peak[18]) && (y > 31 - visual_peak[18]) && (x == 18)) || ((y < 31 + visual_peak[19]) && (y > 31 - visual_peak[19]) && (x == 19)) || ((y < 31 + visual_peak[20]) && (y > 31 - visual_peak[20]) && (x == 20)) || ((y < 31 + visual_peak[21]) && (y > 31 - visual_peak[21]) && (x == 21)) || ((y < 31 + visual_peak[22]) && (y > 31 - visual_peak[22]) && (x == 22)) || ((y < 31 + visual_peak[23]) && (y > 31 - visual_peak[23]) && (x == 23)) || ((y < 31 + visual_peak[24]) && (y > 31 - visual_peak[24]) && (x == 24)) || ((y < 31 + visual_peak[25]) && (y > 31 - visual_peak[25]) && (x == 25)) || ((y < 31 + visual_peak[26]) && (y > 31 - visual_peak[26]) && (x == 26)) || ((y < 31 + visual_peak[27]) && (y > 31 - visual_peak[27]) && (x == 27)) || ((y < 31 + visual_peak[28]) && (y > 31 - visual_peak[28]) && (x == 28)) || ((y < 31 + visual_peak[29]) && (y > 31 - visual_peak[29]) && (x == 29)) || ((y < 31 + visual_peak[30]) && (y > 31 - visual_peak[30]) && (x == 30)) || ((y < 31 + visual_peak[31]) && (y > 31 - visual_peak[31]) && (x == 31)) || ((y < 31 + visual_peak[32]) && (y > 31 - visual_peak[32]) && (x == 32)) || ((y < 31 + visual_peak[33]) && (y > 31 - visual_peak[33]) && (x == 33)) || ((y < 31 + visual_peak[34]) && (y > 31 - visual_peak[34]) && (x == 34)) || ((y < 31 + visual_peak[35]) && (y > 31 - visual_peak[35]) && (x == 35)) || ((y < 31 + visual_peak[36]) && (y > 31 - visual_peak[36]) && (x == 36)) || ((y < 31 + visual_peak[37]) && (y > 31 - visual_peak[37]) && (x == 37)) || ((y < 31 + visual_peak[38]) && (y > 31 - visual_peak[38]) && (x == 38)) || ((y < 31 + visual_peak[39]) && (y > 31 - visual_peak[39]) && (x == 39)) || ((y < 31 + visual_peak[40]) && (y > 31 - visual_peak[40]) && (x == 40)) || ((y < 31 + visual_peak[41]) && (y > 31 - visual_peak[41]) && (x == 41)) || ((y < 31 + visual_peak[42]) && (y > 31 - visual_peak[42]) && (x == 42)) || ((y < 31 + visual_peak[43]) && (y > 31 - visual_peak[43]) && (x == 43)) || ((y < 31 + visual_peak[44]) && (y > 31 - visual_peak[44]) && (x == 44)) || ((y < 31 + visual_peak[45]) && (y > 31 - visual_peak[45]) && (x == 45)) || ((y < 31 + visual_peak[46]) && (y > 31 - visual_peak[46]) && (x == 46)) || ((y < 31 + visual_peak[47]) && (y > 31 - visual_peak[47]) && (x == 47)) || ((y < 31 + visual_peak[48]) && (y > 31 - visual_peak[48]) && (x == 48)) || ((y < 31 + visual_peak[49]) && (y > 31 - visual_peak[49]) && (x == 49)) || ((y < 31 + visual_peak[50]) && (y > 31 - visual_peak[50]) && (x == 50)) || ((y < 31 + visual_peak[51]) && (y > 31 - visual_peak[51]) && (x == 51)) || ((y < 31 + visual_peak[52]) && (y > 31 - visual_peak[52]) && (x == 52)) || ((y < 31 + visual_peak[53]) && (y > 31 - visual_peak[53]) && (x == 53)) || ((y < 31 + visual_peak[54]) && (y > 31 - visual_peak[54]) && (x == 54)) || ((y < 31 + visual_peak[55]) && (y > 31 - visual_peak[55]) && (x == 55)) || ((y < 31 + visual_peak[56]) && (y > 31 - visual_peak[56]) && (x == 56)) || ((y < 31 + visual_peak[57]) && (y > 31 - visual_peak[57]) && (x == 57)) || ((y < 31 + visual_peak[58]) && (y > 31 - visual_peak[58]) && (x == 58)) || ((y < 31 + visual_peak[59]) && (y > 31 - visual_peak[59]) && (x == 59)) || ((y < 31 + visual_peak[60]) && (y > 31 - visual_peak[60]) && (x == 60)) || ((y < 31 + visual_peak[61]) && (y > 31 - visual_peak[61]) && (x == 61)) || ((y < 31 + visual_peak[62]) && (y > 31 - visual_peak[62]) && (x == 62)) || ((y < 31 + visual_peak[63]) && (y > 31 - visual_peak[63]) && (x == 63)) || ((y < 31 + visual_peak[64]) && (y > 31 - visual_peak[64]) && (x == 64)) || ((y < 31 + visual_peak[65]) && (y > 31 - visual_peak[65]) && (x == 65)) || ((y < 31 + visual_peak[66]) && (y > 31 - visual_peak[66]) && (x == 66)) || ((y < 31 + visual_peak[67]) && (y > 31 - visual_peak[67]) && (x == 67)) || ((y < 31 + visual_peak[68]) && (y > 31 - visual_peak[68]) && (x == 68)) || ((y < 31 + visual_peak[69]) && (y > 31 - visual_peak[69]) && (x == 69)) || ((y < 31 + visual_peak[70]) && (y > 31 - visual_peak[70]) && (x == 70)) || ((y < 31 + visual_peak[71]) && (y > 31 - visual_peak[71]) && (x == 71)) || ((y < 31 + visual_peak[72]) && (y > 31 - visual_peak[72]) && (x == 72)) || ((y < 31 + visual_peak[73]) && (y > 31 - visual_peak[73]) && (x == 73)) || ((y < 31 + visual_peak[74]) && (y > 31 - visual_peak[74]) && (x == 74)) || ((y < 31 + visual_peak[75]) && (y > 31 - visual_peak[75]) && (x == 75)) || ((y < 31 + visual_peak[76]) && (y > 31 - visual_peak[76]) && (x == 76)) || ((y < 31 + visual_peak[77]) && (y > 31 - visual_peak[77]) && (x == 77)) || ((y < 31 + visual_peak[78]) && (y > 31 - visual_peak[78]) && (x == 78)) || ((y < 31 + visual_peak[79]) && (y > 31 - visual_peak[79]) && (x == 79)) || ((y < 31 + visual_peak[80]) && (y > 31 - visual_peak[80]) && (x == 80)) || ((y < 31 + visual_peak[81]) && (y > 31 - visual_peak[81]) && (x == 81)) || ((y < 31 + visual_peak[82]) && (y > 31 - visual_peak[82]) && (x == 82)) || ((y < 31 + visual_peak[83]) && (y > 31 - visual_peak[83]) && (x == 83)) || ((y < 31 + visual_peak[84]) && (y > 31 - visual_peak[84]) && (x == 84)) || ((y < 31 + visual_peak[85]) && (y > 31 - visual_peak[85]) && (x == 85)) || ((y < 31 + visual_peak[86]) && (y > 31 - visual_peak[86]) && (x == 86)) || ((y < 31 + visual_peak[87]) && (y > 31 - visual_peak[87]) && (x == 87)) || ((y < 31 + visual_peak[88]) && (y > 31 - visual_peak[88]) && (x == 88)) || ((y < 31 + visual_peak[89]) && (y > 31 - visual_peak[89]) && (x == 89)) || ((y < 31 + visual_peak[90]) && (y > 31 - visual_peak[90]) && (x == 90)) || ((y < 31 + visual_peak[91]) && (y > 31 - visual_peak[91]) && (x == 91)) || ((y < 31 + visual_peak[92]) && (y > 31 - visual_peak[92]) && (x == 92)) || ((y < 31 + visual_peak[93]) && (y > 31 - visual_peak[93]) && (x == 93)) || ((y < 31 + visual_peak[94]) && (y > 31 - visual_peak[94]) && (x == 94)) || ((y < 31 + visual_peak[95]) && (y > 31 - visual_peak[95]) && (x == 95)))
                                      oled_data <=  wave_color[color];
                                   else oled_data = 0 ;
                    
                    end 
                     end else
                       begin // if sw[3]==1
                          
                             if (((pixel_index >= 0) && (pixel_index <= 136)) || ((pixel_index >= 139) && (pixel_index <= 233)) || ((pixel_index >= 236) && (pixel_index <= 324)) || pixel_index == 330 || ((pixel_index >= 332) && (pixel_index <= 335)) || ((pixel_index >= 342) && (pixel_index <= 419)) || ((pixel_index >= 422) && (pixel_index <= 425)) || pixel_index == 429 || ((pixel_index >= 432) && (pixel_index <= 436)) || ((pixel_index >= 439) && (pixel_index <= 516)) || ((pixel_index >= 519) && (pixel_index <= 523)) || ((pixel_index >= 526) && (pixel_index <= 534)) || ((pixel_index >= 536) && (pixel_index <= 613)) || ((pixel_index >= 622) && (pixel_index <= 630)) || ((pixel_index >= 633) && (pixel_index <= 707)) || ((pixel_index >= 710) && (pixel_index <= 716)) || pixel_index == 718 || ((pixel_index >= 720) && (pixel_index <= 727)) || ((pixel_index >= 729) && (pixel_index <= 802)) || ((pixel_index >= 805) && (pixel_index <= 809)) || ((pixel_index >= 816) && (pixel_index <= 823)) || ((pixel_index >= 825) && (pixel_index <= 898)) || ((pixel_index >= 900) && (pixel_index <= 907)) || ((pixel_index >= 910) && (pixel_index <= 919)) || ((pixel_index >= 921) && (pixel_index <= 994)) || ((pixel_index >= 996) && (pixel_index <= 1015)) || ((pixel_index >= 1017) && (pixel_index <= 1090)) || ((pixel_index >= 1092) && (pixel_index <= 1111)) || ((pixel_index >= 1113) && (pixel_index <= 1114)) || ((pixel_index >= 1116) && (pixel_index <= 1186)) || ((pixel_index >= 1188) && (pixel_index <= 1207)) || ((pixel_index >= 1209) && (pixel_index <= 1210)) || ((pixel_index >= 1212) && (pixel_index <= 1282)) || ((pixel_index >= 1285) && (pixel_index <= 1297)) || ((pixel_index >= 1304) && (pixel_index <= 1306)) || ((pixel_index >= 1308) && (pixel_index <= 1376)) || ((pixel_index >= 1378) && (pixel_index <= 1379)) || pixel_index == 1381 || ((pixel_index >= 1388) && (pixel_index <= 1391)) || ((pixel_index >= 1394) && (pixel_index <= 1398)) || ((pixel_index >= 1401) && (pixel_index <= 1402)) || ((pixel_index >= 1404) && (pixel_index <= 1472)) || ((pixel_index >= 1474) && (pixel_index <= 1476)) || ((pixel_index >= 1479) && (pixel_index <= 1483)) || ((pixel_index >= 1485) && (pixel_index <= 1487)) || ((pixel_index >= 1489) && (pixel_index <= 1496)) || pixel_index == 1498 || pixel_index == 1500 || ((pixel_index >= 1505) && (pixel_index <= 1568)) || pixel_index == 1570 || ((pixel_index >= 1573) && (pixel_index <= 1580)) || pixel_index == 1582 || ((pixel_index >= 1584) && (pixel_index <= 1592)) || ((pixel_index >= 1598) && (pixel_index <= 1599)) || ((pixel_index >= 1603) && (pixel_index <= 1664)) || pixel_index == 1666 || ((pixel_index >= 1668) && (pixel_index <= 1676)) || ((pixel_index >= 1680) && (pixel_index <= 1687)) || pixel_index == 1689 || ((pixel_index >= 1693) && (pixel_index <= 1696)) || ((pixel_index >= 1699) && (pixel_index <= 1759)) || ((pixel_index >= 1763) && (pixel_index <= 1773)) || ((pixel_index >= 1776) && (pixel_index <= 1783)) || pixel_index == 1788 || ((pixel_index >= 1794) && (pixel_index <= 1852)) || ((pixel_index >= 1856) && (pixel_index <= 1857)) || pixel_index == 1859 || ((pixel_index >= 1862) && (pixel_index <= 1869)) || ((pixel_index >= 1871) && (pixel_index <= 1880)) || ((pixel_index >= 1884) && (pixel_index <= 1887)) || ((pixel_index >= 1890) && (pixel_index <= 1947)) || ((pixel_index >= 1950) && (pixel_index <= 1953)) || ((pixel_index >= 1957) && (pixel_index <= 1965)) || ((pixel_index >= 1968) && (pixel_index <= 1985)) || ((pixel_index >= 1987) && (pixel_index <= 2042)) || ((pixel_index >= 2044) && (pixel_index <= 2048)) || ((pixel_index >= 2051) && (pixel_index <= 2061)) || ((pixel_index >= 2064) && (pixel_index <= 2081)) || ((pixel_index >= 2084) && (pixel_index <= 2138)) || ((pixel_index >= 2140) && (pixel_index <= 2158)) || ((pixel_index >= 2160) && (pixel_index <= 2177)) || ((pixel_index >= 2180) && (pixel_index <= 2233)) || ((pixel_index >= 2236) && (pixel_index <= 2254)) || ((pixel_index >= 2256) && (pixel_index <= 2273)) || ((pixel_index >= 2276) && (pixel_index <= 2329)) || ((pixel_index >= 2331) && (pixel_index <= 2350)) || ((pixel_index >= 2352) && (pixel_index <= 2369)) || ((pixel_index >= 2372) && (pixel_index <= 2425)) || ((pixel_index >= 2428) && (pixel_index <= 2431)) || ((pixel_index >= 2436) && (pixel_index <= 2446)) || ((pixel_index >= 2448) && (pixel_index <= 2452)) || ((pixel_index >= 2454) && (pixel_index <= 2460)) || pixel_index == 2464 || ((pixel_index >= 2467) && (pixel_index <= 2522)) || pixel_index == 2525 || ((pixel_index >= 2529) && (pixel_index <= 2530)) || ((pixel_index >= 2534) && (pixel_index <= 2536)) || ((pixel_index >= 2544) && (pixel_index <= 2547)) || ((pixel_index >= 2549) && (pixel_index <= 2553)) || ((pixel_index >= 2562) && (pixel_index <= 2615)) || ((pixel_index >= 2617) && (pixel_index <= 2619)) || ((pixel_index >= 2622) && (pixel_index <= 2628)) || ((pixel_index >= 2630) && (pixel_index <= 2631)) || ((pixel_index >= 2633) && (pixel_index <= 2638)) || ((pixel_index >= 2641) && (pixel_index <= 2642)) || ((pixel_index >= 2644) && (pixel_index <= 2648)) || ((pixel_index >= 2651) && (pixel_index <= 2657)) || ((pixel_index >= 2660) && (pixel_index <= 2710)) || pixel_index == 2715 || ((pixel_index >= 2717) && (pixel_index <= 2725)) || ((pixel_index >= 2729) && (pixel_index <= 2735)) || ((pixel_index >= 2746) && (pixel_index <= 2754)) || ((pixel_index >= 2757) && (pixel_index <= 2803)) || ((pixel_index >= 2807) && (pixel_index <= 2809)) || ((pixel_index >= 2812) && (pixel_index <= 2813)) || ((pixel_index >= 2815) && (pixel_index <= 2821)) || ((pixel_index >= 2824) && (pixel_index <= 2832)) || ((pixel_index >= 2836) && (pixel_index <= 2840)) || ((pixel_index >= 2842) && (pixel_index <= 2851)) || ((pixel_index >= 2853) && (pixel_index <= 2898)) || ((pixel_index >= 2901) && (pixel_index <= 2905)) || pixel_index == 2909 || ((pixel_index >= 2911) && (pixel_index <= 2918)) || ((pixel_index >= 2921) && (pixel_index <= 2926)) || pixel_index == 2929 || ((pixel_index >= 2933) && (pixel_index <= 2934)) || ((pixel_index >= 2938) && (pixel_index <= 2947)) || ((pixel_index >= 2952) && (pixel_index <= 2995)) || pixel_index == 3003 || ((pixel_index >= 3007) && (pixel_index <= 3015)) || ((pixel_index >= 3017) && (pixel_index <= 3023)) || ((pixel_index >= 3027) && (pixel_index <= 3028)) || ((pixel_index >= 3032) && (pixel_index <= 3040)) || ((pixel_index >= 3042) && (pixel_index <= 3043)) || ((pixel_index >= 3046) && (pixel_index <= 3092)) || ((pixel_index >= 3095) && (pixel_index <= 3097)) || ((pixel_index >= 3102) && (pixel_index <= 3111)) || ((pixel_index >= 3113) && (pixel_index <= 3120)) || ((pixel_index >= 3125) && (pixel_index <= 3127)) || ((pixel_index >= 3129) && (pixel_index <= 3136)) || ((pixel_index >= 3143) && (pixel_index <= 3188)) || ((pixel_index >= 3190) && (pixel_index <= 3194)) || ((pixel_index >= 3196) && (pixel_index <= 3207)) || ((pixel_index >= 3209) && (pixel_index <= 3224)) || ((pixel_index >= 3226) && (pixel_index <= 3233)) || ((pixel_index >= 3236) && (pixel_index <= 3238)) || ((pixel_index >= 3240) && (pixel_index <= 3283)) || ((pixel_index >= 3285) && (pixel_index <= 3303)) || ((pixel_index >= 3305) && (pixel_index <= 3321)) || ((pixel_index >= 3323) && (pixel_index <= 3329)) || ((pixel_index >= 3332) && (pixel_index <= 3335)) || ((pixel_index >= 3337) && (pixel_index <= 3379)) || ((pixel_index >= 3381) && (pixel_index <= 3399)) || ((pixel_index >= 3401) && (pixel_index <= 3417)) || ((pixel_index >= 3419) && (pixel_index <= 3427)) || ((pixel_index >= 3429) && (pixel_index <= 3431)) || ((pixel_index >= 3434) && (pixel_index <= 3475)) || ((pixel_index >= 3477) && (pixel_index <= 3495)) || ((pixel_index >= 3497) && (pixel_index <= 3513)) || ((pixel_index >= 3515) && (pixel_index <= 3527)) || ((pixel_index >= 3530) && (pixel_index <= 3572)) || ((pixel_index >= 3574) && (pixel_index <= 3591)) || ((pixel_index >= 3593) && (pixel_index <= 3608)) || ((pixel_index >= 3611) && (pixel_index <= 3623)) || ((pixel_index >= 3626) && (pixel_index <= 3667)) || ((pixel_index >= 3673) && (pixel_index <= 3686)) || ((pixel_index >= 3689) && (pixel_index <= 3703)) || ((pixel_index >= 3706) && (pixel_index <= 3715)) || ((pixel_index >= 3723) && (pixel_index <= 3763)) || ((pixel_index >= 3765) && (pixel_index <= 3767)) || ((pixel_index >= 3774) && (pixel_index <= 3782)) || ((pixel_index >= 3784) && (pixel_index <= 3798)) || ((pixel_index >= 3801) && (pixel_index <= 3804)) || ((pixel_index >= 3813) && (pixel_index <= 3817)) || ((pixel_index >= 3819) && (pixel_index <= 3859)) || ((pixel_index >= 3861) && (pixel_index <= 3868)) || ((pixel_index >= 3902) && (pixel_index <= 3912)) || ((pixel_index >= 3914) && (pixel_index <= 3956)) || ((pixel_index >= 3958) && (pixel_index <= 3974)) || ((pixel_index >= 3988) && (pixel_index <= 4007)) || ((pixel_index >= 4010) && (pixel_index <= 4052)) || ((pixel_index >= 4055) && (pixel_index <= 4102)) || ((pixel_index >= 4105) && (pixel_index <= 4149)) || ((pixel_index >= 4154) && (pixel_index <= 4196)) || ((pixel_index >= 4200) && (pixel_index <= 4246)) || pixel_index == 4248 || ((pixel_index >= 4259) && (pixel_index <= 4284)) || ((pixel_index >= 4296) && (pixel_index <= 4343)) || ((pixel_index >= 4345) && (pixel_index <= 4350)) || pixel_index == 4353 || ((pixel_index >= 4383) && (pixel_index <= 4389)) || ((pixel_index >= 4391) && (pixel_index <= 4439)) || ((pixel_index >= 4441) && (pixel_index <= 4447)) || ((pixel_index >= 4449) && (pixel_index <= 4457)) || ((pixel_index >= 4459) && (pixel_index <= 4467)) || ((pixel_index >= 4470) && (pixel_index <= 4477)) || ((pixel_index >= 4479) && (pixel_index <= 4484)) || ((pixel_index >= 4487) && (pixel_index <= 4536)) || ((pixel_index >= 4538) && (pixel_index <= 4543)) || ((pixel_index >= 4545) && (pixel_index <= 4553)) || ((pixel_index >= 4555) && (pixel_index <= 4563)) || ((pixel_index >= 4566) && (pixel_index <= 4572)) || ((pixel_index >= 4575) && (pixel_index <= 4580)) || ((pixel_index >= 4582) && (pixel_index <= 4632)) || ((pixel_index >= 4635) && (pixel_index <= 4639)) || ((pixel_index >= 4641) && (pixel_index <= 4649)) || ((pixel_index >= 4651) && (pixel_index <= 4659)) || ((pixel_index >= 4661) && (pixel_index <= 4668)) || ((pixel_index >= 4671) && (pixel_index <= 4676)) || ((pixel_index >= 4678) && (pixel_index <= 4728)) || ((pixel_index >= 4731) && (pixel_index <= 4736)) || ((pixel_index >= 4738) && (pixel_index <= 4745)) || ((pixel_index >= 4747) && (pixel_index <= 4755)) || ((pixel_index >= 4757) && (pixel_index <= 4764)) || ((pixel_index >= 4766) && (pixel_index <= 4768)) || ((pixel_index >= 4774) && (pixel_index <= 4824)) || ((pixel_index >= 4834) && (pixel_index <= 4841)) || ((pixel_index >= 4843) && (pixel_index <= 4851)) || ((pixel_index >= 4853) && (pixel_index <= 4858)) || ((pixel_index >= 4866) && (pixel_index <= 4868)) || ((pixel_index >= 4871) && (pixel_index <= 4920)) || ((pixel_index >= 4922) && (pixel_index <= 4926)) || ((pixel_index >= 4957) && (pixel_index <= 4964)) || ((pixel_index >= 4966) && (pixel_index <= 5016)) || ((pixel_index >= 5019) && (pixel_index <= 5030)) || ((pixel_index >= 5040) && (pixel_index <= 5060)) || ((pixel_index >= 5062) && (pixel_index <= 5113)) || ((pixel_index >= 5116) && (pixel_index <= 5153)) || ((pixel_index >= 5157) && (pixel_index <= 5210)) || ((pixel_index >= 5217) && (pixel_index <= 5243)) || ((pixel_index >= 5251) && (pixel_index <= 5308)) || ((pixel_index >= 5310) && (pixel_index <= 5311)) || ((pixel_index >= 5341) && (pixel_index <= 5344)) || ((pixel_index >= 5346) && (pixel_index <= 5404)) || ((pixel_index >= 5406) && (pixel_index <= 5410)) || ((pixel_index >= 5413) && (pixel_index <= 5418)) || ((pixel_index >= 5420) && (pixel_index <= 5426)) || ((pixel_index >= 5429) && (pixel_index <= 5434)) || ((pixel_index >= 5436) && (pixel_index <= 5439)) || ((pixel_index >= 5442) && (pixel_index <= 5501)) || ((pixel_index >= 5503) && (pixel_index <= 5507)) || ((pixel_index >= 5509) && (pixel_index <= 5514)) || ((pixel_index >= 5516) && (pixel_index <= 5522)) || ((pixel_index >= 5524) && (pixel_index <= 5530)) || ((pixel_index >= 5532) && (pixel_index <= 5535)) || ((pixel_index >= 5537) && (pixel_index <= 5597)) || ((pixel_index >= 5600) && (pixel_index <= 5603)) || ((pixel_index >= 5605) && (pixel_index <= 5610)) || ((pixel_index >= 5613) && (pixel_index <= 5618)) || ((pixel_index >= 5620) && (pixel_index <= 5625)) || ((pixel_index >= 5628) && (pixel_index <= 5630)) || ((pixel_index >= 5633) && (pixel_index <= 5694)) || ((pixel_index >= 5696) && (pixel_index <= 5700)) || ((pixel_index >= 5702) && (pixel_index <= 5707)) || ((pixel_index >= 5709) && (pixel_index <= 5714)) || ((pixel_index >= 5716) && (pixel_index <= 5721)) || ((pixel_index >= 5723) && (pixel_index <= 5726)) || ((pixel_index >= 5728) && (pixel_index <= 5791)) || ((pixel_index >= 5793) && (pixel_index <= 5796)) || ((pixel_index >= 5798) && (pixel_index <= 5803)) || ((pixel_index >= 5805) && (pixel_index <= 5810)) || ((pixel_index >= 5812) && (pixel_index <= 5816)) || ((pixel_index >= 5819) && (pixel_index <= 5821)) || ((pixel_index >= 5824) && (pixel_index <= 5888)) || (pixel_index >= 5919) && (pixel_index <= 6143)) oled_data = 16'b1111011110011110 + change_col[count_press];
                                    else if (pixel_index == 137 || pixel_index == 235 || pixel_index == 325 || pixel_index == 341 || pixel_index == 437 || pixel_index == 631 || pixel_index == 719 || pixel_index == 803 || pixel_index == 812 || ((pixel_index >= 908) && (pixel_index <= 909)) || pixel_index == 1399 || pixel_index == 1478 || pixel_index == 1501 || pixel_index == 1571 || pixel_index == 1602 || pixel_index == 1690 || pixel_index == 1760 || pixel_index == 1787 || pixel_index == 1793 || pixel_index == 1860 || pixel_index == 1888 || pixel_index == 1949 || pixel_index == 1954 || pixel_index == 1967 || pixel_index == 2083 || pixel_index == 2178 || pixel_index == 2426 || pixel_index == 2435 || pixel_index == 2453 || pixel_index == 2461 || pixel_index == 2463 || pixel_index == 2524 || pixel_index == 2528 || pixel_index == 2533 || pixel_index == 2554 || ((pixel_index >= 2557) && (pixel_index <= 2559)) || pixel_index == 2650 || pixel_index == 2659 || pixel_index == 2738 || pixel_index == 2756 || pixel_index == 2814 || pixel_index == 2822 || pixel_index == 2928 || pixel_index == 2949 || pixel_index == 2996 || pixel_index == 3004 || pixel_index == 3124 || pixel_index == 3139 || pixel_index == 3195 || ((pixel_index >= 3432) && (pixel_index <= 3433)) || pixel_index == 3672 || pixel_index == 3722 || pixel_index == 3768 || pixel_index == 3799 || pixel_index == 3869 || pixel_index == 3901 || ((pixel_index >= 3975) && (pixel_index <= 3980)) || ((pixel_index >= 3982) && (pixel_index <= 3983)) || ((pixel_index >= 3985) && (pixel_index <= 3987)) || pixel_index == 4008 || pixel_index == 4103 || pixel_index == 4153 || pixel_index == 4258 || pixel_index == 4285 || pixel_index == 4293 || pixel_index == 4352 || pixel_index == 4381 || pixel_index == 4565 || pixel_index == 4573 || pixel_index == 4633 || pixel_index == 4826 || pixel_index == 4832 || pixel_index == 4865 || pixel_index == 4869 || pixel_index == 4927 || ((pixel_index >= 4936) && (pixel_index <= 4937)) || pixel_index == 4956 || ((pixel_index >= 5017) && (pixel_index <= 5018)) || pixel_index == 5031 || ((pixel_index >= 5034) && (pixel_index <= 5038)) || pixel_index == 5115 || pixel_index == 5154 || pixel_index == 5216 || pixel_index == 5244 || pixel_index == 5312 || pixel_index == 5340 || pixel_index == 5428 || pixel_index == 5440 || ((pixel_index >= 5598) && (pixel_index <= 5599)) || pixel_index == 5612 || pixel_index == 5627 || pixel_index == 5631 || pixel_index == 5823) oled_data = 16'b1010010100010100 + change_col[count_press];
                                    else if (pixel_index == 234 || pixel_index == 614 || pixel_index == 621 || pixel_index == 1382 || pixel_index == 1504 || pixel_index == 1853 || pixel_index == 1881 || pixel_index == 2234 || pixel_index == 2274 || pixel_index == 2462 || pixel_index == 2466 || pixel_index == 2640 || pixel_index == 2728 || pixel_index == 2736 || pixel_index == 2804 || pixel_index == 2900 || pixel_index == 2935 || pixel_index == 2937 || pixel_index == 2951 || pixel_index == 3002 || pixel_index == 3006 || pixel_index == 3121 || pixel_index == 3137 || pixel_index == 3142 || pixel_index == 3529 || pixel_index == 3610 || pixel_index == 3625 || pixel_index == 3687 || pixel_index == 3704 || pixel_index == 3716 || pixel_index == 3721 || pixel_index == 3773 || pixel_index == 3805 || pixel_index == 3812 || pixel_index == 3818 || pixel_index == 3880 || ((pixel_index >= 3882) && (pixel_index <= 3883)) || pixel_index == 4150 || pixel_index == 4249 || pixel_index == 4351 || pixel_index == 4458 || pixel_index == 4564 || pixel_index == 4634 || pixel_index == 4831 || pixel_index == 4860 || pixel_index == 4870 || pixel_index == 4935 || ((pixel_index >= 4940) && (pixel_index <= 4942)) || ((pixel_index >= 5032) && (pixel_index <= 5033)) || pixel_index == 5211 || pixel_index == 5250 || pixel_index == 5405 || ((pixel_index >= 5411) && (pixel_index <= 5412)) || pixel_index == 5441 || pixel_index == 5611) oled_data = 16'b0101001010001010 + change_col[count_press];
                                    else if (pixel_index == 517 || pixel_index == 1284 || pixel_index == 1597 || pixel_index == 1600 || pixel_index == 2062 || pixel_index == 2235 || pixel_index == 2371 || pixel_index == 2920 || pixel_index == 2927 || pixel_index == 3138 || pixel_index == 3981 || pixel_index == 3984 || pixel_index == 4054 || pixel_index == 4294 || pixel_index == 4468 || pixel_index == 4485 || pixel_index == 4670 || pixel_index == 4859 || pixel_index == 5039 || pixel_index == 5817) oled_data = 16'b1010011110010100 + change_col[count_press];
                                    else if (pixel_index == 1593) oled_data = 16'b1111011110010100 + change_col[count_press];
                                    else if (pixel_index == 1697 || pixel_index == 5427) oled_data = 16'b0101010100001010 + change_col[count_press];
                                    else if (pixel_index == 3025 || pixel_index == 3881) oled_data = 16'b0000001010000000 + change_col[count_press];
                                    else oled_data = 0 + change_col[count_press];
                           
                       end
                end
                end
                endmodule