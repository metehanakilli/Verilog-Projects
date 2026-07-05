/*
 * Dosya Adi        : top_module_TB.v
 * Proje Adi        : TOP MODULE TESTBENCH
 * Yazar            : [METEHAN AKILLI / Sirket Adi]
 * Tarih            : [05/07/2026]
 * 
 * Açiklama         : top_module icin simulasyon (testbench) dosyasi. 
*/

`timescale 1ns / 1ps

module top_module_TB();

    reg clk;
    reg rst;
    reg btn_in;

    wire [3:0] cntr;

    top_module uut (
        .clk(clk),
        .rst(rst),
        .btn_in(btn_in),
        .cntr(cntr)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        btn_in = 0;

        #100;
        rst = 0;
        $display("--- Sistem baslatildi. Durum: ASAGI SAYMA (btn_in = 0) ---");

        #2000;

        $display("--- Butona basiliyor (Gurultulu) ---");
        btn_in = 1; #15;
        btn_in = 0; #10;
        btn_in = 1; #25;
        btn_in = 0; #10;
        btn_in = 1;
        
        $display("--- Buton basili kaldi. Durum: YUKARI SAYMA ---");
        #4000; 


        $display("--- Buton birakiliyor (Gurultulu) ---");
        btn_in = 0; #20;
        btn_in = 1; #10;
        btn_in = 0; #15;
        btn_in = 1; #10;
        btn_in = 0;

        $display("--- Buton birakildi. Durum: ASAGI SAYMA ---");
        #2000;

        $display("--- Calisma sirasinda RESET atiliyor ---");
        rst = 1;
        #100;
        rst = 0;
        
        #1000;

        $display("--- Simulasyon Tamamlandi ---");
        $finish;
    end

    initial begin
        $monitor("Zaman: %0t ns | Reset: %b | Buton: %b | Counter: %d", $time, rst, btn_in, cntr);
    end

endmodule