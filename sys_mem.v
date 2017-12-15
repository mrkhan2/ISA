module sys_mem(clk, rst_n, fetch, re, we, writeData, iaddr, daddr, instruction, readData, ready);

input [15:0] iaddr, daddr, writeData;
input clk, rst_n, re, we, fetch;

output [15:0] instruction, readData;
output ready;

wire IMwe,DMwe,Memwe,Memre,memRd,IMhit,DMhit,IDI,DDI,IDO,DDO;

wire [7:0] 	i_tag,d_tag;

wire [13:0] Memaddr;	

wire [63:0] IO,DO,MO, II,DI;

cache Icache(
	.clk(clk),
	.rst_n(rst_n),
	.addr(iaddr[15:2]),
	.wr_data(II),
	.wdirty(IDI),
	.we(IMwe),
	.re(fetch),

	.rd_data(IO),
	.tag_out(i_tag),
	.hit(IMhit),
	.dirty(IDO)
);

cache Dcache(
	.clk(clk),
	.rst_n(rst_n),
	.addr(daddr[15:2]),
	.wr_data(DI),
	.wdirty(DDI),
	.we(DMwe),
	.re(re | we),

	.rd_data(DO),
	.tag_out(d_tag),
	.hit(DMhit),
	.dirty(DDO)
);

cache_control cacheControl(
	.clk(clk), 
	.rst_n(rst_n),
	.fetch(fetch),
	.IMhit(IMhit), 
	.DMhit(DMhit), 
	.d_dirty(DDO),
	.memRd(memRd), 
	.re(re), 
	.we(we),
	.d_tag(d_tag),
	.iaddr(iaddr), 
	.daddr(daddr), 
	.writeData(writeData),
	.IO(IO),
	.DO(DO), 
	.MO(MO),

	.Memre(Memre),
	.IMwe(IMwe),
	.DMwe(DMwe),	
	.Memwe(Memwe),
	.IDI(IDI),
	.DDI(DDI),
	.ready(ready),
	.Memaddr(Memaddr),
	.i_data(II),
	.d_data(DI),
	.instruction(instruction),
	.readData(readData)
);



endmodule