module nn_engine(clk, ready_for_inf, inputs_packed, nn_out);
	
	// Parameters
	parameter NUM_INPUTS = 42;
	parameter NUM_PERCEPTRONS_HIDDEN = 32;
	parameter NUM_PERCEPTRONS_OUTPUT = 7;
	parameter DATA_WIDTH = 32;

	// Inputs
	input logic clk, ready_for_inf;
	input logic [NUM_INPUTS*DATA_WIDTH-1:0] inputs_packed;

	// Outputs
	output logic [2:0] nn_out;

	// Internal
	logic [7:0] inputs [0:NUM_INPUTS-1];
	logic rst, done;
	logic signed [13:0] activations [0:NUM_PERCEPTRONS_OUTPUT-1];
	logic [2:0] prediction_temp;
	
	logic [DATA_WIDTH-1:0] input_word;
	logic [DATA_WIDTH-1:0] input_word_shifted;
	always_comb begin 
		integer i;
		for (i = 0; i < NUM_INPUTS; i = i + 1) begin : unpack_loop
			input_word = inputs_packed[i*DATA_WIDTH +: DATA_WIDTH];
			input_word_shifted = input_word << 5;
			inputs[i] = input_word_shifted[7:0];
		end
	end
	
	integer j;
	initial begin
		done = 0;
		for (j = 0; j < NUM_PERCEPTRONS_OUTPUT; j = j + 1) begin
			activations[j] = 0;
		end
		prediction_temp = 0;
	end
	
	neural_network #(
		.NUM_INPUTS(NUM_INPUTS),
		.NUM_PERCEPTRONS_HIDDEN(NUM_PERCEPTRONS_HIDDEN),
		.NUM_PERCEPTRONS_OUTPUT(NUM_PERCEPTRONS_OUTPUT)) nn(
		.clk(clk),
		.rst(rst),
		.ready_for_inf(ready_for_inf),
		.inputs(inputs),
		.fp_done(done),
		.activations_output(activations));
	
	softmax #(.NUM_CLASSES(NUM_PERCEPTRONS_OUTPUT)) sm(.activations(activations), .max_index(prediction_temp));
	always_ff@(posedge clk) begin
		if (done) begin
			nn_out <= prediction_temp;
			rst <= 1;
		end else rst <= 0;
	end
	
endmodule
