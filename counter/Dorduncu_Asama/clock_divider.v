/*
 * Dosya Adi       : clock_divider.v
 * Proje Adi       : CLOCK DIVIDER 
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [03/07/2026]
 * 
 * Açiklama        : 

 * 
 * Revizyon Gecmisi:
 * Tarih           Yazar              Aciklama
 * ----------      ---------------    -----------------------------------------
 * 03.07.2026      [METEHAN]           Ilk surum olusturuldu.
*/

module clock_divider #( parameter divide_rate = 2
)( 
	input wire clk, rst,
	output reg clk_out
);
	
	reg [31 : 0] counter;
	
	always @(posedge clk) begin
		if (rst == 1) begin
			counter <= 32'd0;
			clk_out <= 1'b0;
		end else begin
			if (counter >= (divide_rate / 2) - 1) begin
				counter <= 32'd0;
				clk_out <= ~clk_out;
			end else begin
				counter <= counter + 32'd1;
			end
		end
	end
endmodule