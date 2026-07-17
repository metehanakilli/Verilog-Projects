/*
 * File Name       : edge_detector.v
 * Project Name    : EDGE DETECTOR FOR READ BUTTON
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [13/07/2026]
 * 
 * Comment     	   : 
*/


module edge_detector(
    input wire clk,        // SYSTEM CLOCK 100MHz
    input wire rst_n,
    input wire det_in,     // WILL BE CONNECTED WITH rbtn_out IN TOP MODULE
    output wire det_edge   // DETECTED EDGE FROM btn_out
);
    reg det_in_delay;      // Delayed version of the INPUT signal (not the clock)

    always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			det_in_delay <= 0;
		end else begin
			det_in_delay <= det_in;
		end
    end
    assign det_edge = det_in & ~det_in_delay;
endmodule
