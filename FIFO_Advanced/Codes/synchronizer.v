/*
 * File Name       : synchronizer.v
 * Project Name    : 2FF Synchronizer
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [08/07/2026]
 * 
 * Comment     : Helps to avoid from metastability.
*/

module synchronizer 
#(  parameter DATA_WIDTH = 4						//BIT SIZE OF POINTER

)(  
	input wire clk,									//SYSTEM CLOCK 100MHz
	input wire rst_n,								//SYSTEM RESET --> ACTIVE LOW
	input wire [DATA_WIDTH -1 : 0] pntr_in,			//POINTER AS A INPUT OF SYNCHRONIZER
	output wire [DATA_WIDTH -1 : 0] pntr_out			//SYNCHRONIZED OUTPUT
);
	reg [DATA_WIDTH -1 : 0] pntr_out_i;				//TEMPORARILY VARIABLE FOR 
	
	always @(posedge clk or negedge rst_n) begin : synchronizer
		if (!rst_n) begin
			pntr_out_i <= 'b0;
		end else begin
			pntr_out_i <= pntr_in;						//COLLECTING NOISY DATA FROM INPUT BUTTON
		end
	end
	assign pntr_out = pntr_out_i;
endmodule
