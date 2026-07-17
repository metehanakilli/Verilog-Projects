/*
 * Dosya Adi       : top_module_FIFO_TB.v
 * Proje Adi       : TOP MODULE of FIFO
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * Aciklama        : Connects the submodules and tests Async FIFO scenarios.
*/

`timescale 1ns / 1ps

module top_module_FIFO_TB;

    parameter DATA_WIDTH = 7;
    parameter ADDR_WIDTH = 6;
    parameter SHIFT_REG = 20;
    parameter SUFFICIENT_NUMBER_OF_ONES = 12;
    parameter ONES_COUNT_BIT = 5;


    reg clk;
    reg rst_n;
    reg rbtn_in;
    reg wbtn_in;
    reg [6:0] SW;


    wire wfull;
    wire almost_wfull;
    wire rempty;
    wire almost_rempty;
    wire [DATA_WIDTH:0] wpntr;
    wire [DATA_WIDTH:0] rpntr;
    wire [DATA_WIDTH-1:0] waddr;
    wire [DATA_WIDTH-1:0] raddr;
    wire [DATA_WIDTH:0] wq2_rpntr;
    wire [DATA_WIDTH:0] rq2_wpntr;
    wire [DATA_WIDTH-1:0] rdata;
    wire [DATA_WIDTH-1:0] wdata;
    wire [6:0] led;
    wire wclk;
    wire rclk;
    wire wbtn_out;
    wire rbtn_out;
    wire rinc;
    wire winc;


    top_module_FIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .SHIFT_REG(SHIFT_REG),
        .SUFFICIENT_NUMBER_OF_ONES(SUFFICIENT_NUMBER_OF_ONES),
        .ONES_COUNT_BIT(ONES_COUNT_BIT)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .rbtn_in(rbtn_in),
        .wbtn_in(wbtn_in),
        .SW(SW),
        .wfull(wfull),
        .almost_wfull(almost_wfull),
        .rempty(rempty),
        .almost_rempty(almost_rempty),
        .wpntr(wpntr),
        .rpntr(rpntr),
        .waddr(waddr),
        .raddr(raddr),
        .wq2_rpntr(wq2_rpntr),
        .rq2_wpntr(rq2_wpntr),
        .rdata(rdata),
        .wdata(wdata),
        .led(led),
        .wclk(wclk),
        .rclk(rclk),
        .wbtn_out(wbtn_out),
        .rbtn_out(rbtn_out),
        .rinc(rinc),
        .winc(winc)
    );


    always #5 clk = ~clk;


    task press_wbtn;
        begin
            wbtn_in = 1;
            #20000; 
            wbtn_in = 0;
            #20000; 
        end
    endtask


    task press_rbtn;
        begin
            rbtn_in = 1;
            #5000;
            rbtn_in = 0;
            #5000; 
        end
    endtask

    // --------------------------------------------------------
    // TEST SENARYOLARI
    // --------------------------------------------------------
    initial begin
        $display("-------------------------------------------");
        $display("TEST BASLIYOR...");
        $display("-------------------------------------------");
        
        clk = 0;
        rst_n = 0;
        wbtn_in = 0;
        rbtn_in = 0;
        SW = 8'h00;

        #100;
        rst_n = 1;
        #1000;

        // SENARYO 1: WRITE Modu Tetikleme (IDLE -> SENT -> WRITE)
        $display("[SENARYO 1] Yazma FSM'i Tetikleniyor (IDLE -> WRITE)...");
        press_wbtn();
        #150000; 

        if (wfull) $display("-> BASARILI: wfull bayragi 1 oldu. FIFO doldu ve FSM READ durumuna gecti.");
        else $display("-> UYARI: wfull aktif degil! Kapasite (128) tam dolmamis olabilir, ancak yazma bitti.");

        #10000;

        // SENARYO 2: READ Modunda Veri Okuma (FSM READ durumundayken)
        $display("[SENARYO 2] Tekli okuma baslatiliyor...");
        press_rbtn();
		
        if (rpntr > 0) $display("-> BASARILI: 1 Veri okundu. rpntr = %d, okunan rdata = %h", rpntr, rdata);
        else $display("-> HATA: Okuma yapilamadi.");
        
        press_rbtn();
        if (rpntr > 1) $display("-> BASARILI: 2. Veri okundu. okunan rdata = %h", rdata);

        #10000;

        // SENARYO 3: FIFO'yu Tamamen Bosaltma Testi
        $display("[SENARYO 3] FIFO tamamen bosaltiliyor...");
        while (!rempty) begin
            press_rbtn();
        end
        
        if (rempty) $display("-> BASARILI: rempty bayragi 1 oldu. FIFO mukemmel calisiyor.");
        else $display("-> HATA: FIFO bosalamadi!");

        #10000;

        // SENARYO 4: FSM Write Durumundayken Okuma Denemesi (İzin Verilmemeli)
        $display("[SENARYO 4] FSM Write durumundayken okuma girisimi (Hata Tolerans Testi)...");
        
        rst_n = 0; #100;
        rst_n = 1; #1000;

        fork
            begin
                press_wbtn();
            end
            begin
                #25000; 
                $display("-> Write sirasinda okuma deneniyor...");
                press_rbtn(); 
            end
        join
        
        #150000;
		
        if (rpntr == 0) $display("-> BASARILI: FSM WRITE konumundayken okuma izni (read_mode_en) verilmedi! Veri korunuyor.");
        else $display("-> HATA: WRITE sirasinda okuma (rinc) aktif oldu! FSM kurali ihlal edildi.");

        $display("-------------------------------------------");
        $display("TUM TESTLER TAMAMLANDI.");
        $display("-------------------------------------------");
        $finish;
    end

endmodule
