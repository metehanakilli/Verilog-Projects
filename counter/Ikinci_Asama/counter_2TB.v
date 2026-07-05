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

`timescale 1ns / 1ps

module tb_counter_2();

    reg clk;
    reg rst;
    reg direction;
    wire [3:0] cntr;

    counter_2 uut (
        .clk(clk),
        .rst(rst),
        .direction(direction),
        .cntr(cntr)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        direction = 1'b1;
        #200;
        
        rst = 0;
        #150;
        
        direction = 1'b0;
        #200;
        
        rst = 1;
        #15;
        
        rst = 0;
        #50;
        
        $finish;
    end

    initial begin
        $dumpfile("tb_counter.vcd");
        $dumpvars(0, tb_counter_2);
    end

endmodule