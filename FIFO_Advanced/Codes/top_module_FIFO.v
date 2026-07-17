/*
 * Dosya Adi       : top_module_FIFO.v
 * Proje Adi       : TOP MODULE of FIFO
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * A??iklama        : Connects the submodules
*/

module top_module_FIFO #(
	parameter DATA_WIDTH = 7'd7,
	parameter ADDR_WIDTH = 6'd6,
	parameter SHIFT_REG = 20,
	parameter SUFFICIENT_NUMBER_OF_ONES = 12,
	parameter ONES_COUNT_BIT = 5
)(
    input wire clk,    
    input wire rst_n,
    input wire rbtn_in,
    input wire wbtn_in,
	input wire [6:0] SW,
	output reg [6:0] led

);

    wire [DATA_WIDTH:0] gray_writer; 
    wire [DATA_WIDTH:0] gray_reader; 
    wire [DATA_WIDTH:0] wq2_rpntr_g;
    wire [DATA_WIDTH:0] rq2_wpntr_g;

    wire wfull;
	wire almost_wfull;
	wire rempty;
	wire [DATA_WIDTH-1 :0]rdata;
	wire [DATA_WIDTH-1 :0]wdata;
	wire almost_rempty;
    wire [DATA_WIDTH:0] wpntr;
    wire [DATA_WIDTH:0] rpntr;
    wire [DATA_WIDTH-1:0] waddr;
    wire [DATA_WIDTH-1:0] raddr;
    wire [DATA_WIDTH:0] wq2_rpntr;
    wire [DATA_WIDTH:0] rq2_wpntr;
    wire wclk;
	wire rclk;
	wire wbtn_out;
	wire rbtn_out;
	wire rinc;
	wire winc;
    
	wire addr_en;
	wire [ADDR_WIDTH-1: 0] addr; 

	wire wclk_en_wire;
	assign wclk_en_wire = winc & (!wfull);
    
    wire wdebt_in;
    wire rdebt_in;
	

    
//-----------------------WRITE DOMAIN------------------------

    clock_divider #(
		.DIVIDE_RATE (100),		
		.N_BIT (8)
    )clock_divider_wclk_inst(							
		.clk(clk),
		.rst_n(rst_n),
		.clk_out(wclk)
	);
	
   
   
	edge_detector 
	edge_detector_write_inst(
		.clk(wclk),
		.rst_n(rst_n),
		.det_in(wdebt_in),
		.det_edge(wbtn_out)
	);
    

    debouncer #(
	.SHIFT_REG (SHIFT_REG),					
	.SUFFICIENT_NUMBER_OF_ONES (SUFFICIENT_NUMBER_OF_ONES),	
	.ONES_COUNT_BIT (ONES_COUNT_BIT)
   ) deb_write_inst(
	.clk(clk),
	.clk_out(wclk),
	.rst_n(rst_n),
	.btn_in(wbtn_in),
	.btn_out(wdebt_in)
   );
    
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
		.rst_n (rst_n),
		.pntr_in(gray_writer),
		.pntr_out(rq2_wpntr_g)
	);
	
	gray2bin #(
		.DATA_WIDTH(DATA_WIDTH)
    )gray2bin_inst_w (
		.gray(rq2_wpntr_g),
		.bin(rq2_wpntr)
	);
	
//-----------------------READ DOMAIN------------------------	
	
	    clock_divider #(
		.DIVIDE_RATE (20),		
		.N_BIT (8)
    )clock_divider_rclk_inst(							
		.clk(clk),
		.rst_n(rst_n),
		.clk_out(rclk)
	);
	
	edge_detector 
	edge_detector_read_inst(
		.clk(rclk),
		.rst_n(rst_n),
		.det_in(rdebt_in),
		.det_edge(rbtn_out)
	);
	
	read_controller 
	read_controller_inst(
		.clk(rclk),
		.rst_n(rst_n),
		.rempty(rempty),
		.rbtn_out(rbtn_out),
		.rinc(rinc)
	);
	
	
	   debouncer #(
		.SHIFT_REG (SHIFT_REG),					
		.SUFFICIENT_NUMBER_OF_ONES (SUFFICIENT_NUMBER_OF_ONES),	
		.ONES_COUNT_BIT (ONES_COUNT_BIT)
   ) deb_read_inst(
		.clk(clk),
		.clk_out(rclk),
		.rst_n(rst_n),
		.btn_in(rbtn_in),
		.btn_out(rdebt_in)
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
		.rst_n (rst_n),
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
		.rst_n(rst_n),
		.winc(winc),
		.wq2_rpntr(wq2_rpntr),
		.wfull(wfull),
		.almost_wfull(almost_wfull),
		.wpntr(wpntr),
		.waddr(waddr)
		);
	
	
	read_pntr_handler #(
		.DATA_WIDTH(DATA_WIDTH)
    )read_pntr_handler_inst_r (
		.rclk(rclk),
		.rst_n(rst_n),
		.rinc(rinc),
		.rq2_wpntr(rq2_wpntr),
		.rempty(rempty),
		.almost_rempty(almost_rempty),
		.rpntr(rpntr),
		.raddr(raddr)
	);
	
	
	FIFO_memory #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH)
	) FIFO_memory_inst(
		.wdata(wdata),
		.rdata(rdata),
		.raddr(raddr),
		.waddr(waddr),
		.rst_n(rst_n),
		.rinc(rinc),
		.wclk(wclk),
		.wclk_en(wclk_en_wire),
		.rclk(rclk)
	);
	
	lut_rom #(
		.DATA_WIDTH(DATA_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH)
	)lut_rom_inst(
		.rom_clk(wclk),
		.rst_n(rst_n),
		.data_out(wdata),
		.addr(addr),
		.addr_en(addr_en)
	);
	
	
	fifo_fsm 
	fifo_fsm_inst(
		.clk(wclk),
		.wfull(wfull),
		.rst_n(rst_n),
		.wbtn_out(wbtn_out),
		.write_fsm_busy(write_fsm_busy),
		.addr_en(addr_en),
		.winc(winc),
		.addr(addr)
	);
	
	
	
	always @(*) begin
        led <= 7'b0; 
        if (SW[6 : 0] == 7'h00) begin
            led <= rdata;
        end 
        else if (SW[6 : 0] == 7'h01) begin
            led[0] <= wfull;
            led[1] <= rempty;
            led[2] <= write_fsm_busy;
            led[3] <= wbtn_out;
            led[4] <= rbtn_out;
        end
    end
    
    ILA_Write
    (
        .clk(wclk),
        .probe0(wdebt_in),
        .probe1(winc),
        .probe2(wfull),
        .probe3(addr),
        .probe4(wdata)
     );
        
     ILA_Read
    (
        .clk(rclk),
        .probe0(rbtn_out),
        .probe1(rinc),
        .probe2(rempty),
        .probe3(rdata)
     );
      
     endmodule
