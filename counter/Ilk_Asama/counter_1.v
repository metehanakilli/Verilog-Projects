/*
 * Dosya Adi       : counter_1.v
 * Proje Adi       : N BIT COUNTER
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

module counter_1 ( input wire clk, rst,
	output wire [3:0] cntr
);

	reg [3:0] temp_cntr;
	
	always @(posedge clk, posedge rst) begin
	
		if (rst) begin
			temp_cntr <= 4'b0;
		end else begin
			if (clk) begin
				temp_cntr <= temp_cntr + 4'b1;
			end	
		end
	end
	assign cntr = temp_cntr;
endmodule