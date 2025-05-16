module nn_IO(clk, addr, write_data, memwrite, ready_for_inf, nn_out);

parameter ADDRESS_WIDTH = 8;
parameter DATA_WIDTH = 32;
parameter MEM_DEPTH = 42;

input [31:0] addr, write_data;
input clk, memwrite, ready_for_inf;
output [2:0] nn_out;

wire [DATA_WIDTH*MEM_DEPTH-1:0] read_data;

ram #(.ADDRESS_WIDTH(ADDRESS_WIDTH), .DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) nn_mem(.clk(~clk), .memwrite_en(memwrite), 
																														  .addr(addr[7:0]), .write_data(write_data), 
																														  .read_data(read_data));
																														  
nn_engine nn_e(.clk(clk), .ready_for_inf(ready_for_inf), .inputs_packed(read_data), .nn_out(nn_out));

endmodule
