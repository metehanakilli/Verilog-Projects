/*
 * File Name       : debouncer.v
 * Project Name    : PUSH BUTTON DEBOUNCER
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [05/07/2026]
 * 
 * Comment     : 

 * 
 * Revision History:
 * Date            Author             Comment
 * ----------      ---------------    -----------------------------------------
 * 05.07.2026      [METEHAN]           Ilk surum olusturuldu.
*/

module debouncer #(
	parameter SHIFT_REG = 20,					//Shift register's bit number of collacting data
	parameter SUFFICIENT_NUMBER_OF_ONES = 12,	//Limit of 1's to decide button out is 1 or 0
	parameter ONES_COUNT_BIT = 5				//Suffcient bit width to count 1's
)( 
	input wire clk,   	        				//100MHz FPGA clock signal
	input wire clk_out,  	 	  				//10kHz Clock signal	
  	input wire rst,			 	 				//Reset	
	input wire btn_in,          				//Noisy button input signal
	output reg btn_out							//Non-noisy button output for direction.	
);
	


// Protection against Metastability
	reg btn_sync_1;								//Intermediate stage for synchronizer
	reg btn_sync_2;								//Synchronized button input
	
	always @(posedge clk or posedge rst) begin : synchronizer
		if (rst) begin
			btn_sync_1 <= 1'b0;
			btn_sync_2 <= 1'b0;
		end else begin
			btn_sync_1 <= btn_in;				//Collecting noisy data from input button
			btn_sync_2 <= btn_sync_1;			//Convert it to synchronized button
		end
	end
	
	
// 20 bit Shift Register
	reg [SHIFT_REG-1:0] samples;							//Number of shift register bit.
	
	always @(posedge clk or posedge rst) begin : shift_reg            //Writing synchronized button input with 1's in "samples"
		if(rst) begin          					               
			samples <= 20'b0;					
		end else begin
			samples <= {samples[SHIFT_REG - 2:0] , btn_sync_2};
		end
	end
	

// Count Ones
	reg [ONES_COUNT_BIT-1 :0] ones_count;						//Counter for 1's
	integer i;
	
	always @(*) begin : count_ones								 
		ones_count = 0;
		for(i=0; i<SHIFT_REG; i=i+1) begin
			if(samples[i] == 1) begin
				ones_count = ones_count + 1;
			end
		end
	end	
	
	
// If the number of 1's is more than SUFFICIENT_NUMBER_OF_ONES, button out becomes 1.
	always @(posedge clk_out or posedge rst) begin : debounce_input
		if(rst) 
			btn_out <= 0;
		else begin
			if(ones_count >= SUFFICIENT_NUMBER_OF_ONES) begin
				btn_out <= 1;
			end else
			btn_out <= 0;
			end
	end
	
endmodule
