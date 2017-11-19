module forward( ex_memRD, mem_wbRd, id_exRt, id_exRs, ex_mem_rw, mem_wb_rw, forwarda, forwardb);
input [3:0] id_exRt, id_exRs, ex_memRD, mem_wbRd;
input ex_mem_rw, mem_wb_rw;
output reg [1:0] forwarda, forwardb;

always @(*) begin
	
	if ((ex_memRD == id_exRt) & (ex_mem_rw & |ex_memRD)) 
		forwardb <= 2'b10;
	 else if ((mem_wb_rw & |mem_wbRd) & (mem_wbRd == id_exRt)) 
		forwardb <= 2'b01;
	 else 
		forwardb <= 2'b00;

	if ((ex_memRD == id_exRs) & (ex_mem_rw & |ex_memRD)) 
		forwarda <= 2'b10;
	 else if ((mem_wb_rw & |mem_wbRd) & (mem_wbRd == id_exRs)) 
		forwarda <= 2'b01;
	 else 
		forwarda <= 2'b00;
	
end

endmodule

