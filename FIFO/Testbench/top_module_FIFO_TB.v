/*
 * Dosya Adi       : top_module_FIFO_TB.v
 * Proje Adi       : TOP MODULE of FIFO
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * Açiklama        : Connects the submodules
*/

`timescale 1ns / 1ps

module top_module_FIFO_TB #(
	parameter DATA_WIDTH = 5'd5
);
	reg wclk,rclk;
    reg rrst_n,wrst_n; 

	reg winc;
	reg rinc;
	
	wire wfull;
	wire rempty;
	
    wire [DATA_WIDTH:0] wpntr;
    wire [DATA_WIDTH:0] rpntr;


    wire [DATA_WIDTH:0] wq2_rpntr;
    wire [DATA_WIDTH:0] rq2_wpntr;
	
	top_module_FIFO uut  (
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
		.rq2_wpntr(rq2_wpntr)
	);

	always #5 wclk = ~wclk;
	always #7 rclk = ~rclk;

	initial begin
		wclk = 0;
		rclk = 0;
		wrst_n=0;
		rrst_n=0;
		winc=1;
		rinc=0;
		#50;
		
		wrst_n=1;
		rrst_n=1;
		#50;
		
		@(posedge wclk);
			winc =1;
			repeat(5) @(posedge wclk);
			#500;
			
		@(posedge rclk);
			rinc=0;
			repeat(3) @(posedge rclk);
			rinc=0;
			#100;
			
		$finish;
	end


endmodule

	
