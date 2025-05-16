module perceptron (clk, rst, en, data_in, weight, sum);

	// Parameters
	parameter integer NUM_INPUTS = 42;
	parameter integer INPUT_WIDTH = 8;
	parameter integer WEIGHT_WIDTH = 8;

	// Inputs
	input logic clk, rst, en;
	input logic signed [INPUT_WIDTH-1:0] data_in; // (3,5)
	input logic signed [7:0] weight; // (3,5)

	// Output
	output logic signed [INPUT_WIDTH+WEIGHT_WIDTH-6:0] sum; // (8,5)

	// Internal
	logic signed [INPUT_WIDTH + WEIGHT_WIDTH - 1:0] mult; // (6,10)
	logic signed [INPUT_WIDTH + WEIGHT_WIDTH - 6:0] mult_trunc; // (6,5)
	
	assign mult = data_in * weight;
	assign mult_trunc = mult[INPUT_WIDTH+WEIGHT_WIDTH-1:5];
	
	always_ff@(posedge clk) begin
		if (rst) sum <= 0;
		else if (en) sum <= sum + mult_trunc;
	end
		
endmodule