module ALU16bA (
	input [15:0] opA, // Operand A (RA)
	input [15:0] opB, // Operand B (RB or C)
	input [15:0] opD, // Operand D (RD - read only)
	input [1:0] selType, // Type Select: Arithmetic, Logic, LD/ST, Conditional
	input [1:0] selOp, // Operation Select (Arithm: add, mul, rsa; Logic: and, or, not, xor; ...)
	output [15:0] res, // ALU result
	output cbz, // conditional branch zero flag
	inout dvdd,
	inout dgnd
);

wire [15:0] radd;
wire [15:0] rmul;
wire [15:0] rsra;
wire [15:0] ratm;

wire [15:0] rrand;
wire [15:0] ror;
wire [15:0] rnot;
wire [15:0] rxor;
wire [15:0] rlog;

wire [15:0] radr;
wire [15:0] rset;
wire [15:0] rmem;

wire [15:0] rlt;
wire [15:0] rbj; // RA + C for branches and jumps
wire [15:0] rcnd;

// Arithmetic Operations
assign radd = opA + opB;
assign rmul = opA * opB;
assign rsra = opA >> opB;

assign ratm = selOp[1] ? (selOp[0] ? rsra : rmul) : radd;

// Logic Operations
assign rrand = opA & opB;
assign ror = opA | opB;
assign rnot = ~opA;
assign rxor = opA ^ opB;

assign rlog = selOp[1] ? (selOp[0] ? rxor : rnot) : (selOp[0] ? ror : rrand);

// LD/ST Operations
assign radr = opA + opB;
assign rset = opB;

assign rmem = selOp[1] ? rset : radr; // if 1X => rset, else its LD/ST

// Conditionals
assign rlt = opA < opB ? 16'h0001 : 16'b0;
assign rbj = opA + opB;

assign rcnd = selOp[1] ? rbj : rlt;

// ALU Output
assign res = selType[1] ? ( selType[0] ? rcnd : rmem ) : (selType[0] ? rlog : ratm);
assign cbz = opD == 16'b0; // if opD == 0 => cbz = 1 else cbz = 0

endmodule
