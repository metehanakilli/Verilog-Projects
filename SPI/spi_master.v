/*
 * File Name       : spi_master.v
 * Project Name    : Master of SPI Communication
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [23/07/2026]
 * 
 * Comment     : 
*/

module spi_master
#(  parameter DATA_WIDTH = 8'd8

)(  
	input wire miso_data,					//DATA LINE FROM THE SLAVE TO THE MASTER
	input wire rst_n_clk,						//SYSTEM RESET: ACTIVE-LOW
	input reg [2:0] SW,
	
	output wire ssel,						//CHIP SELECT SIGNAL ENABLE COMMUNICATION WITH A SPESIFIC SLAVE: ACTIVE-LOW
	output wire sclk,						//SERIAL CLOCK TO SYNCHRONIZE DATA TRANSFER
	output reg mosi_data					//DATA LINE FROM THE MASTER TO THE SLAVE
);
	reg [DATA_WIDTH-1:0] shift_reg;
	
	reg []current_state
	
	
	
	
	

