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

module debouncer ( 
	input wire clk, clk_out, rst, btn_in, sample_rate,
	output reg btn_out
);
	
// Protection against Metastability
	reg btn_sync_1;
	reg btn_sync_2;
	
	always @(posedge clk) begin : synchronizer
		if (rst) begin
			btn_sync_1 <= 1'b0;
			btn_sync_2 <= 1'b0;
		end else begin
			btn_sync_1 <= btn_in;
			btn_sync_2 <= btn_sync_1;
		end
	end
	
	
// 20 bit Shift Register
	reg [19:0] samples;
	
	always @(posedge clk) begin : shift_reg
		if(rst) begin
			samples <= 20'b0;
		end else if (sample_rate) begin
			samples <= {samples[18:0] , btn_sync_2};
		end
	end
	

// Count Ones
	reg [4:0] ones_count;
	integer i;
	
	always @(*) begin : count_ones 
		ones_count = 5'b0000;
		for(i=0; i<20; i=i+1) begin
			if(samples[i] == 1'b1) begin
				ones_count = ones_count + 1;
			end
		end
	end	
	
	
// Debounce
	always @(posedge clk_out) begin : debounce_input
		if(rst) 
			btn_out <= 1'b0;
		else begin
			if(ones_count >= 12) begin
				btn_out <= 1'b1;
			end else
			btn_out <= 1'b0;
			end
	end
	
endmodule