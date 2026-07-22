/*
 * File Name       : fifo_fsm.v
 * Project Name    : FINITE STATE MACHONE DESIGN FOR SYSTEM
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [13/07/2026]
 * 
 * Comment     	   : FINITE STATE MACHINE FOR FIFO
*/


module fifo_fsm #(
    parameter ADDR_WIDTH = 7
)(
    input wire clk,										//SYSTEM CLOCK : 100MHz
    input wire rst_n,									//SYSTEM RESET : ACTIVE-LOW
    input wire wfull,									//FULL FLAG FOR FIFO								
    input wire wbtn_out,								//DEBOUNCED BUTTON FOR WRITE
    output reg write_fsm_busy,							//BUSY FLAG FOR FSM
    output reg addr_en,									//ENABLE SIGNAL FOR READ DATA FROM ROM
    output reg winc,									//ENABLE SIGNAL FOR WRITE
    output reg [ADDR_WIDTH:0] addr					
);
    
    localparam IDLE  = 2'd0;
    localparam SENT  = 2'd1;
	localparam WRITE  = 2'd2;
	
    reg [1:0] current_state;							


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            current_state <= IDLE;
            winc <= 1'b0;
            addr_en <= 1'b0;
            write_fsm_busy <= 1'b0;
            addr <= 0;
        end else begin
            case (current_state)						
                IDLE: begin								//FSM RESETS write_fsm_busy, winc and addr_en
                    write_fsm_busy <= 1'b0;				
                    winc <= 1'b0;
                    addr_en <= 1'b0;
                    if(wbtn_out && !wfull) begin                  //IF WRITE BUTTON TRIGGERED STATE ---> SENT
						current_state <= SENT;
                    end
                end
				
				SENT: begin								//FSM SENDS DATA FROM ROM TO FIFO FOW WRITE
					if(wfull) begin						//IF FIFO FULL, RESET addr ---> ROM ADRESS RESET
						winc <= 0;
						current_state <= IDLE;
                    end
					addr_en <= 1'b1;
					write_fsm_busy <= 1'b1;
					current_state <= WRITE;
				end

                WRITE: begin							//FSM WRITES DATA TO FIFO MEMORY TILL THE FIFO BEEN FULL
					if (!wfull) begin
                        winc <= 1'b1;
                        addr <= addr + 1'b1;
                        if(addr == (1 << ADDR_WIDTH)-1 ) begin
							current_state <= IDLE;
						end
                    end else begin 
                        winc <= 1'b0;
                        current_state <= IDLE;
                    end
                end 
                    default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end 
endmodule


	
