`timescale 1ns / 1ps

module MAS16bA_tb;

reg clk;

MAS16bA uut (
    .clk(clk)
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
