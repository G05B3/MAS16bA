module ID16bA (
	input [15:0] instr, // 16 bit instruction to be decoded
        input clk, // system clock
	output [1:0] rd, // Destination Register D ID
	output [1:0] ra, // Operand Register A ID
	output [1:0] rb, // Operand Register B ID
	output [7:0] c, // Immediate / Constant
	output [1:0] selType, // muxsel for operation type (arithm, logic, mem, conditional / flow control)
	output [1:0] selOp, // muxsel for operation of a given type (ex: arithm -> adc, add, mul, sra)
	output selB, // muxsel for second operand (Register B or Constant C)
	output jsel, // jump select
	output memwen, // memory write enable (high if instruction is a store)
	output rfen, // register file write enable (high if instruction writes to a register)
	inout dvdd, // module digital supply
	inout dgnd // module digital ground
);

// instr = [opcode(3:0), rd(1:0), ra(1:0), rb(1:0) / c(7:0)]

wire [3:0] opcode;

assign opcode = instr[15:12];
assign rd = instr[11:10];
assign ra = instr[9:8];
assign rb = instr[1:0];
assign c = instr[7:0];
// selB = 1 if instruction is ADC(0), LD(8), ST(9), SET(A), LTC(D), CBZ(E) or
// JMP(F)
assign selB = opcode == 4'h0 | opcode[3:1] == 3'b100 | opcode == 4'ha | opcode == 4'hd | opcode[3:1] == 3'b111;

assign selType = opcode[3:2];
assign selOp = opcode[1:0];

assign memwen = opcode == 4'h9; // instr is ST
assign rfen = (opcode != 4'h9 & opcode != 4'he & opcode != 4'hf); // instr is not ST neither CBZ nor JMP
assign jsel = opcode == 4'hf; // instr is JMP

endmodule
