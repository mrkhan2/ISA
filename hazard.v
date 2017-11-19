module hazard(opcode, if_idRs, if_idRt, id_exRt, id_ex_mr, pc_write, if_id_write, stall);

input [3:0] opcode, if_idRs, if_idRt, id_exRt;
input id_ex_mr;
output pc_write, if_id_write, stall;
reg hazard;

assign stall = hazard;
assign pc_write = ~hazard;
assign if_id_write = ~hazard;

always @(*) begin
	if (opcode == 4'b1111) begin
		hazard = 1'b1;
	end else if (id_ex_mr) begin
		if (id_exRt == if_idRs || id_exRt == if_idRt) begin
			hazard = 1'b1;
		end else begin
			hazard = 1'b0;
		end
	end else begin
		hazard = 1'b0;
	end
end

endmodule
