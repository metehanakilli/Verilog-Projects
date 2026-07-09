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
	input reg wclk_en,
	input wire [DATA_WIDTH-1 : 0] waddr,
	input wire [DATA_WIDTH-1 : 0] raddr,
	input wire [DATA_WIDTH-1 : 0] wdata,
	output wire [DATA_WIDTH-1 : 0]rdata
);
	reg [DATA_WIDTH-1 : 0] ram [0 : (1<<ADDR_WIDTH)-1];
	
	always @(posedge wclk)
		if(wclk_en) begin
			ram[waddr] <= wdata;
	end
	assign rdata = ram[raddr];
endmodule