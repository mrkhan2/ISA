module fulladdertb; 
 

reg [15:0] operation; 
reg [15:0] input1;
reg [15:0] input2;
wire [15:0] result;
wire Z;
wire N;
wire V;




 
ALU uut (
.operation(operation),
.input1(input1),
.input2(input2), 
.result(result), 
.Z(Z), 
.V(V), 
.N(N) 
);
 
initial
begin
operation = 0;
input1 = 0;
input2 = 0;
#100;
assign operation = 16'b1101000000010000;
assign input1 = 16'b0000000000000011;
//assign input2 = 16'b0000100100001001;
#40
assign operation = 16'b1001000000000100;

#40
assign operation = 16'b1010000001100000;

#40
assign operation = 16'b1011000000011000;/*
assign input2 = 16'b1000100010000101;
assign input1 = 16'b1000100010000101; */
//#40
//assign operation = 16'b0100000000000011;
//assign input2 = 0;
end
 
 
always@*
begin
$monitor("time = %2d  , operation = %16b  ,  \n input1 = %16b,   \n input2 = %16b,\n result = %b ,%h , V=%b , Z=%b, N=%b", $time,operation, input1, input2 ,result,result,V,Z,N );
end

 
endmodule