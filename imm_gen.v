module imm_gen(instruction, imm);

parameter INSTRUCTION_WIDTH = 32;
parameter IMM_WIDTH = 32;

input [INSTRUCTION_WIDTH-1:0] instruction;
output reg signed [IMM_WIDTH-1:0] imm;

// assign imm = instruction[5] && ~instruction[4] ? {{20{instruction[31]}}, instruction[31:25], instruction[11:7]} : {{20{instruction[31]}}, instruction[31:20]};

always@* begin
	case(instruction[6:0])
		7'b0100011: imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
		7'b1100011: imm = {{20{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
		7'b1101111: imm = {{12{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
		default: imm = {{20{instruction[31]}}, instruction[31:20]};
	endcase
end
endmodule

	