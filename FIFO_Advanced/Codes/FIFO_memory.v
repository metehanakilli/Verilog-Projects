/*
 * File Name       : FIFO_memory.v
 * Project Name    : DUAL PORT BRAM
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [09/07/2026]
 * 
 * Comment     : 
*/


module FIFO_memory #(
	parameter DATA_WIDTH = 8'd8,
	parameter ADDR_WIDTH = 7'd7
)(
	input wire clk,
	input wire rst_n,							//SYSTEM RESET : ACTIVE-LOW
	input wire wclk_en,							//ENABLE CLOCK FOR WRITE DATA FROM ROM TO FIFO
	input wire rinc,							//ENABLE SIGNAL FOR READ DATA FROM FIFO
	input wire [ADDR_WIDTH-1 :0] raddr,			//READED DATA'S ADDRESS
	input wire [ADDR_WIDTH-1 :0] waddr,			//WRITED  DATA'S ADDRESS
	input wire [DATA_WIDTH-1 : 0] wdata,		//WRITED DATA FROM ROM TO FIFO
	output wire [DATA_WIDTH-1 : 0]rdata			//READED DATA FROM FIFO
);
	reg [DATA_WIDTH-1 : 0] ram [0 : 127];		//FIFO MEMORY
	reg [DATA_WIDTH-1 : 0] rdata_i;				//TEMPORARILY READED DATA FROM FIFO

	
	always @(posedge clk)begin 
			if(wclk_en) begin					//IF WRITE ENABLE SIGNAL COMES WRITE DATA TO FIFO
				ram[waddr] 		<= wdata;
			end
		end
	

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rdata_i <= 0;
		end else begin
			if(rinc ) begin						//IF READ ENABLE SIGNAL COMES READ DATA FROM FIFO
				rdata_i 	<= ram[raddr];
			end
		end
	end
		assign rdata = rdata_i;
endmodule
