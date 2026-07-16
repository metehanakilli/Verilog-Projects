/*
 * File Name       : bin2gray_TB.v
 * Project Name    : TB of Binary to Gray Code Converter
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [08/07/2026]
 * 
 * Comment     : 
*/

module bin2gray_TB();
	
	localparam DATA_WIDTH = 4'd4;		
	
	reg [DATA_WIDTH-1 : 0] bin_in;
	wire [DATA_WIDTH-1 : 0] gray_out;
	
	integer i;
	
	bin2gray #( 
		.DATA_WIDTH(4'd4)
	) dut (
		.bin(bin_in),
		.gray(gray_out)
	);


	initial begin
		bin_in <= 0;
		#10;
		
		for(i=1; i<(1<<DATA_WIDTH); i=i+1) begin		//prints all output as much as DATA_WIDTH
			bin_in <= i;
			#10;
		end
		$finish;
	end
endmodule
		
	
