module MEM12b4bA (
    input [15:0] addressA,
    input [15:0] addressB,
    input [15:0] dataInA,
    input [15:0] dataInB,
    input writeEnableA,
    input writeEnableB,
    input rstz,
    output [15:0] dataOutA,
    output [15:0] dataOutB,
    inout dvdd,
    inout dgnd
);

// Memory array declaration
reg [7:0] memory [0:16383][0:3]; // 2^14 rows, each with 2^2 columns

wire [15:0] nextAddrA, nextAddrB;

assign nextAddrA = addressA + 1;
assign nextAddrB = addressB + 1;

always @ (negedge rstz) begin
	for (integer i = 0; i < 16384; i = i + 1) begin
		if (rstz == 1'b0) begin
			memory[i][0] <= 8'b0;
			memory[i][1] <= 8'b0;
			memory[i][2] <= 8'b0;
			memory[i][3] <= 8'b0;
		end
	end
end

// Memory Write Operations
always @ (posedge writeEnableA or posedge writeEnableB or addressA or addressB)
begin
	if (rstz == 1'b1) begin
		if (writeEnableA) begin
        		memory[addressA[15:2]][addressA[1:0]] <= dataInA[15:8];
			memory[nextAddrA[15:2]][nextAddrA[1:0]] <= dataInA[7:0];
		end
		if (writeEnableB) begin
			memory[addressB[15:2]][addressB[1:0]] <= dataInB[15:8];
			memory[nextAddrB[15:2]][nextAddrB[1:0]] <= dataInB[7:0];
		end
	end
end 

// Memory Read Operations
assign dataOutA = {memory[addressA[15:2]][addressA[1:0]], memory[nextAddrA[15:2]][nextAddrA[1:0]]};
assign dataOutB = {memory[addressB[15:2]][addressB[1:0]], memory[nextAddrB[15:2]][nextAddrB[1:0]]};

endmodule

