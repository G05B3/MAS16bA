`define NUM_INSTRUCTIONS 63

task program(); begin
	#10 instr = 16'hA001;
	#10 instr = 16'hA402;
	#10 instr = 16'hAC7F;
	#10 instr = 16'h2F03;
	#10 instr = 16'h2001;
	#10 instr = 16'hC803;
	#10 instr = 16'hDA01;
	#10 instr = 16'hE9F8;
	#10 instr = 16'h00FF;
end
endtask
