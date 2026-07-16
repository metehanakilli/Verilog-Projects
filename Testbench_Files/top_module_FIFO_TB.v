/*
 * Dosya Adi       : top_module_FIFO_TB.v
 * Proje Adi       : TOP MODULE of FIFO
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * Aciklama        : Connects the submodules and tests Async FIFO scenarios.
*/


module top_module_FIFO_TB #(
    parameter DATA_WIDTH = 8'd8, 
    parameter ADDR_WIDTH = 7'd7
);
    reg clk;

    reg rst_n, rrst_n, wrst_n; 
    
    
    wire almost_rempty;
    wire almost_wfull;
    
    reg write_fsm_busy;
    reg rbtn_in;
    reg wbtn_in;

    
    wire wfull;
    wire rempty;
    
    wire [ADDR_WIDTH : 0] wpntr;
    wire [ADDR_WIDTH : 0] rpntr;
    wire [ADDR_WIDTH : 0] wq2_rpntr;
    wire [ADDR_WIDTH : 0] rq2_wpntr;
    
    integer i;
    
    top_module_FIFO uut (
        .clk(clk),
        .wclk(wclk),
        .rclk(rclk),
        .wbtn_out(wbtn_out),
        .rbtn_out(rbtn_out),
        .rst_n(rst_n),
        .wrst_n(wrst_n),
        .rrst_n(rrst_n),
        .wfull(wfull),        
        .rempty(rempty),
        .almost_rempty(almost_rempty),
        .almost_wfull(almost_wfull),
        .wpntr(wpntr),
        .wdata(wdata),
        .rdata(rdata),
        .rpntr(rpntr),
        .wq2_rpntr(wq2_rpntr),
        .rq2_wpntr(rq2_wpntr),
        .wbtn_in(wbtn_in),
        .rbtn_in(rbtn_in),
        .winc(winc),
        .rinc(rinc)
    );

    always #1 clk = ~clk;

    initial begin

        $display("TEST BASLIYOR...");
        clk = 0;
        rst_n = 0;        
        wrst_n = 0; 
        rrst_n = 0;
        wbtn_in = 0;
        rbtn_in = 0;

        #50;
        wrst_n = 1; 
        rrst_n = 1;
        rst_n = 1;


        //FIFO'YU TAMAMEN DOLDURMA (Write till Full)
        $display("FIFO Tamamen Dolduruluyor...");
        

        wbtn_in = 1;
        #105000;
		
        
        if (wfull) $display(" -> BASARILI: wfull bayragi aktif oldu.");
        else $display(" -> HATA: wfull bayragi calismadi!");

        #100;


        //FIFO'YU TAMAMEN BOŞALTMA (Read till Empty)

        $display(" FIFO Tamamen Bosaltiliyor...");
		
		rbtn_in = 1; #105200;
		


        #(5*14); 
        if (rempty) $display(" -> BASARILI: rempty bayragi aktif oldu.");
        else $display(" -> HATA: rempty bayragi calismadi!");

        #100;
        
    end

endmodule
