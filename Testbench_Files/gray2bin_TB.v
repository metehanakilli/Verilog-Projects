/*
 * File Name       : gray2bin_TB.v
 * Project Name    : TB of Gray Code to Binary Converter
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [08/07/2026]
 * 
 * Comment     : 
*/

module gray2bin_TB();
	
	localparam DATA_WIDTH = 4'd4;
	
	reg [DATA_WIDTH-1 : 0] gray_in;
	wire [DATA_WIDTH-1 : 0] bin_out;
	
	integer i;
	
	gray2bin #( 
		.DATA_WIDTH(DATA_WIDTH)
	) dut (
		.gray(gray_in),
		.bin(bin_out)
	);


	initial begin		
		for(i=0; i<(1<<DATA_WIDTH); i=i+1) begin		//prints all output as much as DATA_WIDTH
			gray_in <= i;
			#10;
		end
		$finish;
	end
endmodule
		
	
