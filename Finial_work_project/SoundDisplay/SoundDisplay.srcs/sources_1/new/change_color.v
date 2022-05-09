`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 10:19:20 AM
// Design Name: 
// Module Name: change_color
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


module change_color( input clk10, input clk6p25m,  input right, input left, output reg [3:0]count_r, output reg [3:0]count_g,output reg [3:0]count_b,input [15:0]sw, check_state);


wire right_out;
wire left_out;
wire Qbar_left, Qbar_right;
wire Q1, Q2;
reg Q1_bar, Q2_bar;
 dff right1 (clk10, right, right_out );
  D_FF right2 (clk10,right_out,Q1 );
  D_FF left1 (clk10, left, left_out, Qbar_left );
  D_FF left2 (clk10,  Qbar_left,  Q2 );
  
// D_FF 1eft1 (clk10, left, left_out, Qbar_left );
 
//single_pulse right1 ( clk10, right, right_out);
//single_pulse left1 ( clk10, left, left_out);

initial
begin
count_r = 0;
count_g = 0;
count_b = 0;
end

  always @ (posedge clk6p25m)  // use button to move left and right to change image
        begin
        Q1_bar = ~Q1;
        Q2_bar = ~Q2;
        
        if(check_state == 1)
        begin
        if(sw[6] == 1)
        begin
         if(((right_out && Q1_bar) ==  1 ) && right == 1  )
         begin
          if(count_r <= 5 && count_r >= 0)
          begin    count_r <= count_r + 1;end
          else begin   count_r <= 0; end
          end else  if(((left_out && Q2_bar) ==  1 ) &&  left== 1  )
           begin
          if(count_r > 0 && count_r <= 5) 
           begin count_r <= count_r - 1;  end
        else begin count_r <= 0; end
        end
        end else if(sw[7] == 1)
        begin
         if(((right_out && Q1_bar) ==  1 ) && right == 1  )
                begin
                 if(count_g <= 5 && count_g >= 0)
                 begin    count_g <= count_g + 1;end
                 else begin   count_g <= 0; end
                 end else  if(((left_out && Q2_bar) ==  1 ) &&  left== 1  )
                  begin
                 if(count_g > 0 && count_g <= 5) 
                  begin count_g <= count_g - 1;  end
               else begin count_g <= 0; end
               end
        end
        else begin
         if(((right_out && Q1_bar) ==  1 ) && right == 1  )
                begin
                 if(count_b <= 5 && count_g >= 0)
                 begin    count_b <= count_b + 1;end
                 else begin   count_b <= 0; end
                 end else  if(((left_out && Q2_bar) ==  1 ) &&  left== 1  )
                  begin
                 if(count_b > 0 && count_b <= 5) 
                  begin count_b <= count_b - 1;  end
               else begin count_b <= 0; end
               end
        end
        end else begin count_r <=0; count_g <= 0; count_b<=0; end
        end
        endmodule