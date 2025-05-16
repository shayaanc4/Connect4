module control_unit(instruction, branch, memtoreg, alu_opcode, memwrite, alusrc, regwrite);

input [31:0] instruction;
output reg branch, memtoreg, memwrite, alusrc, regwrite;
output reg [2:0] alu_opcode;

always@* begin
	casez (instruction[6:0]) 
		7'b0110011: begin
			branch = 0;
			memtoreg = 0;
			memwrite = 0;
			alusrc = 0;
			regwrite = 1;
			case (instruction[14:12])
				3'b000: alu_opcode = instruction[25] ? 3'b100 : (instruction[30] ? 3'b011 : 3'b010);
				3'b110: alu_opcode = 3'b001;
				3'b111: alu_opcode = 3'b000;
				default: alu_opcode = 3'b000;
			endcase
		end
		7'b0010011: begin
			branch = 0;
			memtoreg = 0;
			memwrite = 0;
			alusrc = 1;
			regwrite = 1;
			case (instruction[14:12])
				3'b000: alu_opcode = 3'b010;
				3'b001: alu_opcode = 3'b101;
				default: alu_opcode = 3'b010;
			endcase
		end
		7'b0000011: begin
			branch = 0;
			memtoreg = 1;
			memwrite = 0;
			alusrc = 1;
			regwrite = 1;
			alu_opcode = 3'b010;
		end
		7'b0100011: begin
			branch = 0;
			memtoreg = 0;
			memwrite = 1;
			alusrc = 1;
			regwrite = 0;
			alu_opcode = 3'b010;
		end
		7'b1100011: begin
			branch = 1;
			memtoreg = 0;
			memwrite = 0;
			alusrc = 0;
			regwrite = 0;
			alu_opcode = 3'b011;
		end
		7'b110?111: begin
			branch = 1;
			memtoreg = 0;
			memwrite = 0;
			alusrc = 1;
			regwrite = 1;
			alu_opcode = 3'b010;
		end
		default: begin
			branch = 0;
			memtoreg = 0;
			memwrite = 0;
			alusrc = 1;
			regwrite = 0;
			alu_opcode = 3'b010;
		end
	endcase
end

endmodule		
			