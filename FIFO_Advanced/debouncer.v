/*
 * File Name       : debouncer.v
 * Project Name    : PUSH BUTTON DEBOUNCER
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [05/07/2026]
 * 
 * Comment     : THIS MODULE TAKES samples FROM BUTTON (NOISY SIGNAL), 
				 MAKES THE SIGNAL NON-NOISY INPUT COUNTS 1'S IN THE SAMPLES,
				 DECIDE THE BUTTON TRIGGERED OR NOT AND GIVES THE NON-NOISY OUTPUT SIGNAL
*/

module debouncer #(
	parameter SHIFT_REG = 20,										//SHIFT REGISTER'S BIT NUMBER OF COLLACTING DATA
	parameter SUFFICIENT_NUMBER_OF_ONES = 12,						//LIMIT OF 1'S TO DECIDE btn_out IS 1 OR 0
	parameter ONES_COUNT_BIT = 5									//SUFFICIENT BIT WIDTH TO VOUNT 1'S
)( 
	input wire clk,   	        									//SYSTEM CLOCK : 100MHz
 	input wire clk_out, 		 	  								//DIVIDED CLOCK : 1KHz	
  	input wire rst_n,			 	 								//SYSTEM RESET : ACTIVE-LOW
	input wire btn_in,          									//NOISY BUTTON INPUT SIGNAL
	output reg btn_out												//NON-NOISY BUTTON OUTPUT FOR DIRECTION
);
	


// PROTECTION AGAINST METASTABILITY
	reg btn_sync_1;													//INTERMEDIATE STAGE FOR SYNCHRONIZER
	reg btn_sync_2;													//SYNCHRONIZED BUTTON INPUT
	
	always @(posedge clk or posedge rst_n) begin : synchronizer
		if (!rst_n) begin
			btn_sync_1 <= 1'b0;
			btn_sync_2 <= 1'b0;
		end else begin
			btn_sync_1 <= btn_in;									//COLLECTING NOISY DATA FROM INPUT BUTTON
			btn_sync_2 <= btn_sync_1;								//CONVERT IT TO SYNCHRONIZED BUTTON
		end
	end
	
	
// 20 BIT SHIFT REGISTER
	reg [SHIFT_REG-1:0] samples;									//NUMBER OF SHIFT REGISTER BIT
	
	always @(posedge clk_out or posedge rst_n) begin : shift_reg        //WRITING SYNCHRONIZED BUTTON INPUT IN "samples"
		if(!rst_n) begin          					               
			samples <= 20'b0;					
		end else begin
			samples <= {samples[SHIFT_REG - 2:0] , btn_sync_2};
		end
	end
	

// COUNT ONES
	reg [ONES_COUNT_BIT-1 :0] ones_count;							//COUNTER FOR 1'S
	integer i;
	
	always @(posedge clk) begin : count_ones								 
		ones_count <= 0;
		for(i=0; i<SHIFT_REG; i=i+1) begin
			if(samples[i] == 1) begin
				ones_count <= ones_count + 1'd1;
			end
		end
	end	
	
	
//IF THE NUMBER OF 1'S IS MORE THAN SUFFICIENT_NUMBER_OF_ONES, btn_out BECOMES 1
	always @(posedge clk or posedge rst_n) begin : debounce_input
		if(!rst_n) begin 
			btn_out <= 1'b0;
		end else begin
			if(ones_count >= SUFFICIENT_NUMBER_OF_ONES) begin
				btn_out <= 1'b1;
			end else begin
			btn_out <= 1'b0;
			end
		end
	end
	
endmodule
