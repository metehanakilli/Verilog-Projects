/*
 * File Name       : FIFO_memory.v
 * Project Name    : DUAL PORT BRAM
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [09/07/2026]
 * 
 * Comment     : 
*/


module FIFO_memory #(
	parameter DATA_WIDTH = 5'd5,
	parameter ADDR_WIDTH = 5'd5
)(
	input wire wclk,
	input wire rclk,
	input wire rst_n,
	input wire wclk_en,
	input wire rinc,
	input wire [DATA_WIDTH-1 :0] raddr,
	input wire [DATA_WIDTH-1 :0] waddr,
	input wire [DATA_WIDTH-1 : 0] wdata,
	output wire [DATA_WIDTH-1 : 0]rdata
);
	reg [DATA_WIDTH-1 : 0] ram [0 : 127];
	reg [DATA_WIDTH-1 : 0] rdata_i;
	
	integer i;
	
	always @(posedge wclk)begin
			if(wclk_en) begin
				ram[waddr] 		<= wdata;
			end
		end
	

	always @(posedge rclk or negedge rst_n) begin
		if(!rst_n) begin
			rdata_i <= 0;
		end else begin
			if(rinc ) begin
				rdata_i 	<= ram[raddr];
			end
		end
	end
		assign rdata = rdata_i;
endmodule
