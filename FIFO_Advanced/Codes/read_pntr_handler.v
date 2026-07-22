/*
 * File Name       : read_pntr_handler.v
 * Project Name    : Read Pointer Handler
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [09/07/2026]
 * 
 * Comment     	   : 
*/

module read_pntr_handler
#(  parameter DATA_WIDTH = 8'd8									//BIT SIZE

)(  
	input wire rclk,											//READ DOMAIN CLOCK 
	input wire rst_n,											//READ DOMAIN ACTIVE LOW RESET
	input wire rinc,											//READ INCREMENT SIGNAL
	input wire [DATA_WIDTH -1 : 0] rq2_wpntr,						//SYNCHRONIZED WRITE POINTER
	output wire rempty,											//FIFO EMPTY FLAG (SYNCHRON WITH rclk)
	output wire almost_rempty,									//FIFO ALMOST EMPTY FLAG (SYNCHRON WITH rclk)
	output wire [DATA_WIDTH-2 : 0] raddr,						//ADDRES FOR READ DATA TO FIFO MEMORY
	output wire [DATA_WIDTH -1 : 0] rpntr							//READ POINTER
);
	
	reg [DATA_WIDTH -1 :0] temp_cntr;								//TEMPORARILY OUTPUT OF COUNTER
	wire [DATA_WIDTH-1:0] rfill_level;

	
	assign rfill_level = rq2_wpntr - temp_cntr;
	assign rempty = (temp_cntr[DATA_WIDTH-1:0] == rq2_wpntr[DATA_WIDTH-1:0] );
	assign almost_rempty = (rfill_level <= 8'd8) && !rempty;
	
	always @(posedge rclk or negedge rst_n) begin : counter		//COUNTS rpntr	
		if (!rst_n) begin
			temp_cntr <= 0;
		end 
		else begin
			if(rinc && !rempty) begin
				temp_cntr <= temp_cntr + 1;
			end
		end		
	end
	
	
	assign rpntr = temp_cntr;									//ASSIGNING THE TEMPORARILY OUTPUT TO OUTPUT OF THE read_pntr_handler
	assign raddr = temp_cntr [DATA_WIDTH-2 : 0];
endmodule
