`timescale 1ns / 1ps

module MAS16bA_tb;

reg [15:0] instr;
reg clk, rstz, pg;
wire dvdd, dgnd;

MAS16bA uut (
	.pg_instr(instr),
	.pg(pg),
	.clk(clk),
	.rstz(rstz),
	.dvdd(dvdd),
	.dgnd(dgnd)
);

`include "program.v"

initial
begin
$dumpfile("dump.vcd");
$dumpvars(0, MAS16bA_tb);

// Shows the memory
/*for (integer j = 0; j < 65536; j = j+1) begin
		$dumpvars(0, uut.mem.memory[j]);
	end*/

clk = 0;
rstz = 1;
pg = 1;
instr = 16'h0000;
#10 rstz = 0;
#10 rstz = 1; pg = 0;
#10 rstz = 0; pg = 1;
#10 rstz = 1;

program();

/*instr = 16'h0001;
#10 instr = 16'h0502;
#10 instr = 16'h0a03;
#10 instr = 16'h0f04;
#10 instr = 16'h2e03;
#10 instr = 16'ha000;
#10 instr = 16'hf0fe;*/

#10 pg = 0; rstz = 0;
#10 rstz = 1;
for (integer i = 0; i < `NUM_INSTRUCTIONS; i = i + 1) begin
	#10 $display("instr: %h; R0 = %1d, R1 = %1d, R2 = %1d, R3 = %1d",uut.instr, uut.rf.r[0], uut.rf.r[1], uut.rf.r[2], uut.rf.r[3]);
end

$finish;
end

always #5 clk = ~clk;
endmodule
