module reg_write_data_selector(pc, s, mem_read_data, alu_result, reg_write_data);

input signed [11:0] pc;
input [1:0] s;
input [31:0] mem_read_data, alu_result;
output reg [31:0] reg_write_data;

always@* begin
	casez (s)
		2'b1?: reg_write_data = pc + 4;
		2'b01: reg_write_data = mem_read_data;
		default: reg_write_data = alu_result;
	endcase
end

endmodule
