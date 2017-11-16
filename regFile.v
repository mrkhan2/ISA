module rf(clk, Rs, Rt, Rd, outRs, outRt, writeData, we, hlt);
input [3:0] Rs, Rt, Rd;
input we, clk, hlt;
input [15:0] writeData;

output reg [15:0] outRs, outRt;
integer i, indx;
reg [15:0] regs [0:15];
reg [15:0] counter;

initial begin 
		counter = 0;
        for(i=0;i<=15;i=i+1)
            regs[i] = 0;
    end

/*
always@(clk)
begin
$display("\n TIME = %2d rs = %h, RT=%h, writeD = %h, Rd = %h outRs= %h  outRT=%h  regs[1] = %h  , regs[2] = %h  reg3 = %h reg4 = %h.   reg5 =%h\n",$time ,Rs, Rt, writeData, Rd, outRs, outRt, regs[1], regs[2],  regs[3], regs[4], regs[5]);
end
*/

always @(posedge clk)   
begin
counter ++;
if(we) begin
regs[Rd] = writeData;
regs[0] = 0;
end
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




always @(posedge hlt)
  begin
  for(indx=0; indx<16; indx = indx+1) begin
    $display("Reg%d = %h",indx,regs[indx]);
    end
$display("counter = %d\n" , counter);
    end

endmodule















