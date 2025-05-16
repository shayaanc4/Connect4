module ram(clk, addr, read_data, write_data, memwrite_en);

parameter ADDRESS_WIDTH = 8;
parameter DATA_WIDTH = 32;
parameter MEM_DEPTH = 42;

input clk, memwrite_en;
input [ADDRESS_WIDTH-1:0] addr;
input [DATA_WIDTH-1:0] write_data;
output [DATA_WIDTH*MEM_DEPTH-1:0] read_data;

reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

integer i;
initial begin
	for(i = 0; i < MEM_DEPTH; i=i+1)
		mem[i] = 0;
end

genvar j;
generate
	for (j = 0; j < MEM_DEPTH; j = j + 1) begin : pack_loop
		assign read_data[j*DATA_WIDTH +: DATA_WIDTH] = mem[j];
	end
endgenerate

always@(posedge clk) if (memwrite_en) mem[addr] <= write_data;

endmodule
