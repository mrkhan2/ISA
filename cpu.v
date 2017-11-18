module cpu(clk, rst_n, hlt, pc);

//** DEFINE I/O INTERFACE **//
input clk;        	// Global clock signal
input rst_n;      	// Reset signal, active on low
output reg hlt;       	// Halt signal
output reg [15:0] pc; 	// Program counter

wire Z, N,V,br;
wire [15:0] operation, input1, input2, result, dmResult, writeResult;
reg [15:0] store, addr, counter, id_ex2, id_ex1 , ex_memResult , ex_mem2;
reg [3:0] ex_memRD, mem_wbRd, id_exRd, id_exRs, id_exRt;
wire [3:0] Rs, Rd, Rt;
wire[ 7:0] ctrl_signals;
wire[2:0] cond;
wire [15:0] pc_incr, jReg, jCall ,brVal;
wire [11:0] call;
wire [8:0] imm;
wire [1:0] forwardA, forwardB;

initial 
begin
counter = 1;
end

//PROGRAM COUNTER
always @(posedge clk or negedge rst_n) begin 
counter++;
		if (hlt) begin
			pc = pc;
			end

		if(~rst_n) begin
			ex_memRD  = 4'h0;
			mem_wbRd  = 4'h0;
			id_exRd  = 4'h0;
			id_exRt  = 4'h0;
			id_exRs  = 4'h0;
			id_ex1 = 16'h0000;
			id_ex2 = 16'h0000;
			ex_memResult = 16'h0000;
			ex_mem2 = 16'h0000;		
			pc = 16'b0;
		end else if(ctrl_signals[5])
				pc = $signed(jReg);
			else if(ctrl_signals[4])
				pc = $signed(jCall);
			else if(br && ctrl_signals[6])
				pc = $signed(brVal);
			else pc= pc_incr;
		
			store =result;
			addr = result;
			hlt = ctrl_signals[3];
			id_exRd	 = Rd;
			id_exRs	 = Rs;
			id_exRt	 = Rt;
			id_ex1 	  = input1;
			id_ex2    = input2;
			ex_memResult = result;
			ex_mem2 = forward2;
			ex_memRD = id_exRd;
			mem_wbRd = ex_memRD;

		
		//$display("counter = %d\n" , counter);
		//$display(" operation = %h \n   \ninput1 = %h\n dmResult = %h  \nresult = %h ", operation, input1, dmResult, result);

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



hazard hdu(
	.opcode(operation[12:9]),
	.if_id_rs(id_exRs), 
	.if_id_rt(id_exRt), 
	.id_ex_rt(id_exRd), 
	.id_ex_mr(ctrl_signals[0]), 

	.pc_write(pc_write), 
	.if_id_write(ctrl_signals[2]), 
	.stall(stall)
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
.hlt(hlt),
.counter(counter)
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



// FORWARDING UNIT
forward forward_unit(
	.id_ex_rt(id_exRt), 
	.id_ex_rs(id_exRs), 
	.ex_mem_rd(ex_memRD), 
	.mem_wb_rd(mem_wbRd), 
	.ex_mem_rw(ctrl_signals[2]), 
	.mem_wb_rw(ctrl_signals[2]), 

	.forwarda(forwardA), 
	.forwardb(forwardB)
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

// FORWARDING 
assign forward1 = (forwardA == 2'b00)  ? id_ex1 :(forwardA == 2'b01) ? ex_memResult : (forwardA == 2'b10) ? store : id_ex1;
assign forward2 = (forwardB == 2'b00)  ? id_ex2 : (forwardB == 2'b01) ? ex_memResult : (forwardB == 2'b10) ? store : id_ex2;




branch BRANCH(
.cond(cond),
.N(N),
.V(V),
.Z(Z),
.br(br)
);









endmodule
