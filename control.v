module Control(operation, rd, rs, rt,cond, ctrl_signals, call, imm);
input [15:0] operation;
output reg [7:0] ctrl_signals;
output reg [3:0] rd, rs, rt;
output reg [2:0] cond;
output reg [11:0] call;
output reg [8:0] imm;


localparam we = 0;
localparam memToreg =1;
localparam memWrite =2;
localparam halt = 3;
localparam jump = 4;
localparam jReg = 5;
localparam branch = 6;



always@(*) begin
   //ADD OP
    if(operation[15:12] == 4'b0000)
      begin
        rd = operation[11:8];
        rs = operation [7:4];
        rt = operation [3:0];
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;
        ctrl_signals[memWrite] = 0;
        ctrl_signals[halt] = 0;
		ctrl_signals[jump] = 0;
		ctrl_signals[jReg] = 0;
		ctrl_signals[branch] = 0;

	
      end

    //SUB OP
 else if(operation[15:12] == 4'b0001)
      begin
          rd = operation[11:8];
          rs = operation [7:4];
          rt = operation [3:0];
    	  ctrl_signals[we] = 1;
    	  ctrl_signals[memToreg] = 0;
    	 ctrl_signals[memWrite] = 0;	
    	 ctrl_signals[halt] = 0;
    	 ctrl_signals[jump] = 0;
    	 ctrl_signals[jReg] = 0;
    	 ctrl_signals[branch] = 0;
      end


      //NOR OP
 else if(operation[15:12] == 4'b0010)
      begin
        rd = operation[11:8];
        rs = operation [7:4];
        rt = operation [3:0];
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;
    	ctrl_signals[memWrite] = 0;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
      end

      //XOR OP
 else if(operation[15:12] == 4'b0011)
      begin
    	rd = operation[11:8];
        rs = operation [7:4];
        rt = operation [3:0];
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;
    	ctrl_signals[memWrite] = 0;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
      end


     //SLL OP
 else if(operation[15:12] == 4'b0100)
      begin
        rd = operation[11:8];
        rs = operation [7:4];
        rt = operation [3:0];
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;
    	ctrl_signals[memWrite] = 0;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
      end


     //SRA OP
 else if(operation[15:12] == 4'b0101)
    begin 
        rd = operation[11:8];
        rs = operation [7:4];
        rt = operation [3:0];
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;
    	ctrl_signals[memWrite] = 0;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
     end

     //ROR OP
 else if(operation[15:12] == 4'b0110)
    begin 
   	    rd = operation[11:8];
        rs = operation [7:4];
        rt = operation [3:0];
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;
    	ctrl_signals[memWrite] = 0;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
     end

     //PADDSB OP
 else if(operation[15:12] == 4'b0111)
    begin 
        rd = operation[11:8];
        rs = operation [7:4];
        rt = operation [3:0];
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;
    	ctrl_signals[memWrite] = 0;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
     
     end

    //LW OP
 else if(operation[15:12] == 4'b1000)
    begin 
  	    rd = operation[7:4]+ operation [3:0];
        rs = operation [11:8];
        rt = 0;
    	ctrl_signals[we] = 1;    
    	ctrl_signals[memToreg] = 1;
    	ctrl_signals[memWrite] = 0;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[branch] = 0;
    	end


        //SW OP
 else if(operation[15:12] == 4'b1001)
    begin 
      	rd = operation[7:4]+operation[3:0];
        rs = operation [11:8];
        rt = 0;
    	ctrl_signals[we] = 1;  
    	ctrl_signals[memToreg] = 0;
    	ctrl_signals[memWrite] = 1;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
    end


         //LHB OP
 else if(operation[15:12] == 4'b1010)
    begin 
  	    rd = operation[11:8];
        rs = operation[11:8];
        rt = 0;
    	ctrl_signals[we] = 1;    
    	ctrl_signals[memToreg] = 0;   
    	ctrl_signals[memWrite] = 0;
    	ctrl_signals[halt] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[branch] = 0;
    end

        //LLB OP
 else if(operation[15:12] == 4'b1011)
 begin 
  	    rd = operation[11:8];
        rs = operation[11:8];
        rt = 0;
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;   
    	ctrl_signals[memWrite] = 0;   
    	ctrl_signals[halt] = 0; 
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
    end


    	//Branch
else if(operation[15:12] == 4'b1100)
 begin 
  	    cond = operation[11:9];
        imm = operation[8:0];
        rd = 0;
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;   
    	ctrl_signals[memWrite] = 0;   
    	ctrl_signals[halt] = 0; 
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[branch] = 1;
    end


   	//CALL
else if(operation[15:12] == 4'b1101)
 begin 
  	    call = operation[11:0];
  	    rd = 4'b1111;
    	ctrl_signals[we] = 1;
    	ctrl_signals[memToreg] = 0;   
    	ctrl_signals[memWrite] = 0;   
    	ctrl_signals[halt] = 0; 
    	ctrl_signals[jump] = 1;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
    end


   	//RET
else if(operation[15:12] == 4'b1110)
 begin 
        rs = operation[7:4];
    	ctrl_signals[we] = 0;
    	ctrl_signals[memToreg] = 0;   
    	ctrl_signals[memWrite] = 0;   
    	ctrl_signals[halt] = 0; 
    	ctrl_signals[jReg] = 1;
    	ctrl_signals[jump] = 0;
    	ctrl_signals[branch] = 0;
    end



   	//HALT
else if(operation[15:12] == 4'b1111)
 begin 
  	   
    	ctrl_signals[we] = 0;
    	ctrl_signals[memToreg] = 0;   
    	ctrl_signals[memWrite] = 0;   
    	ctrl_signals[halt] = 1; 
    	ctrl_signals[jump] = 0;
    	ctrl_signals[jReg] = 0;
    	ctrl_signals[branch] = 0;
    end



end //if statements





endmodule