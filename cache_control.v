module cache_control(
	clk, rst_n, re, we, fetch, writeData, ready, instruction, readData,
	IMhit, DMhit, d_dirty, memRd, d_tag, iaddr, daddr, IO,
	DO, MO, Memre, IMwe, DMwe,	Memwe, IDI, DDI, 	
	Memaddr, i_data,	d_data
);

//** I/O **//
input clk, rst_n, re, we, fetch, IMhit, DMhit, d_dirty, memRd;
input [7:0] d_tag;
input [15:0] iaddr, daddr, writeData;
input [63:0] IO, DO, MO;

output IDI;
output reg Memre, IMwe, DMwe, Memwe, DDI, ready;
output [15:0] instruction, readData;
output reg [13:0] Memaddr;
output reg [63:0] i_data, d_data;


reg [1:0] state, nextState; 

assign IDI 	= 1'b0; 

assign instruction = ~rst_n ? 16'h0000 : (iaddr[1] ? (iaddr[0] ? IO[63:48] : IO[47:32]) : (iaddr[0] ? IO[31:16] : IO[15:0]));

assign readData = ~rst_n ? 16'hF000 : (daddr[1] ? (daddr[0] ? DO[63:48] : DO[47:32]) : (daddr[0] ? DO[31:16] : DO[15:0]));

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		state <= 2'b00;
	end else begin
		state <= nextState;
	end
end

//** FSM LOGIC **//
always @(*) begin

	IMwe 		= 1'b0;
	i_data 		= 0;

	DMwe 		= 1'b0;
	DDI 	= 1'b0;
	d_data 		= 0;

	Memwe		= 1'b0;
	Memre 		= 1'b0;
	Memaddr 		= 0;

	ready 		= 1'b0;

	nextState 	= 2'b00;

	case (state)

		// Checking for cache misses
		
		2'b00 : begin
			if ((re | we) & ~DMhit) begin
				if (d_dirty) begin
					Memaddr 	= {d_tag, daddr[7:2]};
					Memwe 	= 1'b1;
					
					nextState = 2'b10;					
				end else begin
					Memaddr 	= daddr[15:2];
					Memre 	= 1'b1;

					nextState = 2'b01;
				end

			end else if (fetch & ~IMhit) begin
				Memaddr	= iaddr[15:2];
				Memre 	= 1'b1;

				nextState = 2'b01;

			// If there was no miss
			end else begin
				// Write hit
				if (we) begin
					d_data		= shift_in(DO, writeData, daddr[1:0]);
					DDI 	= 1'b1;
					DMwe 		= 1'b1;
				end

				ready = 1'b1;
				nextState = 2'b00;
			end
		end
		
		// Waiting for memory to return
		//
		2'b01 : begin
			if (memRd) begin
				// Dealing with data request
				if ((re | we) & ~DMhit) begin
					if (we) begin
						d_data		= shift_in(MO, writeData, daddr[1:0]);
						DDI 	= 1'b1;
						DMwe 		= 1'b1;	
					end else begin
						d_data		= MO;
						DMwe		= 1'b1;
					end

				end else begin
					i_data 	= MO;
					IMwe 	= 1'b1;
				end

				nextState = 2'b00;

			end else if ((re | we) & ~DMhit) begin
				Memaddr 	= daddr[15:2];
				Memre 	= 1'b1;

				nextState = 2'b01;

			end else if (fetch & ~IMhit) begin
				Memaddr	= iaddr[15:2];
				Memre 	= 1'b1;

				nextState = 2'b01;

			end else begin
				nextState = 2'b00;
			end
		end

				2'b10 : begin
			Memaddr 	= {d_tag, daddr[7:2]};
			Memwe 	= 1'b1;

			nextState = memRd ? 2'b11 : 2'b10;
		end

		// Memory read after right back
		
		2'b11 : begin
			Memaddr 	= daddr[15:2];
			Memre 	= 1'b1;

			nextState = 2'b01;
		end

		default : begin end
	endcase
end

function [63:0] shift_in;

input [63:0] line;
input [15:0] in;
input [1:0] shamt;

begin
	case (shamt)
		2'b00 : shift_in = {line[63:16], in};
		2'b01 : shift_in = {line[63:32], in, line[15:0]};
		2'b10 : shift_in = {line[63:48], in, line[31:0]};
		2'b11 : shift_in = {in, line[47:0]};
	endcase	
end

endfunction

endmodule