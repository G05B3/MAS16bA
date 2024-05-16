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

initial
begin
$dumpfile("dump.vcd");
$dumpvars(0, MAS16bA_tb);
clk = 0;

$finish;
end

always #5 clk = ~clk;
endmodule
