/*
 * Dosya Adi       : counter_2.v
 * Proje Adi       : N BIT UPDOWN COUNTER 
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [07/02/2026]
 * 
 * Açiklama        : 

 * 
 * Revizyon Gecmisi:
 * Tarih           Yazar              Aciklama
 * ----------      ---------------    -----------------------------------------
 * 02.07.2026      [METEHAN]           Ilk surum olusturuldu.
*/

module counter_2 ( input wire clk, rst, direction,
	output wire [3:0] cntr
);

	reg [3:0] temp_cntr;
	
	always @(posedge clk, posedge rst) begin
	
		if (rst) begin
			temp_cntr <= 4'b0;
			end if (clk) begin
				if (direction == 1'b1) begin
					temp_cntr <= temp_cntr + 4'b1;
				end else begin
					temp_cntr <= temp_cntr - 4'b1;
				end
		end
	end
	assign cntr = temp_cntr;
endmodule