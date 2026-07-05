/*
 * Dosya Adi       : top_module.v
 * Proje Adi       : TOP MODULE OF counter, clock_divider
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * Açiklama        : clock_divider ve counter modullerini birlestirir.
 *                   Disaridan gelen yuksek frekansli clock sinyali bolunerek
 *                   sayici modulu yavaslatilir.
*/

module top_module (
    input wire clk, rst, direction, 
    output wire [3:0] cntr
);

    wire clk_div_out;
	
    clock_divider #( 
        .divide_rate(4) 
    ) clk_div_inst (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_div_out)
    );
	
	
    counter #( 
        .inc_dec_val(2) 
    ) counter_inst (
        .clk(clk_div_out),
        .rst(rst),
        .direction(direction),
        .cntr(cntr)
    );

endmodule