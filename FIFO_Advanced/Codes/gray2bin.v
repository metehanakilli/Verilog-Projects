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
#(  parameter DATA_WIDTH = 5'd5					//Bit Size of data

)(  
	input wire [DATA_WIDTH : 0] gray,			//Data as a gray coded input
	output wire [DATA_WIDTH : 0] bin			//Data as a Binary output
);
	
	genvar i;		  //Defined to print up to the output DATA_WIDTH
	
	generate
		assign bin[DATA_WIDTH] = gray[DATA_WIDTH];			//Copied first bit for conversion 
		
		for (i=DATA_WIDTH-1; i>=0; i=i-1) begin
			assign bin[i] = bin[i+1] ^ gray[i];					//The main mathmetic for Gray-Binary Conversion
		end
	endgenerate
endmodule
