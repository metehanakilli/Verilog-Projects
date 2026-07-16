/*
 * File Name       : FIFO_memory.v
 * Project Name    : DUAL PORT BRAM
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [09/07/2026]
 * 
 * Comment     : 
*/


module FIFO_memory #(
	parameter DATA_WIDTH = 5'd5,
	parameter ADDR_WIDTH = 5'd5
)(
	input wire wclk,
	input wire rclk,
	input wire rst_n,
	input wire wclk_en,
	input wire rinc,
	input wire [DATA_WIDTH-1 : 0] wdata,
	output reg [DATA_WIDTH-1 : 0]rdata
);
	reg [DATA_WIDTH-1 : 0] ram [0 : (1<<ADDR_WIDTH)-1];
	reg [ADDR_WIDTH-1 : 0] waddr;
	reg [ADDR_WIDTH-1 : 0] raddr;
	
	always @(posedge wclk or negedge rst_n) begin
		if(!rst_n) begin
			waddr 				<= 0;			
		end else begin
			if(wclk_en) begin
				waddr 			<= waddr + 'b1;
			end
		end
	end
	

	always @(posedge rclk or negedge rst_n) begin
		if(!rst_n) begin
			raddr 		<= 0;
		end else begin
			if(rinc) begin
				raddr 	<= raddr + 'b1;
			end
		end
	end
	
	always @(posedge wclk) begin
        if (wclk_en) begin
            ram[waddr] <= wdata;
        end
    end


    always @(posedge rclk) begin
        if (rinc) begin
            rdata <= ram[raddr];
        end
    end
	
endmodule
