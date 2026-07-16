/*
 * File Name       : fifo_fsm.v
 * Project Name    : FINITE STATE MACHONE DESIGN FOR SYSTEM
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [13/07/2026]
 * 
 * Comment     	   : 
*/


module fifo_fsm (
	input wire clk,
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
	reg wbtn_en;

	always @(posedge wbtn_out or negedge wrst_n) begin
		if(!wrst_n) begin
			wbtn_en <= 1'b0;
		end else begin
			wbtn_en <= 1'b1;
		end
	end

    
    always @(posedge clk or negedge wrst_n) begin
		if(!wrst_n) begin
			current_state <= IDLE;
			winc <= 1'b0;
			addr_en <= 1'b0;
			write_fsm_busy <= 1'b0;
		end else begin
			winc <= 1'b0;
			addr_en <= 1'b0;
		case (current_state)
            IDLE: begin
				write_fsm_busy <= 1'b0;
				if(wbtn_en) begin
					if(!wfull) begin
						winc <= 1'b1;
						addr_en <= 1'b1;
					end
					current_state <= WRITE;	
				end
            end

            WRITE: begin
				write_fsm_busy <= 1'b1;
					if (wbtn_en) begin
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


	
