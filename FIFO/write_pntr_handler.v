/*
 * File Name       : write_pntr_handler.v
 * Project Name    : Write Pointer Handler
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [09/07/2026]
 * 
 * Comment     	   : 
*/

module write_pntr_handler
#(  parameter DATA_WIDTH = 5'd5					//BIT SIZE

)(  
	input wire wclk,							//WRITE DOMAIN CLOCK 
	input wire wrst_n,							//WRITE DOMAIN ACTIVE LOW RESET
	input wire winc,							//WRITE INCREMENT SIGNAL
	input wire [DATA_WIDTH : 0] wq2_rpntr,		//SYNCHRONIZED READ POINTER
	output wire wfull,							//FIFO FUL FLAG (SYNCHRON WITH wclk)
	output wire [DATA_WIDTH-1 : 0] waddr,		//ADDRES FOR WRITE DATA TO FIFO MEMORY
	output wire [DATA_WIDTH : 0] wpntr			//WRITE POINTER
);

	reg [DATA_WIDTH:0] temp_cntr;				//TEMPORARILY OUTPUT OF COUNTER

	
	always @(posedge wclk or negedge wrst_n) begin : counter		//COUNTS wpntr	
		if (!wrst_n) begin
			temp_cntr <= 0;
		end 
			else begin
				if(winc && !wfull) begin
					temp_cntr <= temp_cntr + 1;		
				end 
			end
	end
	
	assign wpntr = temp_cntr;								//ASSIGNING THE TEMPORARILY OUTPUT TO OUTPUT OF THE write_pntr_handler
	assign waddr = wpntr [DATA_WIDTH-1 : 0];
	assign wfull = (temp_cntr[DATA_WIDTH] != wq2_rpntr[DATA_WIDTH] && temp_cntr[DATA_WIDTH-1:0] == wq2_rpntr[DATA_WIDTH-1:0]);
	

endmodule
