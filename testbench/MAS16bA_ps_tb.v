`timescale 1ns / 1ps

module MAS16bA_tb;

reg [15:0] instr;
reg clk, rstz, pg;
wire dvdd, dgnd;

wire [1:0] mwe;
reg [31:0] min;
wire [31:0] addrm;
wire [31:0] dmem;


MEM12b4bA mem (
	.addressA(addrm[31:16]),
	.addressB(addrm[15:0]),
	.dataInA(min[31:16]),
	.dataInB(min[15:0]),
	.writeEnableA(mwe[1]),
	.writeEnableB(mwe[0]),
	.clk(clk),
	.dataOutA(dmem[31:16]),
	.dataOutB(dmem[15:0]),
	.dvdd(dvdd),
	.dgnd(dgnd)
);


MAS16bA uut (
	.pg_instr(instr),
	.min(min),
	.pg(pg),
	.clk(clk),
	.rstz(rstz),
	.addrm(addrm),
	.dmem(dmem),
	.mwe(mwe),
	.dvdd(dvdd),
	.dgnd(dgnd)
);

`include "program.v"

initial
begin
$dumpfile("dump.vcd");
$dumpvars(0, MAS16bA_tb);

// Shows the memory
/*for (integer j = 0; j < 32; j = j+1) begin
		$dumpvars(0, uut.icache.memory[j]);
	end
*/

clk = 0;
rstz = 1;
pg = 1;
instr = 16'h0000;
#10 rstz = 0;
#10 rstz = 1; pg = 0;
#10 rstz = 0; pg = 1;
#10 rstz = 1;

program();

#10 instr = 16'ha000;
#10 instr = 16'hf000; // end program

#10 pg = 0; rstz = 0;
#10 rstz = 1;

#2000

/*for (integer i = 0; i < `NUM_INSTRUCTIONS; i = i + 1) begin
	#10 //$display("instr: %h; R0 = %1d, R1 = %1d, R2 = %1d, R3 = %1d",uut.instr, uut.rf.r[0], uut.rf.r[1], uut.rf.r[2], uut.rf.r[3]);
end*/

$finish;
end

always #5 clk = ~clk;
endmodule
