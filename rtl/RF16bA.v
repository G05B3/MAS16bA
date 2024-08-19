module RF16bA (
	input [1:0] rd,
	input [1:0] ra,
	input [1:0] rb,
	input [15:0] data,
        input clk,
	input rstz,
	input en,
	output [15:0] opA,
	output [15:0] opB,
	output [15:0] opD,
	inout dvdd,
	inout dgnd
);

parameter NREGISTERS = 4;
parameter WIDTH = 16;

reg [(WIDTH-1):0] r[0:(NREGISTERS-1)];

integer i;

// Define Registers R0 - R3
always @(posedge clk)
begin
	for (i = 0; i < NREGISTERS; i = i +1) begin
		if (!rstz) 
			r[i] <= 0;
		else if ((rd == i) & en)
			r[i] <= data;
		else
			r[i] <= r[i];
	end
end

assign opA = ra == 2'b0 ? r[0] : (ra == 2'b01 ? r[1] : (ra == 2'b10 ? r[2] : r[3]));
assign opB = rb == 2'b0 ? r[0] : (rb == 2'b01 ? r[1] : (rb == 2'b10 ? r[2] : r[3]));
assign opD = rd == 2'b0 ? r[0] : (rd == 2'b01 ? r[1] : (rd == 2'b10 ? r[2] : r[3]));

endmodule
