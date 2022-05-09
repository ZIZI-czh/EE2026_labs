`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 03:40:51 PM
// Design Name: 
// Module Name: change_image
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


module change_image( input clk10, input clk6p25m,  input right, input left, output reg [3:0]count, [15:0]sw, input state_check);


wire right_out;
wire left_out;
wire Qbar_left, Qbar_right;
wire Q1, Q2;
reg Q1_bar, Q2_bar;
 D_FF right1 (clk10, right, right_out );
  D_FF right2 (clk10,right_out,Q1 );
  D_FF left1 (clk10, left, left_out, Qbar_left );
   D_FF left2 (clk10,  Qbar_left,  Q2 );
  
// D_FF 1eft1 (clk10, left, left_out, Qbar_left );
 
//single_pulse right1 ( clk10, right, right_out);
//single_pulse left1 ( clk10, left, left_out);

initial
begin
count = 0;
end

  always @ (posedge clk6p25m)  // use button to move left and right to change image
        begin
        Q1_bar = ~Q1;
        Q2_bar = ~Q2;
        
        // if(state == 3)
        // begin
        if(state_check == 1)
        begin
         if(((right_out && Q1_bar) ==  1 ) && right == 1  )
         begin
          if(count <= 8 && count >= 0)
          begin    count <= count + 1;end
          else begin   count <= 0; end
          end else  if(((left_out && Q2_bar) ==  1 ) &&  left== 1  )
           begin
          if(count > 0 && count <= 8) 
           begin count <= count - 1;  end
        else begin count <= 0; end
        end
        end else
        count <= 0;
        end
endmodule