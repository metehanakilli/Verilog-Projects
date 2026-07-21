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
	parameter ADDR_WIDTH = 7'd7
)(
	input wire rom_clk,	 								//CLOCK FOR ROM MEMORY : 5MHz
	input wire rst_n,									//SYSTEM RESET : ACTIVE-LOW
	input wire addr_en,									//ENABLE SIGNAL FOR READ DATA FROM ROM								
	input wire [ADDR_WIDTH : 0] addr,					
	output wire [DATA_WIDTH-1 : 0] data_out				//READED DATA FROM ROM
);
	reg [DATA_WIDTH-1:0] rom_mem [0 : 255];				//ROM MEMORY DESCRIPTION
	reg [DATA_WIDTH-1 : 0] data_out_i;					//TEMPORARILY READED DATA
	
	initial begin
		$readmemb ("memory8bit.mem", rom_mem);			//AUTOMATIC INITIALIZATION
	end
	
	always @(posedge rom_clk or negedge rst_n) begin	//READING DATA
		if(!rst_n) begin
			data_out_i <=0;
		end else begin						
			if(addr_en) begin
				data_out_i <= rom_mem[addr];					
			end
		end
	end
	assign data_out = data_out_i;
	
endmodule
