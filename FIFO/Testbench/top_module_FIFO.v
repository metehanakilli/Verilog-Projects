/*
 * Dosya Adi       : top_module_FIFO.v
 * Proje Adi       : TOP MODULE of FIFO
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * Açiklama        : Connects the submodules
*/

`timescale 1ns / 1ps

module top_module_FIFO #(
	parameter DATA_WIDTH = 5'd5
)(
    input wire wclk,rclk,
    input wire rrst_n,wrst_n, 

	input wire winc,
	input wire rinc,
	
	output wire wfull,
	output wire rempty,
	
    output wire [DATA_WIDTH:0] wpntr,
    output wire [DATA_WIDTH:0] rpntr,
    output wire [DATA_WIDTH-1:0] waddr,
    output wire [DATA_WIDTH-1:0] raddr,
    output wire [DATA_WIDTH:0] wq2_rpntr,
    output wire [DATA_WIDTH:0] rq2_wpntr
    
);

    wire [DATA_WIDTH:0] gray_writer; 
    wire [DATA_WIDTH:0] gray_reader; 
    wire [DATA_WIDTH:0] wq2_rpntr_g;
    wire [DATA_WIDTH:0] rq2_wpntr_g; 

    
    
    bin2gray #(
		.DATA_WIDTH(DATA_WIDTH)					//BINARY TO GRAY CODE CONVERTER FOR "write_pntr_handler"
    )bin2gray_inst_w(							
		.bin(wpntr),
		.gray(gray_writer)
	);
	
	synchronizer #(
		.DATA_WIDTH(DATA_WIDTH)
    )synchronizer_inst_w (
		.clk (rclk),
		.rst_n (rrst_n),
		.pntr_in(gray_writer),
		.pntr_out(rq2_wpntr_g)
	);
	
	gray2bin #(
		.DATA_WIDTH(DATA_WIDTH)
    )gray2bin_inst_w (
		.gray(rq2_wpntr_g),
		.bin(rq2_wpntr)
	);
	
	
	bin2gray #(									//BINARY TO GRAY CODE CONVERTER FOR "read_pntr_handler"
		.DATA_WIDTH(DATA_WIDTH)
    )bin2gray_inst_r(							
		.bin(rpntr),
		.gray(gray_reader)
	);
	
	synchronizer #(
		.DATA_WIDTH(DATA_WIDTH)
    )synchronizer_inst_r (
		.clk (wclk),
		.rst_n (wrst_n),
		.pntr_in(gray_reader),
		.pntr_out(wq2_rpntr_g)
	);
	
	gray2bin #(
		.DATA_WIDTH(DATA_WIDTH)
    )gray2bin_inst_r (
		.gray(wq2_rpntr_g),
		.bin(wq2_rpntr)
	);
	
	
	write_pntr_handler #(
		.DATA_WIDTH(DATA_WIDTH)
    )write_pntr_handler_inst_w (
		.wclk(wclk),
		.wrst_n(wrst_n),
		.winc(winc),
		.wq2_rpntr(wq2_rpntr),
		.wfull(wfull),
		.wpntr(wpntr),
		.waddr(waddr)
	);
	
	
	read_pntr_handler #(
		.DATA_WIDTH(DATA_WIDTH)
    )read_pntr_handler_inst_r (
		.rclk(rclk),
		.rrst_n(rrst_n),
		.rinc(rinc),
		.rq2_wpntr(rq2_wpntr),
		.rempty(rempty),
		.rpntr(rpntr),
		.raddr(raddr)
	);
	
	
	
endmodule
