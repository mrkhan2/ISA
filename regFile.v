module rf(clk, Rs, Rt, Rd, outRs, outRt, writeData, we, hlt, counter);
input [3:0] Rs, Rt, Rd;
input we, clk, hlt;
input [15:0] writeData, counter;
reg [15:0] count;
output reg [15:0] outRs, outRt;
integer i, indx;
reg [15:0] regs [0:15];

initial begin 
	assign count = counter; 
        for(i=0;i<=15;i=i+1)
            regs[i] = 0;
    end


always @(clk,Rs)
begin
  if (~clk)
outRs = regs[Rs];
end


always @(clk,Rt)
begin
  if (~clk)
outRt = regs[Rt];
end





/*
always@(clk)
begin
$display("\n TIME = %2d rs = %h, RT=%h, writeD = %h, Rd = %h outRs= %h  outRT=%h  regs[1] = %h  , regs[2] = %h  reg3 = %h reg4 = %h.   reg5 =%h\n",$time ,Rs, Rt, writeData, Rd, outRs, outRt, regs[1], regs[2],  regs[3], regs[4], regs[5]);
end
*/

always @(posedge clk)   
begin
count ++;
if(we) begin
regs[Rd] = writeData;
regs[0] = 0;
end
end


always @(posedge hlt)
  begin
  for(indx=0; indx<16; indx = indx+1) begin
    $display("Reg%d = %h",indx,regs[indx]);
    end
$display("count = %d\n" , count);
    end

endmodule















