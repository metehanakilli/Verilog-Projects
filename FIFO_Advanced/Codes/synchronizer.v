/*
 * File Name       : synchronizer.v
 * Project Name    : 2FF Synchronizer
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [08/07/2026]
 * 
 * Comment     : Helps to avoid from metastability.
*/

module synchronizer 
#(  parameter DATA_WIDTH = 4						//Bit Size of pointer

)(  
	input wire clk,
	input wire rst_n,
	input wire [DATA_WIDTH : 0] pntr_in,
	output wire [DATA_WIDTH : 0] pntr_out			//Pointer as a input of synchronizer
);
	reg [DATA_WIDTH : 0] pntr_out_i;
	
	always @(posedge clk or negedge rst_n) begin : synchronizer
		if (~rst_n) begin
			pntr_out_i <= 'b0;
		end else begin
			pntr_out_i <= pntr_in;						//Collecting noisy data from input button
		end
	end
	assign pntr_out = pntr_out_i;
endmodule
