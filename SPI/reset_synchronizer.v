/*
 * File Name       : reset_synchronizer.v
 * Project Name    : Reset Synchronizer
 * Author          : [METEHAN AKILLI / Sirket Adi]
 * Date            : [21/07/2026]
 * 
 * Comment         : Synchronizes asynchronous reset input
*/


module reset_synchronizer (
    input wire clk,
    input wire async_rst_n,
    output reg sync_rst_n
);
    reg rst_ff;

    // Asynchron assertion, Synchron deassertion
    always @(posedge clk or negedge async_rst_n) begin
        if (!async_rst_n) begin
            rst_ff     <= 1'b0;
            sync_rst_n <= 1'b0;
        end else begin
            rst_ff     <= 1'b1;
            sync_rst_n <= rst_ff;
        end
    end
endmodule