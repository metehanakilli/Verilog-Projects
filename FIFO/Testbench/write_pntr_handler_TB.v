

module write_pntr_handler_TB();
parameter DATA_WIDTH=5'd5;

reg winc;
reg wrst_n;
reg wclk;
reg [DATA_WIDTH:0] wq2_rpntr;

wire wfull;
wire [DATA_WIDTH:0]wpntr;
wire [DATA_WIDTH-1:0]waddr;

write_pntr_handler #(
.DATA_WIDTH(5)
) uut(
.winc(winc),
.wclk(wclk),
.wrst_n(wrst_n),
.wq2_rpntr(wq2_rpntr),
.wfull(wfull),
.wpntr(wpntr),
.waddr(waddr)
);

initial begin
wclk=0;
end
always #5 wclk = ~wclk;

initial begin


	
	
	winc=0;
	wrst_n=0;
	wq2_rpntr=0;
	
	#20;
	wrst_n=1;
	#10;
	
	winc=1;
	#30;
	winc=0;
	#10;
	
	
	
	winc=1;
	#310;
	
	
	
	
	#20;
	winc=0;
	#10;
	
	wq2_rpntr=6'b000001;
	#10;
	
	
	winc=1;
	#10;
	winc=0;
	#10;
	
	
	#50;
	$finish;
end
initial begin
	$monitor("Time = %0t | wrst_n=%b |winc=%b |wq2_pntr=%b |wpntr=%b |waddr=%b |wfull=%b",
			$time,wrst_n,winc,wq2_rpntr,wpntr,waddr,wfull);
			end
endmodule
