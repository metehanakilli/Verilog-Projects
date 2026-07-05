/*
 * Dosya Adi        : tb_counter_1.v
 * Proje Adi        : N BIT COUNTER
 * Yazar            : [METEHAN AKILLI / Sirket Adi]
 * Tarih            : 07/02/2026
 * 
 * Açiklama         : counter_1 modülü için Testbench dosyası.
 *                    Saat (clock) sinyali üretir, reset durumunu test eder 
 *                    ve sayacın 0-15 arası sayma işlemini simüle eder.
 */

`timescale 1ns / 1ps 

module tb_counter_1();
    reg clk;
    reg rst;

    wire [3:0] cntr;

    counter_1 uut (
        .clk(clk),
        .rst(rst),
        .cntr(cntr)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $monitor("Zaman = %0t ns | rst = %b | cntr = %d (Binary: %b)", $time, rst, cntr, cntr);

        rst = 1;
        #15; 

        rst = 0;
        
        #200; 

        rst = 1;
        #15;
        rst = 0;

        #50;

        $finish;
    end

    initial begin
        $dumpfile("tb_counter_1.vcd");
        $dumpvars(0, tb_counter_1);
    end

endmodule