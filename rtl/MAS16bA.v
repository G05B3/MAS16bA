module MAS16bA (
	input [15:0] pg_instr, // program instruction => stored in memory in programming mode
	input [31:0] min,
	input pg, // programming mode (for writing the program to memory)
    input clk,
	input rstz,
	output [31:0] addrm,
	output [31:0] dmem,
	output [1:0] mwe,
	inout dvdd,
	inout dgnd
);

// Base Instruction Mem Address
parameter instrAddr = 16'h8000;

wire [15:0] instr;
wire [15:0] opa;
wire [15:0] opb;
wire [15:0] opc;
wire [15:0] opd;
wire [15:0] opb_alu;
wire [15:0] alu_res;
wire [15:0] mem_out;
wire [7:0] c;
wire [15:0] wbdata;
wire [1:0] ra, rb, rd, type, op;
wire selB;
wire jsel;
wire msel;
wire mwen;
wire wdataen;
wire rfen;
wire cbzsel;
wire cbz_flag;
wire cbz;
wire nextpc_flag;

wire [15:0] nextpc;
reg [15:0] pc;

wire [15:0] mini;
wire [15:0] mind;
wire [15:0] addri;
wire [15:0] addrd;
wire [15:0] dmemi;
wire [15:0] dmemd;

assign opc = {{8{c[7]}}, c};

ID16bA id(
	.instr(instr),
	.clk(clk),
	.rd(rd),
	.ra(ra),
	.rb(rb),
	.c(c),
	.selType(type),
	.selOp(op),
	.selB(selB),
	.jsel(jsel),
	.msel(msel),
	.cbzsel(cbzsel),
	.memwen(mwen),
	.rfen(rfen),
	.dvdd(dvdd),
	.dgnd(dgnd)
);

RF16bA rf(
	.rd(rd),
	.ra(ra),
	.rb(rb),
	.data(wbdata), // write-back data
	.clk(clk),
	.rstz(rstz),
	.en(rfen),
	.opA(opa),
	.opB(opb),
	.opD(opd),
	.dvdd(dvdd),
	.dgnd(dgnd)	
);

assign opb_alu = selB ? opc : opb; // ALUs operand B will be C if ADC, LD, ST, ..., otherwise RB

ALU16bA alu(
	.opA(opa),
	.opB(opb_alu),
	.opD(opd),
	.selType(type),
	.selOp(op),
	.res(alu_res),
	.cbz(cbz_flag),
	.dvdd(dvdd),
	.dgnd(dgnd)
);

assign cbz = cbz_flag & cbzsel;

BC16bA bc(
	.jSel(jsel),
	.cbz(cbz),
	.pcsel(nextpc_flag),
	.dvdd(dvdd),
	.dgnd(dgnd)
);

assign wdataen = !pg & mwen;

CACHE16b6A icache(
	.addr(pc >> 1),
	.data_in(pg_instr),
	.mem_in(mini),
	.clk(clk),
	.rstz(rstz | ~pg),
	.we(pg),
	.data_out(instr),
	.data_mem(dmemi),
	.addr_mem(addri),
	.dvdd(dvdd),
	.dgnd(dgnd)
);

CACHE16b6A dcache(
	.addr(alu_res),
	.data_in(opd),
	.mem_in(mind),
	.clk(clk),
	.rstz(rstz | ~pg),
	.we(wdataen),
	.data_out(mem_out),
	.data_mem(dmemd),
	.addr_mem(addrd),
	.dvdd(dvdd),
	.dgnd(dgnd)
);

assign mwe = {pg, wdataen};
assign dmem = {dmemi, dmemd};
assign addrm = {addri, addrd};
assign min = {mini, mind};

// Write-Back
assign wbdata = msel ? mem_out : alu_res;


assign nextpc = nextpc_flag ? pc + alu_res : pc + 2; // add 2B, since each instr. is 2B (except if CBZ/JMP)

// Program Count
always @(posedge clk) begin
	if (rstz == 0) begin
		pc <= instrAddr;
	end
	else if (pg == 0)
		pc <= nextpc;
	else
		pc <= pc + 2; // fully sequential on programming mode
end

endmodule
