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
    output wire [3:0] cntr
);

    wire clk_cntr;
    wire clk_deb;
    wire debounced_btn;


    clock_divider #(
        .divide_rate(50)
    ) clk_div_cntr_inst (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_cntr)
    );


    clock_divider #(
        .divide_rate(10)
    ) clk_div_deb_inst (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_deb)
    );


    debouncer debouncer_inst (
        .clk(clk),
        .clk_out(clk_deb),
        .rst(rst),
        .btn_in(btn_in),
        .sample_rate(1'b1),
        .btn_out(debounced_btn)
    );


    counter #(
        .inc_dec_val(2)
    ) counter_inst (
        .clk(clk_cntr),
        .rst(rst),
        .direction(debounced_btn),
        .cntr(cntr)
    );

endmodule