module relu(data_in, data_out);

input logic signed [10:0] data_in;
output logic signed [10:0] data_out;

assign data_out = data_in[10] ? 0 : data_in;

endmodule
