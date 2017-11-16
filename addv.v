
//ADD OP 
module addv(A, B, N, V, Z , sum);
input [15:0] A;
input [15:0] B;
output N;
output V;
output Z;
output [15:0] sum;
assign Op = 1'b0;
wire [15:0] Rs;
wire [15:0] Rt;
assign Rs = A;
assign Rt = B;
ripple_carry_adder_subtractor ra(sum, N, V, Rs, Rt, Op);



  always @*
 begin
  $display( "Rs = %16b. rt = %b,  rD = %b", Rs, Rt,sum);
end



endmodule




//SUB OP 
module sub(A, B, N, V, Z , sum);
input [15:0] A;
input [15:0] B;
output N;
output V;
output Z;
output [15:0] sum;
assign Op = 1'b1;
wire [15:0] Rs;
wire [15:0] Rt;
assign Rs = A;
assign Rt = B;
ripple_carry_adder_subtractor ra(sum, N, V, Rs, Rt, Op);



  always @*
 begin
  $display( " SUB : Rs = %16b. rt = %b,  rD = %b. \n", Rs, Rt,sum);
end



endmodule






//ADDER SUBTRACTOR

module ripple_carry_adder_subtractor(S, N, V, A, B, AddSub);
   output [15:0] S;   // The 16-bit sum/difference.
   output   N;
   output   V;   // The 1-bit overflow status.
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
 assign  N = S[15];

  //always @*
 //  $display("time = %2d    c0: %b  c1: %b    c2: %b    c3: %b",$time, C0,C1,C2,C3) ;

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