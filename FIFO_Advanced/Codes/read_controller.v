/*
 * File Name       : read_controller.v
 * Project Name    : READ CONTROLLER 
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [13/07/2026]
 * 
 * Comment     : 
*/


module read_controller(
	input wire clk,
	input wire rbtn_out,
	input wire rempty,
	input wire rst_n,
	output reg rinc
);
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rinc<= 1'b0;
		end else begin
			if(rbtn_out && !rempty) begin
				rinc <= 1'b1;
			end else begin
				rinc <= 1'b0;
			end
		end
	end
endmodule
