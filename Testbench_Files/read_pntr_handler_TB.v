

module read_pntr_handler_TB();
parameter DATA_WIDTH=5'd5;

reg rinc;
reg rrst_n;
reg rclk;
reg [DATA_WIDTH:0] rq2_wpntr;

wire rempty;
wire [DATA_WIDTH:0]rpntr;
wire [DATA_WIDTH-1:0]raddr;

read_pntr_handler #(
	.DATA_WIDTH(5'd5)
) uut(
	.rinc(rinc),
	.rclk(rclk),
	.rrst_n(rrst_n),
	.rq2_wpntr(rq2_wpntr),
	.rempty(rempty),
	.rpntr(rpntr),
	.raddr(raddr)
);

initial begin
	rclk=0;
end
always #5 rclk = ~rclk;

initial begin


	
	
	rinc=0;
	rrst_n=0;
	rq2_wpntr=0;
	
	#20;
	rrst_n=1;
	#10;
	
	rinc=1;
	#30;
	rinc=0;
	#10;
	
	
	
	rinc=1;
	#310;
	
	
	
	
	#20;
	rinc=0;
	#10;
	
	rq2_wpntr=6'b000001;
	#10;
	
	
	rinc=1;
	#10;
	rinc=0;
	#10;
	
	
	#50;
	$finish;
end
initial begin
	$monitor("Time = %0t | rrst_n=%b |rinc=%b |rq2_wntr=%b |rpntr=%b |raddr=%b |rempty=%b",
			$time,rrst_n,rinc,rq2_wpntr,rpntr,raddr,rempty);
			end
endmodule
