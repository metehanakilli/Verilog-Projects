/*
 * Dosya Adi       : top_module.v
 * Proje Adi       : TOP MODULE
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * Açiklama        : Yardimci modulleri birlestirir.
*/

`timescale 1ns / 1ps

module top_module (
    input wire clk,
    input wire rst,
    input wire btn_in,
    output wire [7:0] cntr
);

    wire clk_cntr;
    wire clk_deb;
    wire debounced_btn;


    clock_divider #(          	//DIVIDER FOR 'counter' MODULE
        .N_BIT(32),
        .DIVIDE_RATE(10000000)
    ) 
    clk_div_cntr_inst (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_cntr)
    );


    clock_divider #(			//DIVIDER FOR 'debouncer' MODULE
		.N_BIT(32),
        .DIVIDE_RATE(10000)
    ) 
    clk_div_deb_inst (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_deb)
    );


    debouncer #(
		.SHIFT_REG(20),
		.SUFFICIENT_NUMBER_OF_ONES(12),
		.ONES_COUNT_BIT(5)
		)
		debouncer_inst (
        .clk(clk),
        .clk_out(clk_deb),
        .rst(rst),
        .btn_in(btn_in),
        .btn_out(debounced_btn)
    );


    counter #( 
		.INC_DEC_VAL(1),
		.N_BIT(8)
    ) 
    counter_inst (
        .clk(clk_cntr),
        .rst(rst),
        .btn_out(debounced_btn),
        .cntr(cntr)
    );

endmodule
