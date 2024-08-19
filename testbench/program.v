`define NUM_INSTRUCTIONS 80

task program(); begin
	#10 instr = 16'hA401;
	#10 instr = 16'hA801;
	#10 instr = 16'h9400;
	#10 instr = 16'h8800;
	#10 instr = 16'h9400;
	#10 instr = 16'h1502;
	#10 instr = 16'hDD3C;
	#10 instr = 16'hA8F2;
	#10 instr = 16'h2F02;
	#10 instr = 16'hF302;
end
endtask
