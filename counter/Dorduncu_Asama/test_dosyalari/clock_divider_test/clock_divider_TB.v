

`timescale 1ns / 1ps

module clock_divider_TB();

    reg clk, rst;
    wire clk_out;

    clock_divider uut (
        .clk(clk),
        .rst(rst), 
        .clk_out(clk_out)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        
        #20;
        rst = 0;
        
        #1000;
        $stop;
    end

endmodule