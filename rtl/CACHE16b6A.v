module CACHE16b6A (
        input [15:0] addr,
        input [15:0] data_in,
        input [15:0] mem_in,
        input clk,
        input rstz,
        input we,
        output [15:0] data_out,
        output [15:0] data_mem,
        output [15:0] addr_mem,
        inout dvdd,
        inout dgnd
);


// Cache parameters
localparam WAYS = 0; // 2^0 = 1 way
localparam INDEX = 5;
localparam LINES = 1 << INDEX;
localparam OFFSET = 1;
localparam TAG = 16 - WAYS - INDEX - OFFSET; // 6 bits for cache mapping, 10 for tag

// Cache arrays
reg [TAG-1:0] tags [0:LINES-1]; // array of tags
wire [INDEX-1:0] index;
reg valid [0:LINES-1]; // array with 'valid' bits (initialized at 0)
reg [31:0] memory [0:LINES-1]; // all cache lines

integer i;
wire[TAG-1:0] tag;
wire[16-TAG-1:0] cache_addr;

// Address fields
assign tag = addr[15:16-TAG];
assign index = addr[5:1];
assign cache_addr = addr[5:0];

// Cache Reset
always @(negedge rstz) begin
	if (rstz == 1'b0) begin
		for (i = 0; i < LINES; i = i + 1) begin
			valid[i] <= 1'b0;
                        tags[i] <= 0;
                end
	end
end

assign cache_hit = (valid[index] == 1'b1 & tags[index] == tag);

always @(negedge clk) begin
        if (we) begin // store
                if (cache_addr[0] == 0)
                        memory[index][31:16] <= data_in;
                else
                        memory[index][15:0] <= data_in; 
                tags[index] <= addr[15:16-TAG];
                valid[index] <= 1;
        end
end

assign data_mem = data_in;
assign addr_mem = addr;
assign data_out = cache_hit ? (cache_addr[0] ? memory[index][15:0] : memory[index][31:16]) : mem_in;

endmodule
