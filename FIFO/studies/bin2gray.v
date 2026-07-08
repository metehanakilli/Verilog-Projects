/*
 * File Name       : bin2gray.v
 * Project Name    : Binary to Gray Code Converter
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [08/07/2026]
 * 
 * Comment     : This module converts Binary to Gray Code. 
				 The main idea is shifting the binary number right by one bit
				 performing an XOR operation with the original binary number.
*/

module bin2gray 
#(  parameter DATA_WIDTH = 4

)(  
	input wire [DATA_WIDTH-1 : 0] bin,
	output wire [DATA_WIDTH-1 : 0] gray
);

	assign gray = bin ^ (bin >> 1); 
endmodule
