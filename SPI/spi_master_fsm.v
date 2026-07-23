/*
 * File Name       : master_controller_fsm.v
 * Project Name    : Master of SPI Communication
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [23/07/2026]
 * 
 * Comment     : 
*/

module master_controller_fsm
#(  parameter DATA_WIDTH = 8'd8,
	parameter ADDR_WIDTH = 7'd7,
	parameter SPI_PACKAGE_BIT = 16,
	parameter DIVIDE_RATE = 5,
	parameter N_BIT = 4
)(  
	input wire clk,												//SYSTEM CLOCK (100MHz)
	input wire rst_n_clk,										//SYSTEM RESET: ACTIVE-LOW
	
	input wire btn_tx,											//TRANSFER BUTTON (AFTER 2 TIME TRIGGERED ENABLE TRANSFER)
	input wire btn_cfg,											//CONFIGURATION BUTTON (ENABLES CHANGE CONFIGURATION OF SPI)
	input wire [7:0] sw,										//SWITCHES (GIVES OPERATION INFORMATIONS)

	
	input wire miso_data,										//DATA LINE FROM THE SLAVE TO THE MASTER (TRANSFERS DATA BIT BY BIT)	
	output wire mosi_data										//DATA LINE FROM THE MASTER TO THE SLAVE
	output wire cs_n,											//CHIP SELECT SIGNAL ENABLE COMMUNICATION: ACTIVE-LOW
	output wire sclk,											//CREATED SPI CLOCK (20MHz)
	
	output wire [DATA_WIDTH-1: 0] rdata,						//THE READ DATA AFTER PARSING spi_miso_package THAT COMING FROM SLAVE
	output wire rdata_en,										//IF STATE DONE HAPPENED --> rdata_en= '1' MEANS DATA IS READY FOR READ

);

//------------------------------------------------------------------------------------------------------------------------------------	
	wire [N_BIT-1 : 0] counter_clk;		  						//REGISTER FOR DIVIDE SYSTEM CLOCK, CREATES sclk
	
	always @(posedge clk or negedge rst_n_clk) begin: create_sclk
		if (!rst_n_clk) begin										//IF rst_n TRIGGERED --> RESET THE counter AND sclk
			counter_clk <= 0;
			sclk <= 0;
		end else begin
			if (counter_clk >= (DIVIDE_RATE >> 1) - 1) begin
				counter_clk <= 0;
				sclk <= ~sclk;				
			end else begin
				counter_clk <= counter_clk + 1'd1;
			end
		end
	end
//------------------------------------------------------------------------------------------------------------------------------------	
	
	localparam IDLE  = 3'd0;
    localparam LATCH_ADDR  = 3'd1;
	localparam WAIT_DATA  = 3'd2;
	localparam LOAD_DATA  = 3'd3;
	localparam LOAD_CFG  = 3'd4;
	localparam TRANSMIT  = 3'd5;
	localparam DONE  = 3'd6;
	
	reg [2:0] current_state;						
	reg [2:0] next_state; 
	
	reg [ADDR_WIDTH-1:0] latched_addr;  
	reg latched_rw;
	
	reg [DATA_WIDTH-1:0] tx_shift_reg;
	reg [DATA_WIDTH-1:0] rx_shift_reg;
	
	reg [1:0] current_spi_mode;
	reg [1:0] next_spi_mode;
	
	reg cfg_update_flag;

	
    always @(posedge clk or negedge rst_n_clk) begin
        if(!rst_n_clk) begin
            current_state <= IDLE;
			cs_n <= 1;
			mosi_data <= 0;
			shift_reg <=0;
			
        end else begin
            case (current_state)						
                IDLE: begin
						
                end
				
				LATCH_ADDR: begin
					
				end

                WAIT_DATA: begin
					
                end 
				
				LOAD_DATA: begin
                    
                end
				
				LOAD_CFG: begin
                    
                end
				
				TRANSMIT: begin
                    
                end
				
				DONE: begin
                    
                end
                    
					
					default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end 
	
	
	
	
	
	
	
endmodule
	
	
	

