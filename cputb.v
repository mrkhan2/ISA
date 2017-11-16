module cpvTB ();

reg clk;        	// Global clock signal
reg rst_n;      	// Reset signal, active on low
wire hlt;       	// Halt signal
wire [15:0] pc; 	// Program counter


cpu CPU(
	.clk(clk), 
	.rst_n(rst_n),
	.hlt(hlt),
	.pc(pc)
	);



always #5 clk = ~clk;

initial begin
	clk = 0;
	rst_n = 1;
	#1 rst_n = 0;
	#5 rst_n = 1;
	#200
	$finish;


end



always@*	
begin
//$monitor("time = %2d hlt= %b" , $time, hlt  );
end

endmodule