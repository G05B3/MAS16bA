module BC16bA (
	input jSel,
	input cbz,
	output pcsel,
	inout dvdd,
	inout dgnd
);

assign pcsel = cbz | jSel;

endmodule
