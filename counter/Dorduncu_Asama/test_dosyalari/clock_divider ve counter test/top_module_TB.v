`timescale 1ns / 1ps

module top_module_TB();

    reg clk;
    reg rst;
    reg direction;
    wire [3:0] cntr;
	
    top_module uut (
        .clk(clk),
        .rst(rst),
        .direction(direction),
        .cntr(cntr)
    );
	
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        direction = 1;
        
        #20;
        rst = 0;
		
        #200;
        direction = 0;
        
        #200;
        $stop;
    end

endmodule