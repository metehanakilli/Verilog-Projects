/*
 * File Name       : gray2bin.v
 * Project Name    : Gray Code to Binary Converter
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [08/07/2026]
 * 
 * Comment     : This module converts Gray Code to Binary. 
				 The main idea is shifting the binary number left by one bit
				 performing an XOR operation with the original binary number.
*/

module gray2bin 
#(  parameter DATA_WIDTH = 4

)(  
	input wire [DATA_WIDTH-1 : 0] gray,
	output wire [DATA_WIDTH-1 : 0] bin
);
	
	genvar i;
	
	generate
		assign bin[DATA_WIDTH-1] = gray[DATA_WIDTH-1];
		
		for (i=DATA_WIDTH-2; i>=0; i=i-1) begin
			assign bin = bin[i+1] ^ gray[i];
		end
	endgenerate
endmodule
