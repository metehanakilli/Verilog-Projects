/*
 * File Name       : counter.v
 * Project Name    : N BIT UPDOWN COUNTER
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [02/07/2026]
 * 
 * Comment     : 
*/

module counter 
#(  parameter INC_DEC_VAL = 2,			//UPDOWN VALUE OF COUNTER
	parameter N_BIT = 4					//BIT SIZE OF UPDWN COUNTER

)(  input wire clk,						//SYSTEM CLOCK : 100MHz
	input wire rst,						//SYSTEM RESET 
	input wire btn_out,					//
	output wire [N_BIT-1:0] cntr		//THE OUTPUT VALUE OF COUNTER
);
	
	reg direction = 0;					//DIRECTION OF COUNTER ---> 1:UP / 0:DOWN
	reg [N_BIT-1:0] temp_cntr;			//TEMPORARILY OUTPUT OF COUNTER
	
	
	always @(posedge rst or posedge btn_out) begin
		if(rst) begin
			direction <= 0;
		end else begin
			direction <= ~direction;			//DIRECTION CHANGES WHEN 'rst' OR 'btn_out' PHYSICAL BUTTONS ARE TRIGGERED
		end							
	end
	
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			temp_cntr <= 0;
			end else begin
				if(direction) begin
					temp_cntr <= temp_cntr + INC_DEC_VAL;		//IF 'direction = 1', ADD 'INC_DEC_VAL' 
				end else begin
					temp_cntr <= temp_cntr - INC_DEC_VAL;		//IF 'direction = 1', SUBSTRACT 'INC_DEC_VAL' 
				end
		end
	end
	assign cntr = temp_cntr;			//ASSIGNING THE TEMPORARILY OUTPUT TO OUTPUT OF COUNTER
endmodule
