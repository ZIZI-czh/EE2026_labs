`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2022 02:56:15 PM
// Design Name: 
// Module Name: control_leds
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


module control_leds(input basys_clock,[2:0]switch, output reg [15:0]led);
//reg my_clock;
wire my_clock_2;
wire my_clock_3;
wire my_clock_4;
wire my_clock_5;
//wire state;
initial
begin
led = 16'b1111_1111_1111;
end
reg push_button;
wire seg;
wire anode;
wire check_state;
wire [13:0]my_sequence;
wire state;
//create_diff_frequency fe1(basys_clock, my_clock);
create_one_hz fe2(basys_clock, my_clock_2);
create_ten_hz fe3(basys_clock, my_clock_3);
create_hu_hz fe4(basys_clock, my_clock_4);
create_tenk_hz fe5(basys_clock, my_clock_5);
check_counter fre(my_sequence, basys_clock);
password link(push_button,basys_clock,seg, anode, state, check_state);

always @ (posedge my_clock_5) // inside this blcok, it is sequrntially, from begin to end
begin
//led[15] <= 1;
if(my_sequence <= 14)
begin
case (my_sequence) //turn on the led from 0 to 13 on
15'd1:                                              
begin                                               
 led <= 16'b0000_0000_0000_0001;                     
 end                                                
15'd2:                                              
begin                                               
 led <= 16'b0000_0000_0000_0011;                     
 end                                                
15'd3:                                              
begin                                               
 led <= 16'b0000_0000_0000_0111;                     
 end                                                
15'd4:                                              
begin                                               
 led <= 16'b0000_0000_0000_1111;                     
 end                                                
15'd5:                                              
begin                                               
 led <= 16'b0000_0000_0001_1111;                     
 end                                                
15'd6:                                              
begin                                               
 led <= 16'b0000_0000_0011_1111;                     
 end                                                
15'd7:                                              
begin                                               
 led <= 16'b0000_0000_0111_1111;                     
 end                                                
15'd8:                                              
begin                                               
 led <= 16'b0000_0000_1111_1111;                     
 end                                                
15'd9:                                              
begin                                               
 led <= 16'b0000_0001_1111_1111;                     
 end                                                
 15'd10:                                             
 begin                                              
 led <= 16'b0000_0011_1111_1111;                     
   end                                              
15'd11:                                             
 begin                                              
 led <= 16'b0000_0111_1111_1111;                     
   end                                              
15'd12:                                             
 begin                                              
 led <= 16'b0000_1111_1111_1111;                     
     end                                            
15'd13:                                             
  begin                                             
 led <= 16'b0001_1111_1111_1111;                     
   end             
 15'd14:                                             
     begin                                             
    led <= 16'b0011_1111_1111_1111;                     
      end                                                
 default:                                           
 begin                                              
  led <= 16'b0011_1111_1111_1111;  //debug purpose   
  end                                               
endcase         
end
else if(my_sequence > 14 & state > 6)
begin
led[15] = 1;
end                                    
                                                                     
 if(my_sequence > 14 && switch[0] == 1 && switch[2] == 0 && switch[1] == 0)                                                                                                                                            
     begin                                                                               
                                                                                                                                                                          
        led[0] <= my_clock_2;     
        // led[15] <= my_clock_2;                                                                                                                                        
  end     
  else if(my_sequence > 14 && switch[1] == 1 && switch[2] == 0)     
  begin
   led[1] <= my_clock_3;  
  end         
  else if (my_sequence > 14  && switch[2] == 1)     
   begin
    led[2] <= my_clock_4;  
   end  
 //    led[15]= 1;                                                                        
 end
endmodule


