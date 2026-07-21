/*
 * File Name       : clock_divider.v
 * Project Name    : Clock Divider
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [03/07/2026]
 * 
 * Comment     : 
*/

module clock_divider 
#( parameter DIVIDE_RATE = 2,										//DIVISION RATE OF SYSTEM CLOCK
   parameter N_BIT = 8												//BIT RATE OF COUNTER REG 
   
)(  input wire clk,													//SYSTEM CLOCK : 100MHz / INPUT CLOCK OF DIVIDER
	input wire rst_n,												//SYSTEM RESET
	output reg clk_out												//DIVIDED CLOCK / OUTPUT CLOCK OF DIVIDER
);
	
	reg [N_BIT-1 : 0] counter;		  								//counter REG FOR DIVIDE SYSTEM CLOCK, TRIGGERS clk_out
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin											//IF rst_n TRIGGERED --> RESET THE counter AND clk_out 
			counter <= 0;
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
