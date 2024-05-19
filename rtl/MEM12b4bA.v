// essentially, this memory block is a transparent register bank

module MEM12b4bA (
    input [15:0] addressA,
    input [15:0] addressB,
    input [15:0] dataInA,
    input [15:0] dataInB,
    input writeEnableA,
    input writeEnableB,
	input clk,
    input rstz,
    output [15:0] dataOutA,
    output [15:0] dataOutB,
    inout dvdd,
    inout dgnd
);

// Memory array declaration
reg [7:0] memory [0:65535];

wire [15:0] nextAddrA, nextAddrB;

integer i;

assign nextAddrA = addressA + 1;
assign nextAddrB = addressB + 1;

always @ (negedge rstz) begin
	for (i = 0; i < 65536; i = i + 1) begin
		if (rstz == 1'b0) begin
			memory[i] = 8'b0;
		end
	end
end

// Memory Write Operations
always @(negedge clk)
begin
	if (rstz == 1'b1)begin
		if (writeEnableA == 1'b1) begin
			memory[addressA] <= dataInA[15:8];
			memory[nextAddrA] <= dataInA[7:0];
		end
		if (writeEnableB == 1'b1) begin
			memory[addressB] <= dataInB[15:8];
			memory[nextAddrB] <= dataInB[7:0];
		end
	end
end

// Memory Read Operations
assign dataOutA = {memory[addressA], memory[nextAddrA]};
assign dataOutB = {memory[addressB], memory[nextAddrB]};

endmodule

