module branch(cond, N,V,Z ,br);
input N,Z,V;
input [2:0] cond;
output reg br;

localparam NEQ			= 3'b000;
localparam EQ			= 3'b001;
localparam GT			= 3'b010;
localparam LT			= 3'b011;
localparam GTE			= 3'b100;
localparam LTE			= 3'b101;
localparam OVERFLOW		= 3'b110;
localparam UNCOND		= 3'b111;



always @(*) begin
	case (cond)
		NEQ : br = ~Z ? 1'b1 : 1'b0;
		EQ : br = Z ? 1'b1 : 1'b0;
		GT : br = ~(Z | N) ? 1'b1 : 1'b0;
		LT : br = N ? 1'b1 : 1'b0;
		GTE : br = (Z | ~N) ? 1'b1 : 1'b0;
		LTE : br = (N | Z) ? 1'b1 : 1'b0;
		OVERFLOW : br = V ? 1'b1 : 1'b0;
		UNCOND : br = 1'b1;
		default :br = 1'b0;
	endcase
end















endmodule 
