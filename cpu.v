module cpu(clk, rst_n, hlt, pc);

//** DEFINE I/O INTERFACE **//
input clk;        	// Global clock signal
input rst_n;      	// Reset signal, active on low
output reg hlt;       	// Halt signal
output reg [15:0] pc; 	// Program counter

wire Z, N,V,br;
wire [15:0] operation, input1, input2, result, dmResult, writeResult;
reg [15:0] store, addr;
wire [3:0] Rs, Rd, Rt;
wire[ 7:0] ctrl_signals;
wire[2:0] cond;
wire [15:0] pc_incr, jReg, jCall ,brVal;
wire [11:0] call;
wire [8:0] imm;




//PROGRAM COUNTER
always @(posedge clk or negedge rst_n) begin 

		if(~rst_n || hlt)
			pc = 16'b0;
			else 
			if(ctrl_signals[5])
				pc = $signed(jReg);
		else	if(ctrl_signals[4])
				pc = $signed(jCall);

		else	if(br && ctrl_signals[6])
				pc = $signed(brVal);


		else pc= pc_incr;
		
			store = ctrl_signals[1] ? dmResult : result;
			addr = result;
			hlt = ctrl_signals[3];


		$display(" operation = %h \n   \ninput1 = %h\n dmResult = %h  \nresult = %h ", operation, input1, dmResult, result);

	end


//BEGIN SINGLE CYCLE 

instructionMem IM(
 .readAdr(pc),
 .readData(operation)	
 );


Control CONTROL(
.operation(operation),
.rd(Rd), 
.rs(Rs), 
.rt(Rt),
.cond(cond), 
.ctrl_signals(ctrl_signals),
.call(call),
.imm(imm)
);




rf regFile(
.clk(clk),
.Rd(Rd),
.Rs(Rs),
.Rt(Rt),
.outRs(input1),
.outRt(input2),
.writeData(store),
.we(ctrl_signals[0]),
.hlt(hlt)
);
	

ALU alu(
.operation(operation),
.input1(input1),
.input2(input2),
.result(result),
.Z(Z),
.N(N),
.V(V),
.pc(pc)
);	

dataMem DM (
.adr(addr),
.readData(dmResult),
.writeEn(ctrl_signals[2]),
.writeData(input2) 
);

assign pc_incr = pc+1;
assign jReg = $signed(result);
assign jCall = pc+ 1+ $signed(operation[11:0]);
assign brVal = pc+1+$signed(operation[8:0]);





branch BRANCH(
.cond(cond),
.N(N),
.V(V),
.Z(Z),
.br(br)
);











endmodule
