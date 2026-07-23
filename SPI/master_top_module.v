/*
 * File Name       : master_top_module.v
 * Project Name    : Master of SPI Communication
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [23/07/2026]
 * 
 * Comment     : 
*/

module master_top_module
#(  parameter DATA_WIDTH = 8'd8

)(  
	input wire clk,							//SYSTEM CLOCK (100MHz)
	input wire rst_n,						//SYSTEM RESET: ACTIVE-LOW
	
	input wire btn_tx_in;
	input wire btn_cfg_in;
	input wire [7:0] SW;
	
	input wire miso_data,					//DATA LINE FROM THE SLAVE TO THE MASTER
	
	output wire cs_n,						//CHIP SELECT SIGNAL ENABLE COMMUNICATION WITH A SPESIFIC SLAVE: ACTIVE-LOW
	output wire sclk,						//SERIAL CLOCK TO SYNCHRONIZE DATA TRANSFER
	output reg mosi_data					//DATA LINE FROM THE MASTER TO THE SLAVE
);




	reset_synchronizer 
    reset_synchronizer_inst(
        .clk(clk),
        .async_rst_n(rst_n),
        .sync_rst_n(rst_n_clk)
	);

    
    clock_divider #(							//CLOCK FOR DEBOUNCERS 
		.DIVIDE_RATE (500000),		
		.N_BIT (27)
    )clock_divider_deb_inst(							
		.clk(clk),
		.rst_n(rst_n_clk),
		.clk_out(deb_clk)
	);
    

    debouncer #(
		.SHIFT_REG(SHIFT_REG),										
		.SUFFICIENT_NUMBER_OF_ONES(SUFFICIENT_NUMBER_OF_ONES),
		.ONES_COUNT_BIT(ONES_COUNT_BIT)	
   ) deb_btn_tx_inst(
		.clk(clk),
		.clk_out(deb_clk),
		.rst_n(rst_n_clk),
		.btn_in(btn_tx_in),
		.btn_out(btn_tx_deb)
   );


	edge_detector 
	edge_detector_btn_tx_inst(
		.clk(clk),
		.rst_n(rst_n_clk),
		.det_in(btn_tx_deb),
		.det_edge(btn_tx)
	);


    debouncer #(
		.SHIFT_REG(SHIFT_REG),										
		.SUFFICIENT_NUMBER_OF_ONES(SUFFICIENT_NUMBER_OF_ONES),
		.ONES_COUNT_BIT(ONES_COUNT_BIT)	
   ) deb_btn_cfg_inst(
		.clk(clk),
		.clk_out(deb_clk),
		.rst_n(rst_n_clk),
		.btn_in(btn_cfg_in),
		.btn_out(btn_cfg_deb)
   );


	edge_detector 
	edge_detector_btn_cfg_inst(
		.clk(clk),
		.rst_n(rst_n_clk),
		.det_in(btn_cfg_deb),
		.det_edge(btn_cfg)
	);


	master_controller#(
	
	)master_controller_inst(
	
	);
	
	
	spi_master#(
	
	)spi_master_inst(
	
	);
	
	
	
    
endmodule
