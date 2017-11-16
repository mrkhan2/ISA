module ALU(operation, input1, input2, result, Z, N, V, pc);
input [15:0] operation, pc; 
input [15:0] input1;
input [15:0] input2;
output reg [15:0] result;
output reg Z;
output reg N;
output reg V;

wire [15:0] add_out, sub_out, padd_out,ror_out;
wire addZ, addN, addV,
     subZ, subN, subV;
/*
always@(operation,result)
begin
$display("input2= %b input1 = %b. result = %b operation = %b" , input2 , input1 , result, operation);
end*/

add ADD(
.A(input1), 
.B(input2),
.V(addV),
.sum(add_out)
);
  

sub SUB(
.A(input1), 
.B(input2),
.V(subV),
.sum(sub_out)
);

paddsb PADDSB(
.A(input1), 
.B(input2),
.sum(padd_out)
);

ror ROR(
.A(input1), 
.shift(operation[3:0]),
.out(ror_out)
);


always@(*) begin
   
   //ADD OP
    if(operation[15:12] == 4'b0000)
      begin
      if (addV && add_out[15]) begin
           result = 16'h7FFF;
           V  = 1'b1;
           N  = 1'b0;
           Z  = 1'b0;
  end else if (addV && ~add_out[15]) begin
           result = 16'h8000;
           V  = 1'b1;
           N = 1'b1;
           Z  = 1'b0; 
  end else begin
           result = add_out;
           V= addV;
           N = result[15];
           Z = ~|add_out;
          end
      end

    //SUB OP
 else if(operation[15:12] == 4'b0001)
      begin
      if (subV && ~sub_out[15]) begin
           result = -(1<<15);
           V  = 1'b1;
           N  = 1'b0;
           Z  = 1'b0;
  end else if (subV && sub_out[15]) begin
           result =  (1<<15)-1;
           V  = 1'b1;
           N = 1'b1;
           Z  = 1'b0; 
  end else begin
           result = sub_out;
           V= subV;
           N = result[15];
           Z = ~|sub_out;
          end
      end

      //NOR OP
 else if(operation[15:12] == 4'b0010)
      begin
        result = ~(input1 | input2);
        if(result == 0)
           Z=1;
         else
           Z=0;
      end

      //XOR OP
 else if(operation[15:12] == 4'b0011)
      begin
       result = input1 ^ input2;
        if(result == 0)
          Z=1;
        else
          Z=0;
      end


     //SLL OP
 else if(operation[15:12] == 4'b0100)
      begin
       result = input1 << operation[3:0];
        if(result == 0)
          Z=1;
        else
          Z=0;
      end


     //SRA OP
 else if(operation[15:12] == 4'b0101)
    begin 
      result = $signed(input1) >>> operation[3:0];
        if(result == 0)
          Z=1;
       else
          Z=0;
     end

     //ROR OP
 else if(operation[15:12] == 4'b0110)
    begin 
      result = ror_out;
        if(result == 0)
          Z=1;
       else
          Z=0;
     end

     //PADDSB OP
 else if(operation[15:12] == 4'b0111)
    begin 
      result = padd_out;
        if(result == 0)
          Z=1;
       else
          Z=0;
     end

    //LW OP
 else if(operation[15:12] == 4'b1000)
    begin 
      result = input1;
     end


        //SW OP
 else if(operation[15:12] == 4'b1001)
    begin 
     result = input1;
     end


         //LHB OP
 else if(operation[15:12] == 4'b1010)
    begin 
      result = {operation[7:0], input1[7:0]};
     end

        //LLB OP
 else if(operation[15:12] == 4'b1011)
    begin 
      result = {input1[15:8],operation[7:0]};
     end


  //CALL OP
 else if(operation[15:12] == 4'b1101)
    begin 
      result = pc+1;
     end

//BRANCH OP
 else if(operation[15:12] == 4'b1100)
    begin 
      result = input1;
     end

 //RET OP
 else if(operation[15:12] == 4'b1110)
    begin 
      result = input1;
     end



end //if statements




endmodule


//ADD OP 
module add(A, B, V,sum);
input [15:0] A;
input [15:0] B;
output [15:0] sum;
output V;
assign Op = 1'b0;
wire [15:0] Rs;
wire [15:0] Rt;
assign Rs = A;
assign Rt = B;
ripple_carry_adder_subtractor ra(sum, Rs, Rt, V, Op);
endmodule




//SUB OP 
module sub(A, B,V, sum);
input [15:0] A;
input [15:0] B;
output [15:0] sum;
output V;
assign Op = 1'b1;
wire [15:0] Rs;
wire [15:0] Rt;
assign Rs = A;
assign Rt = B;
ripple_carry_adder_subtractor ra(sum, Rs, Rt,V, Op);
endmodule


//PADDSB OP
module paddsb(A,B,sum);
input [15:0] A,B;
output reg [15:0] sum;
reg [3:0] sum1,sum2,sum3,sum4;

always@*
begin

sum1 = A[3:0]+B[3:0]; //lsb
sum2 = A[7:4]+B[7:4];
sum3 = A[11:8]+B[11:8];
sum4 = A[15:12]+B[15:12];

 //CHECK FOR MOST POSITIVE OR NEGATIVE ALLOWABE 

begin
if (~A[15] && ~B[15] && sum4[3]) 
    sum4 = 4'b0111;
  else if (A[15] && B[15] && ~sum4[3]) 
          sum4 = 4'b1000;
        
end

begin
  if (~A[11] && ~B[11] && sum3[3]) 
          sum3 = 4'b0111;
   else if (A[11] && B[11] && ~sum3[3]) 
          sum3 = 4'b1000;
           
end
  
begin
 if (~A[7] && ~B[7] && sum2[3]) 
          sum2 = 4'b0111;
   else if (A[7] && B[7] && ~sum2[3]) 
        sum2 = 4'b1000;
       
end
   
begin
     if (~A[3] && ~B[3] && sum1[3]) 
          sum1 = 4'b0111;
         else if (A[3] && B[3] && ~sum1[3]) 
                  sum1 = 4'b1000;
                   
end
sum = {sum4,sum3,sum2,sum1};
  end
endmodule






//ROR OP
module ror(A, shift, out);
input [15:0] A;
input [3:0] shift;
output [15:0] out;

wire [15:0] upper, lower;
wire [5:0] b = 5'b10000;
wire [3:0] sL;
assign sL = b - shift;
assign upper = A << sL;
assign lower = A >> shift;
assign out = upper +lower;


endmodule









//ADDER SUBTRACTOR

module ripple_carry_adder_subtractor(S,  A, B, V, AddSub);
   output [15:0] S;   // The 16-bit sum/difference.
   output V;
   input [15:0]  A;   // The 16-bit augend/minuend.
   input [15:0]  B;   // The 16-bit addend/subtrahend.
   input  AddSub;  // The operation: 0 => Add, 1=>Subtract.
   
   wire   C0; // The carry out bit of fa0, the carry in bit of fa1.
   wire   C1; 
   wire   C2; 
   wire   C3; // The carry out bit of fa2, used to generate final carry/borrrow.
   wire   C4;
   wire   C5;
   wire   C6;
   wire   C7;
   wire   C8;
   wire   C9;
   wire   C10;
   wire   C11;
   wire   C12;
   wire   C13;
   wire   C14;
   wire   C15;
   wire   Cout;
   wire   B0; // will be the xor'd result of B[0] and AddSub
   wire   B1;
   wire   B2;
   wire   B3;
   wire   B4;
   wire   B5;
   wire   B6;
   wire   B7;
   wire   B8;
   wire   B9;
   wire   B10;
   wire   B11;
   wire   B12;
   wire   B13;
   wire   B14;
   wire   B15;


  

  assign B0 = B[0] ^ AddSub;     
  assign B1 = B[1] ^ AddSub;     
  assign B2 = B[2] ^ AddSub;     
  assign B3 = B[3] ^ AddSub;
  assign B4 = B[4] ^ AddSub;
  assign B5 = B[5] ^ AddSub;
  assign B6 = B[6] ^ AddSub;
  assign B7 = B[7] ^ AddSub;     
  assign B8 = B[8] ^ AddSub;
  assign B9 = B[9] ^ AddSub;
  assign B10 = B[10] ^ AddSub;
  assign B11 = B[11] ^ AddSub;
  assign B12 = B[12] ^ AddSub;
  assign B13 = B[13] ^ AddSub;
  assign B14 = B[14] ^ AddSub;
  assign B15 = B[15] ^ AddSub;
  
   
   
   full_adder fa0(S[0], C0, A[0], B0, AddSub);    // Least significant bit.
   full_adder fa1(S[1], C1, A[1], B1, C0);
   full_adder fa2(S[2], C2, A[2], B2, C1);
   full_adder fa3(S[3], C3, A[3], B3, C2);
   full_adder fa4(S[4], C4, A[4], B4, C3); 
   full_adder fa5(S[5], C5, A[5], B5, C4); 
   full_adder fa6(S[6], C6, A[6], B6, C5); 
   full_adder fa7(S[7], C7, A[7], B7, C6); 
   full_adder fa8(S[8], C8, A[8], B8, C7); 
   full_adder fa9(S[9], C9, A[9], B9, C8); 
   full_adder fa10(S[10], C10, A[10], B10, C9); 
   full_adder fa11(S[11], C11, A[11], B11, C10); 
   full_adder fa12(S[12], C12, A[12], B12, C11);    
   full_adder fa13(S[13], C13, A[13], B13, C12); 
   full_adder fa14(S[14], C14, A[14], B14, C13); 
   full_adder fa15(S[15], C15, A[15], B15, C14);// Most significant bit.


 assign  Cout = C15 ^ AddSub; // Carry = C15 for addition, Carry = not(C) for subtraction.
 assign  V = C15^C14; // If the two most significant carry output bits differ, then we have an overflow.


endmodule // ripple_carry_adder_subtractor


module full_adder(S, Cout, A, B, Cin);
   output S;
   output Cout;
   input  A;
   input  B;
   input  Cin;

  wire   WIRE_1;
  wire   WIRE_2;
  wire   WIRE_3;
       
  assign WIRE_1 = B ^ A;
  assign WIRE_2 = WIRE_1 & Cin;
  assign WIRE_3 = B & A;
 
  assign S   = WIRE_1 ^ Cin;
  assign Cout = WIRE_2 | WIRE_3;
  

endmodule // full_adder