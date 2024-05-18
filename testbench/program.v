`define NUM_INSTRUCTIONS 500

task program(); begin
	#10 instr = 16'hA408;
	#10 instr = 16'hA802;
	#10 instr = 16'h1102;
	#10 instr = 16'h2102;
	#10 instr = 16'h3102;
	#10 instr = 16'h4102;
	#10 instr = 16'h5102;
	#10 instr = 16'h6100;
	#10 instr = 16'h7102;
end
endtask
