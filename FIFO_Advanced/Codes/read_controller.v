/*
 * File Name       : read_controller.v
 * Project Name    : READ CONTROLLER 
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [13/07/2026]
 * 
 * Comment     : 
*/


module read_controller(
	input wire rclk,
	input wire rbtn_out,
	output reg rinc
);
	always@(posedge rclk) begin
		if(rbtn_out) begin
			rinc <= 1'b1;
		end else begin
			rinc <= 1'b0;
		end
	end
endmodule
