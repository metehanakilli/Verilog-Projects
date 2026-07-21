/*
 * File Name       : read_controller.v
 * Project Name    : READ CONTROLLER 
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [15/07/2026]
 * 
 * Comment     : 
*/


module read_controller(
	input wire clk,									//SYSTEM CLOCK : 100 MHz
	input wire rst_n,								//SYSTEM RESET : ACTIVE-LOW
	input wire rbtn_out,							//DEBOUNCED rbtn_out SIGNAL
	input wire rempty,								//FIFO EMPTY FLAG
	output reg rinc									//ENABLE SIGNAL FOR READ FIFO
);
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rinc <= 1'b0;
		end else begin
			if(rbtn_out && !rempty) begin			//IF rbtn_out IS TRIGGERED AND FIFO NOT EMPTY, rinc --> 1 : READ DATA
				rinc <= 1'b1;
			end else begin
				rinc <= 1'b0;
			end
		end
	end
endmodule
