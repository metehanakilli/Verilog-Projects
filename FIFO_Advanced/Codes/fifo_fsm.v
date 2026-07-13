/*
 * File Name       : fifo_fsm.v
 * Project Name    : FINITE STATE MACHONE DESIGN FOR SYSTEM
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [13/07/2026]
 * 
 * Comment     	   : 
*/


module fifo_fsm (
	input wire wclk,
	input wire wfull,
	input wire wrst_n,
	input wire wbtn_out,
	output reg write_fsm_busy,
	output reg addr_en,
	output reg winc
);
    
	localparam IDLE  = 1'b0;
	localparam WRITE = 1'b1;

    reg current_state;

    
    always @(posedge wclk or negedge wrst_n) begin
		if(!wrst_n) begin
			current_state <= IDLE;
			winc <= 1'b0;
			addr_en <= 1'b0;
			write_fsm_busy <= 1'b0;
		end else begin
		
		case (current_state)
            IDLE: begin
				winc <= 1'b0;
				addr_en <=0;
				write_fsm_busy <= 1'b0;
				if(wbtn_out) begin
					current_state <= WRITE;	
				end
            end

            WRITE: begin
				write_fsm_busy <= 1'b1;
                if (wfull == 1'b0) begin
                    winc <= 1'b1;
                    addr_en <= 1'b1;
                end else begin
                    addr_en <=0;
                    winc <= 1'b0;
                    current_state <= IDLE;
                end
            end
            
            default: begin
				current_state <= IDLE;
				winc <= 1'b0;
				addr_en <=0;
				write_fsm_busy <= 1'b0;
			end
        endcase
        end
    end 
endmodule


	
