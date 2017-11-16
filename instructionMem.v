module instructionMem( readAdr,readData);
	
	input [15:0] readAdr;
	output reg [15:0]	readData;

	reg [15:0] mem [0:15];
	
	always @ (*) begin
		readData = mem[readAdr];
	end

	integer i;
	initial begin 
		for(i=0;i<16;i=i+1)
			mem[i] = 0;

		$readmemb("test3.list", mem);

		//for(i=0;i<35;i=i+1)begin
		//				$display("mem[%d]= %b. PC = %b" ,i,mem[i] ,readAdr );
		//end
	end



endmodule 
