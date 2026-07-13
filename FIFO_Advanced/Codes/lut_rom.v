/*
 * File Name       : lut_rom.v
 * Project Name    : LUT ROM ARCHITECTURE DESIGN
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [13/07/2026]
 * 
 * Comment     	   : 
*/


module lut_rom #( 
	parameter DATA_WIDTH = 8'd8,
	parameter ROM_DEPTH = 7'd7,
	parameter ADDR_WIDTH = 5'd5
)(
	input wire rom_clk,	 								//CLOCK FOR ROM MEMORY 5MHz
	input wire addr_en,
	output wire [DATA_WIDTH-1 : 0] data_out				//DATA FOR WRITE FIFO
);
	reg [ADDR_WIDTH-1 : 0] addr;					    //ADDRES OF DATA 
	reg [DATA_WIDTH-1:0] rom_mem [0 : ROM_DEPTH-1];		//ROM MEMORY DESCRIPTION
	reg [DATA_WIDTH-1 : 0] data_out_i;
	
	initial begin
		$readmemb ("memory8bit.mem", rom_mem);			//AUTOMATIC INITIALIZATION
	end
	
	always @(posedge rom_clk) begin
		data_out_i <= rom_mem[addr];						//READING DATA
		if(addr_en) begin
			addr <= addr + 1'b1;
		end
	end
	assign data_out = data_out_i;
endmodule
