`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2022 14:08:33
// Design Name: 
// Module Name: peak_vol
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

module peak_volume_calcutate(
 input        wire       clk20k,
 input        wire       reset,
 input        wire [11:0]   sample,
 output       reg [15:0]      led,
 output       reg [11:0]      peak_data,
 output       reg [7:0]      mic_in_grade
    );
 
 
localparam  capture_intever_time =   24'd4000; //0
localparam  update_intever_time  =   24'd9999; //9
localparam      register_num   =     10'd4;
localparam      volume_default   =     12'd2048;
localparam      volume_grade1   =     volume_default+volume_default/16;
localparam      volume_grade2   =     volume_default+volume_default/16*2;
localparam      volume_grade3   =     volume_default+volume_default/16*3;
localparam      volume_grade4   =     volume_default+volume_default/16*4;
localparam      volume_grade5   =     volume_default+volume_default/16*5;
localparam      volume_grade6   =     volume_default+volume_default/16*6;
localparam      volume_grade7   =     volume_default+volume_default/16*7;
localparam      volume_grade8   =     volume_default+volume_default/16*8;
localparam      volume_grade9   =     volume_default+volume_default/16*9;
localparam      volume_grade10   =     volume_default+volume_default/16*10;
localparam      volume_grade11   =     volume_default+volume_default/16*11;
localparam      volume_grade12   =     volume_default+volume_default/16*12;
localparam      volume_grade13   =     volume_default+volume_default/16*13;
localparam      volume_grade14   =     volume_default+volume_default/16*14;
localparam      volume_grade15   =     volume_default+volume_default/16*15;
reg			   [23:0]		time_cnt=24'd0;



reg			   [13:0]		sum_sample_data=14'd0;
reg			   [11:0]       sample_buffer_array[register_num-1:0];
wire		   [11:0]		smooth_source_data;
reg			   [11:0]		source_peak_data=12'd0;

wire		  [11:0]		final_calculator_data;
wire		  [11:0]		adjust_data;
reg  		  [11:0]		capture_peak_data=12'd0;


integer   i;
initial begin
for(i=0;i<=register_num-1;i=i+1)begin
	sample_buffer_array[i]<=12'd0;
end
end	
//time counter
//********************************************************	
always@(posedge clk20k)begin
	if(reset)begin
	  time_cnt<=24'd0;
	end
	else begin
	  if(time_cnt==capture_intever_time)
	  time_cnt<=24'd0;
	  else
	  time_cnt<=time_cnt+1;
	end
end
//smooth source data
//****************************************************
always@(posedge clk20k)begin
	if(reset)begin
	for(i=0;i<=register_num-1;i=i+1)
	   sample_buffer_array[i]<=12'd0;
	end
	else begin
	for(i=0;i<register_num-1;i=i+1)begin
	  sample_buffer_array[0]  <= sample;
	  sample_buffer_array[i+1]<=sample_buffer_array[i];
	end
	end
end

always@(posedge  clk20k)begin
	if(reset)begin
	  sum_sample_data<=14'd0;
	end
	else begin
	  sum_sample_data<=sum_sample_data+sample-sample_buffer_array[register_num-1];
	end
end

assign smooth_source_data  =sum_sample_data[13:2];
//assign smooth_source_data  =sample;
//peak data  search
//***********************************************************
always@(posedge clk20k)begin
      if(reset)
		source_peak_data<=12'd0;
      else if(smooth_source_data>=source_peak_data)
	    source_peak_data<=smooth_source_data;
	  else if(time_cnt==capture_intever_time)begin
         source_peak_data<=12'd0;
       end	  
	  else
        source_peak_data<=source_peak_data;	  
end

//assign peak_data = source_peak_data;
//assign   final_calculator_data  = (SW1_select==1'b0)?source_peak_data:source_peak_data;

//*********************************************************
//grade calculate
//*********************************************************
always@(posedge clk20k)begin
    if(reset)begin
		capture_peak_data<=12'd0;
	end
	else if(time_cnt==capture_intever_time) begin
	   capture_peak_data<=source_peak_data;
	end
	else
	   capture_peak_data<=capture_peak_data;
end
always@(posedge clk20k)begin
    if(reset)begin
    led<=16'd0;
    peak_data<=4'd0;
    mic_in_grade <=8'd0;
    end
    else begin
        if((capture_peak_data>=0)&&(capture_peak_data<volume_grade1))begin
            led<=16'd1;
            peak_data<=4'd0;
            mic_in_grade<=8'd0;
        end
        else if((capture_peak_data>=volume_grade1)&&(capture_peak_data<volume_grade2))begin
            led<=16'h0003;
            peak_data<=4'd1;
            mic_in_grade<=8'd1;
        end        
        else if((capture_peak_data>=volume_grade2)&&(capture_peak_data<volume_grade3))begin
            led<=16'h0007;
            peak_data<=4'd2;
            mic_in_grade<=8'd2;
        end
        else if((capture_peak_data>=volume_grade3)&&(capture_peak_data<volume_grade4))begin
            led<=16'h000f;
            peak_data<=4'd3;
            mic_in_grade<=8'd3;
        end
        else if((capture_peak_data>=volume_grade4)&&(capture_peak_data<volume_grade5))begin
            led<=16'h001f;
            peak_data<=4'd4;
            mic_in_grade<=8'd4;
        end
        else if((capture_peak_data>=volume_grade5)&&(capture_peak_data<volume_grade6))begin
            led<=16'h003f;
            peak_data<=4'd5;
            mic_in_grade<=8'd5;
        end
        else if((capture_peak_data>=volume_grade6)&&(capture_peak_data<volume_grade7))begin
            led<=16'h007f;
            peak_data<=4'd6;
            mic_in_grade<=8'd6;
        end
        else if((capture_peak_data>=volume_grade7)&&(capture_peak_data<volume_grade8))begin
            led<=16'h00ff;
            peak_data<=4'd7;
            mic_in_grade<=8'd7;
        end
        else if((capture_peak_data>=volume_grade8)&&(capture_peak_data<volume_grade9))begin
            led<=16'h01ff;
            peak_data<=4'd8;
            mic_in_grade<=8'd8;
        end
        else if((capture_peak_data>=volume_grade9)&&(capture_peak_data<volume_grade10))begin
            led<=16'h03ff;
            peak_data<=4'd9;
            mic_in_grade<=8'd9;
        end
        else if((capture_peak_data>=volume_grade10)&&(capture_peak_data<volume_grade11))begin
            led<=16'h07ff;
            peak_data<=4'd10;
            mic_in_grade<=8'h10;
        end        
        else if((capture_peak_data>=volume_grade11)&&(capture_peak_data<volume_grade12))begin
            led<=16'h0fff;
            peak_data<=4'd11;
            mic_in_grade<=8'h11;
        end        
        else if((capture_peak_data>=volume_grade14)&&(capture_peak_data<volume_grade15))begin
            led<=16'h1fff;
            peak_data<=4'd12;
            mic_in_grade<=8'h12;
        end
        else if((capture_peak_data>=volume_grade12)&&(capture_peak_data<volume_grade13))begin
            led<=16'h3fff;
            peak_data<=4'd13;
            mic_in_grade<=8'h13;
        end        
        else if((capture_peak_data>=volume_grade13)&&(capture_peak_data<volume_grade14))begin
            led<=16'h7fff;
            peak_data<=4'd14;
            mic_in_grade<=8'h14;
        end        
        else begin
            led<=16'hffff;
            peak_data<=4'd15;
            mic_in_grade<=8'h15;
        end
     end      
  end 
        
endmodule