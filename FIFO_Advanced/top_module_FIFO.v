/*
 * Dosya Adi       : top_module_FIFO.v
 * Proje Adi       : TOP MODULE of FIFO
 * Yazar           : [METEHAN AKILLI / Sirket Adi]
 * Tarih           : [05/07/2026]
 * 
 * A??iklama        : Connects the submodules
*/

module top_module_FIFO #(
	parameter DATA_WIDTH = 8'd8,						//DATA WIDTH
	parameter ADDR_WIDTH = 7'd7,						//WIDTH THAT DECLARES THE ADDRES OF DATA
	parameter SHIFT_REG = 20,							//SHIFT REGISTER'S SAMPLE RATE FOR DEBOUNCER
	parameter SUFFICIENT_NUMBER_OF_ONES = 12,			//SUFFICIENT 1's COUNTED TO DECIDE BUTTON WAS REALLY PUSHED
	parameter ONES_COUNT_BIT = 5						//BIT NUMBER TO COUNT 1's
)(
    input wire clk,    									//SYSTEM CLOCK : 100MHz
    input wire rst_n,									//SYSTEM RESET : ACTIVE-LOW
    input wire rbtn_in,									//BUTTON INPUT TO READ OPERATION
    input wire wbtn_in,									//BUTTON INPUT TO WRITE OPERATION
	input wire [6:0] SW,								//SWICH INPUT TO DECIDE LED OUTPUTS SHOW THE DATA READ FROM MEMORY OR THE FLAGS(WFULL,REMPTY,..)
	output reg [6:0] led								//LED OUTPUT OF FPGA

);

    wire [DATA_WIDTH-1:0] gray_writer; 					//OUTPUT OF BINARY TO GRAY CONVERTER FROM WRITE POINTER HANDLER
    wire [DATA_WIDTH-1:0] gray_reader; 					//OUTPUT OF BINARY TO GRAY CONVERTER FROM READ POINTER HANDLER
    wire [DATA_WIDTH-1:0] wq2_rpntr_g;					//THE DATA COMES FROM READ POINTER HANDLER TO WRITE POINTER HANDLER (GRAY CODE)
    wire [DATA_WIDTH-1:0] rq2_wpntr_g;					//THE DATA COMES FROM WRITE POINTER HANDLER TO READ POINTER HANDLER (GRAY CODE)
    
    
    wire wclk;											//WRITE CLOCK MADE FROM SYSTEM CLOCK
	wire rclk;											//READ CLOCK MADE FROM SYSTM CLOCK
	wire deb_clk;										//CLOCK FOR DEBOUNCER WRITE AND READ BUTTONS
	wire wbtn_out;										//DEBOUNCED WRITE BUTTON OUTPUT
	wire rbtn_out;										//DEBOUNCED READ BUTTON OUTPUT
	wire rinc;											//INSTANCE FOR READ OPERATİON
	wire winc;											//INSTANCE FOR WRITE OPERATION
    wire wfull;											//FIFO IS FULL FLAG
	wire almost_wfull;									//FIFO IS ALMOST FULL FLAG
	wire rempty;										//FIFO IS EMPTY FLAG
	wire almost_rempty;									//FIFO IS ALMOST EMPTY FLAG
	
	
    wire [DATA_WIDTH-1:0] wpntr;						//POINTER OF DATA WRITE TO FIFO DUAL PORT RAM(POINTER BIT + ADDRES OF WRITING)
    wire [DATA_WIDTH-1:0] rpntr;						//POINTER OF DATA READ FROM FIFO DUAL PORT RAM(POINTER BIT + ADDRESS OF READING)
    wire [DATA_WIDTH-1:0] wq2_rpntr;					//THE DATA COMES FROM READ POINTER HANDLER TO WRITE POINTER HANDLER (BINARY)
    wire [DATA_WIDTH-1:0] rq2_wpntr;					//THE DATA COMES FROM WRITE POINTER HANDLER TO READ POINTER HANDLER (BINARY)
    wire [DATA_WIDTH-2:0] waddr;						//ADDRES OF DATA WROTE
    wire [DATA_WIDTH-2:0] raddr;						//ADDRES OF DATA READ
    wire [DATA_WIDTH-1 :0]rdata;						//DATA READ FROM FIFO DUAL PORT RAM
	wire [DATA_WIDTH-1 :0]wdata;						//DATA WRITE TO FIFO DUAL PORT RAM
    
	wire addr_en;										//IT MAKES ADDRES TO INCREASE WITH A CONTROL MECHANİSM
	wire [ADDR_WIDTH: 0] addr; 						    //ADDRES OF DATA WE TAKE FROM LUT ROM

	wire wclk_en_wire;									//IT ENABLES THE WRITING OPERAQTION FOR FIO DUAL PORT RAM
	assign wclk_en_wire = winc & (!wfull);				//WCLK_EN_WIRE LOGIC DESCRIPTION
    
    wire wdebt_in;										//THE WIRE BETWEEN DEBOUNCER AND EDGE DETECTOR OF WRITE
    wire rdebt_in;										//THE WIRE BETWEEN DEBOUNCER AND EDGE DETECTOR OF READ
	
    
//-----------------------WRITE DOMAIN------------------------

    clock_divider #(
		.DIVIDE_RATE (20),		
		.N_BIT (5)
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
    
    
    clock_divider #(							//CLOCK DIVIDER FOR DEBOUNCER WRITE AND READ BUTTON
		.DIVIDE_RATE (100000),		
		.N_BIT (20)
    )clock_divider_deb_inst(							
		.clk(clk),
		.rst_n(rst_n),
		.clk_out(deb_clk)
	);
    

    debouncer #(
		.SHIFT_REG(SHIFT_REG),										
		.SUFFICIENT_NUMBER_OF_ONES(SUFFICIENT_NUMBER_OF_ONES),
		.ONES_COUNT_BIT(ONES_COUNT_BIT)	
   ) deb_write_inst(
		.clk(clk),
		.clk_out(deb_clk),
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
		.DIVIDE_RATE (100),		
		.N_BIT (7)
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
		.SHIFT_REG(SHIFT_REG),										
		.SUFFICIENT_NUMBER_OF_ONES(SUFFICIENT_NUMBER_OF_ONES),
		.ONES_COUNT_BIT(ONES_COUNT_BIT)
   ) deb_read_inst(
		.clk(clk),
		.clk_out(deb_clk),
		.rst_n(rst_n),
		.btn_in(rbtn_in),
		.btn_out(rdebt_in)
   );
	
	
	bin2gray #(										//BINARY TO GRAY CODE CONVERTER FOR "read_pntr_handler"
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
		.wclk_en(wclk_en_wire),
		.clk(clk)
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
	
	
//-----------------------PHYSICAL ASSIGNMENTS------------------------		
	
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


//----------------------CALLING ILA IP-------------------------
    
    ILA_Write
    ILA_Write_inst(
        .clk(wclk),
        .probe0(wdebt_in),
        .probe1(winc),
        .probe2(wfull),
        .probe3(addr),
        .probe4(wdata)
     );
        
     ILA_Read
    ILA_Read_inst(
        .clk(rclk),
        .probe0(rbtn_out),
        .probe1(rinc),
        .probe2(rempty),
        .probe3(rdata)
     );
      
     endmodule
