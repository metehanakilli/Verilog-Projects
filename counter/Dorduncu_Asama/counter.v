/*
 * File Name       : counter.v
 * Project Name    : 4 Bit Updown Counter
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [02/07/2026]
 * 
 * Comment     : 
*/

module counter #( parameter inc_dec_val = 2
)( input wire clk, rst, btn_out,
	output wire [3:0] cntr
);
	
	reg direction;
	reg [3:0] temp_cntr;
	
	always @(posedge btn_out) begin
		direction <= direction + 1'b1;
	end
	
	
	
	always @(posedge clk, posedge rst) begin
	
		if (rst) begin
			temp_cntr <= 4'b0;
			direction <= 1'b0;
			end else begin
				if(direction) begin
					temp_cntr <= temp_cntr + inc_dec_val;
				end else begin
					temp_cntr <= temp_cntr - inc_dec_val;
				end
		end
	end
	assign cntr = temp_cntr;
endmodule
