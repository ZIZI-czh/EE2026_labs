`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2022 06:16:25 PM
// Design Name: 
// Module Name: password
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


module password(input [4:0]push_button, input basys_clock, output reg [7:0]seg, output reg [3:0]anode, output reg [5:0]state, output reg check_state, input [15:0] switch,  output reg [15:0]led );

//reg  [5:0]state = 1;
wire my_clock_5;
wire [13:0]my_sequence;
wire my_clock_6;
wire my_clock_7;
wire my_clock_8;

//reg check_state;
//wire led;
//reg switch;


wire [2:0]count;
//wire [50:0]count1;
wire finish_wait;
wire three_s;
check_count_module f1(count,basys_clock,switch);
create_tenk_hz fe5(basys_clock, my_clock_5);
check_counter link2(my_sequence,basys_clock);
create_one_hz fe2(basys_clock, my_clock_6);
create_ten_hz fe3(basys_clock, my_clock_7);
create_hu_hz fe4(basys_clock, my_clock_8);
three_seconds fe10( basys_clock, three_s, finish_wait, switch);


initial
begin
seg <= 8'b11111111;
led = 16'b0000_0000_0000;
state = 0;
anode <= 4'b1111;
//state_check = 0;
check_state = 0;

end
//parameter div_3_00s = 300_000_000;
always @ (posedge basys_clock) // inside this blcok, it is sequrntially, from begin to end
begin
//if(finish_wait == 1)
//
//led <= 16'b0000_0010_0011_0011;
//anode <= 4'b0000;
//seg <= 8'b11100001;
//e//nd
//else
 if (finish_wait == 1)
 begin
 led <= 16'b0000_0010_0011_0011;
 end
else if(finish_wait == 0 && my_sequence > 14 && state <= 6)
begin
  led <= 16'b0011_1111_1111_1111;   
end
else if(finish_wait == 0 && my_sequence > 14 && state > 6)
begin
  led <= 16'b1011_1111_1111_1111;   
end
//check_state = 1;
if(my_sequence <= 14 && finish_wait == 0)
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


//else if(my_sequence > 14 & state > 6 )
//begin
//led[15] = 1;
//end         

                           
                                                                     
 if(my_sequence > 14 && switch[0] == 1 && switch[2] == 0 && switch[1] == 0 && finish_wait == 0)                                                                                                                                            
     begin                                                                               
                                                                                                                                                                          
        led[0] <= my_clock_6;  
           
        // led[15] <= my_clock_2;                                                                                                                                        
  end     
  else if(my_sequence > 14 && switch[1] == 1 && switch[2] == 0 && finish_wait == 0)     
  begin
   led[1] <= my_clock_7;  
  end         
  else if (my_sequence > 14  && switch[2] == 1)     
   begin
    led[2] <= my_clock_8;  
   end  
 //    led[15]= 1;                                                                        

if(my_sequence > 14 && state < 7 && finish_wait == 0)
begin
//check_state =   1;
case(state)
6'd0:
begin
anode <= 4'b1110;
seg <= 8'b11100011;  //pushbutton[0] up
if(push_button == 5'b00001)
begin
state <= state + 1;
end
end

6'd1:
begin
//anode <= 4'b1101;
//anode <= 4'b1101;
anode = 4'b1101;
seg = 8'b11001111;//pushbutton[1] left
if(push_button == 5'b00010)
begin
state <= state + 1;
end
end

6'd2:
begin;

anode = 4'b1011;
seg = 8'b11100011;  
if(push_button == 5'b00001)
begin
state <= state + 1;
end
end

6'd3:
begin
//anode <= 4'b1101;
//anode <= 4'b0111;
anode <= 4'b0111;
seg <= 8'b10100001; //pushbutton[2] down
if(push_button == 5'b00100)
begin
state <= state + 1;
end
end

6'd4:
begin
//anode <= 4'b1101;
//anode <= 4'b1101;
anode <= 4'b1101;
seg <= 8'b11001111;//pushbutton[1] left
begin
if(push_button == 5'b00010)
state <= state + 1;
end
end

6'd5:

begin
//anode <= 4'b1101
anode <= 4'b0111;
seg <= 8'b10100001; //pushbutton[2] down
//state_check <= state_check +  1;
if(push_button == 5'b00100)
begin
state <= state + 1;
end
end

6'd6:

begin
//anode <= 4'b1101
//check_state =   1;
anode <= 4'b1110;
seg <= 8'b11100011;  //pushbutton[0] up
check_state <= 1;
led[15] = 1;
state <= state + 1;

end
endcase
end

else if(my_sequence > 14 && state > 6 && finish_wait == 0)
begin
anode <= 4'b1101;
seg <= 8'b11001111;//pushbutton[1] left
case(count)
3'd0:
begin
anode <= 4'b1110;
seg <= 8'b11100011;  //pushbutton[0] up
end

3'd1:
begin
anode <= 4'b1101;
seg <= 8'b11001111;//pushbutton[1] left
end

3'd2:
begin;
//anode <= 4'b1101;
anode <= 4'b1011;
seg <= 8'b11100011;  //pushbutton[0] up

end
endcase
end
if(finish_wait == 1)
begin
anode <= 4'b0000;
seg <= 8'b11100001;
end
end
endmodule