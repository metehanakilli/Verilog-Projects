/*
 * File Name       : fifo_fsm.v
 * Project Name    : FINITE STATE MACHONE DESIGN FOR SYSTEM
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [13/07/2026]
 * 
 * Comment     	   : 
*/


module fifo_fsm #(
    parameter ADDR_WIDTH = 7
)(
    input wire clk,
    input wire wfull,
    input wire wrst_n,
    input wire wbtn_out,
    output reg write_fsm_busy,
    output reg addr_en,
    output reg winc,
    output reg [ADDR_WIDTH-1:0] addr, //
    output reg read_mode_en   			//
);
    
    localparam IDLE  = 2'd0;		//
    localparam SENT  = 2'd1;
    localparam WRITE = 2'd2;
    localparam READ  = 2'd3;

    reg [1:0] current_state;
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
            addr <= 0;
            read_mode_en <= 1'b0;	//
        end else begin
            case (current_state)
                IDLE: begin
                    write_fsm_busy <= 1'b0;
                    winc <= 1'b0;
                    addr_en <= 1'b0;
                    read_mode_en <= 1'b0;	//
                    addr <= 0;

                    if(wbtn_en) begin
                        current_state <= SENT; 
                    end
                end

                SENT: begin				//
                    addr_en <= 1'b1;
                    write_fsm_busy <= 1'b1;
                    current_state <= WRITE;
                end

                WRITE: begin
                    if (!wfull) begin
                        winc <= 1'b1;
                        addr <= addr + 1'b1; 
                        
                        if (addr == (1 << ADDR_WIDTH) - 1) begin
                            current_state <= READ; 
                        end
                    end else begin
                        winc <= 1'b0;
                    end
                end 
                
                READ: begin					//
                    winc <= 1'b0;
                    write_fsm_busy <= 1'b0;
                    read_mode_en <= 1'b1;
                end
                
                default: begin
                    current_state <= IDLE;
                end
            endcase
        end
    end 
endmodule


	
