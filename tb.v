`timescale 1ns/1ps
module tb();

reg clk;
processor p(clk);

always #0.5 clk = ~clk;

initial begin
	#0 clk = 0;
	#20000 $stop;
end

endmodule
	