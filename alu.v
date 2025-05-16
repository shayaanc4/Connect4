module alu(input1, input2, opcode, result, z_flag);

parameter DATA_WIDTH = 32;

input signed [DATA_WIDTH-1:0] input1, input2;
input [2:0] opcode;
output reg signed [DATA_WIDTH-1:0] result;
output z_flag;

assign z_flag = (result == 0);

always@* begin
	case (opcode)
		3'b100: result = input1 * input2;
		3'b000: result = input1 & input2;
		3'b001: result = input1 | input2;
		3'b010: result = input1 + input2;
		3'b011: result = input1 - input2;
		3'b101: result = input1 <<< input2;
		default: result = input1 + input2;
	endcase
end

endmodule

