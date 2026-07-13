/*
 * File Name       : clock_divider.v
 * Project Name    : Clock Divider
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [03/07/2026]
 * 
 * Comment     : 
*/

module clock_divider 
#( parameter DIVIDE_RATE = 2,			//division rate of system clock
   parameter N_BIT = 8						//BIT RATE OF COUNTER REG 
   
)(  input wire clk,				//System Clock : 100MHz / Input clock of Divider
	input wire rst,				//System reset
	output reg clk_out			//Divided Clock / Output Clock of Divider
);
	
	reg [N_BIT-1 : 0] counter;		  //Counter reg for divide system clock, triggers clk_out
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			counter <= 0;				//If rst triggered --> reset the counter and clk_out 
			clk_out <= 0;
		end else begin
			if (counter >= (DIVIDE_RATE >> 1) - 1) begin
				counter <= 0;
				clk_out <= ~clk_out;				
			end else begin
				counter <= counter + 1'd1;
			end
		end
	end
endmodule
