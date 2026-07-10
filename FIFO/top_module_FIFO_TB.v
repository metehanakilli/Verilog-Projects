/*
 * Dosya Adi       : top_module_FIFO_TB.v
 * Proje Adi       : TOP MODULE of FIFO
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * Aciklama        : Connects the submodules and tests Async FIFO scenarios.
*/

`timescale 1ns / 1ps

module top_module_FIFO_TB #(
    parameter DATA_WIDTH = 5'd5, 
    parameter ADDR_WIDTH = 5'd5
);
    reg wclk, rclk;
    reg rrst_n, wrst_n; 
    
    reg winc;
    reg rinc;
    reg [DATA_WIDTH-1 : 0] wdata;
    
    wire wfull;
    wire rempty;
    reg [DATA_WIDTH-1 : 0] rdata;
    
    wire [ADDR_WIDTH : 0] wpntr;
    wire [ADDR_WIDTH : 0] rpntr;
    wire [ADDR_WIDTH : 0] wq2_rpntr;
    wire [ADDR_WIDTH : 0] rq2_wpntr;
    
    integer i;
    
    top_module_FIFO uut (
        .wclk(wclk),
        .rclk(rclk),
        .wrst_n(wrst_n),
        .rrst_n(rrst_n),
        .winc(winc),
        .rinc(rinc),
        .wfull(wfull),
        .rempty(rempty),
        .wpntr(wpntr),
        .rpntr(rpntr),
        .wq2_rpntr(wq2_rpntr),
        .rq2_wpntr(rq2_wpntr),
        .wdata(wdata)
    );

    always #5 wclk = ~wclk; 
    always #7 rclk = ~rclk; 

    initial begin

        $display("TEST BASLIYOR...");
        wclk = 0; 
        rclk = 0;
        wrst_n = 0; 
        rrst_n = 0;
        winc = 0; 
        rinc = 0;
        wdata = 0;
        rdata = 0;
        

        #50;
        wrst_n = 1; 
        rrst_n = 1;
        

        #50; 
        

        //FIFO'YU TAMAMEN DOLDURMA (Write till Full)
        $display("FIFO Tamamen Dolduruluyor...");
        
        @(posedge wclk);
        for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
            winc = 1;
            wdata = i[DATA_WIDTH-1 : 0]; 
            @(posedge wclk);
        end
        winc = 0; 
        
        #10;
        if (wfull) $display(" -> BASARILI: wfull bayragi aktif oldu.");
        else $display(" -> HATA: wfull bayragi calismadi!");

        #100;


        //FIFO'YU TAMAMEN BOŞALTMA (Read till Empty)

        $display(" FIFO Tamamen Bosaltiliyor...");
        
        @(posedge rclk);
        for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
            rinc = 1;
            @(posedge rclk);
            

        end
        rinc = 0; 


        #(5*14); 
        if (rempty) $display(" -> BASARILI: rempty bayragi aktif oldu.");
        else $display(" -> HATA: rempty bayragi calismadi!");

        #100;


        //AYNI ANDA OKUMA VE YAZMA TESTİ (Concurrent R/W)

        $display(" Es Zamanli Okuma ve Yazma Basliyor...");
        

        @(posedge wclk);
        winc = 1; wdata = 5'h0A; @(posedge wclk);
        winc = 1; wdata = 5'h0B; @(posedge wclk);
        winc = 1; wdata = 5'h0C; @(posedge wclk);
        winc = 0;
        
        #50;

        fork

            begin
                @(posedge wclk);
                winc = 1; wdata = 5'h0D; @(posedge wclk);
                winc = 1; wdata = 5'h0E; @(posedge wclk);
                winc = 0;
            end

            begin
                @(posedge rclk); rinc = 1; 
                @(posedge rclk); rinc = 1; 
                @(posedge rclk); rinc = 1; 
                @(posedge rclk); rinc = 0;
            end
        join

        #200;

        $display("TUM TESTLER TAMAMLANDI.");
        $finish;
    end

endmodule
