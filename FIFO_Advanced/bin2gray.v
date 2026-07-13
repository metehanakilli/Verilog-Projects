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
#(  parameter DATA_WIDTH = 5'd5				//Bit Size of data

)(  
	input wire [DATA_WIDTH : 0] bin,		//Data as a Binary	
	output wire [DATA_WIDTH : 0] gray		//Data as a Gray code
);

	assign gray = bin ^ (bin >> 1); 		// (bin) XOR (the value bin shifted 1 bit to right)
endmodule
