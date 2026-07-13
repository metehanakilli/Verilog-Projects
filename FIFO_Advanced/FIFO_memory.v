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
	input wire wclk_en,
	input wire [DATA_WIDTH-1 : 0] wdata,
	output reg [DATA_WIDTH-1 : 0]rdata
);
	reg [DATA_WIDTH-1 : 0] ram [0 : (1<<ADDR_WIDTH)-1];
	reg [DATA_WIDTH-1 : 0] waddr;
	reg [DATA_WIDTH-1 : 0] raddr;
	
	always @(posedge wclk) begin
		if(wclk_en) begin
			ram[waddr] <= wdata;
			waddr <= waddr + 'b1;
		end
	end
	

	always @(posedge rclk) begin
		if(wclk_en) begin
			rdata <= ram[raddr];
			raddr <= raddr + 'b1;
		end
	end
endmodule
