module rom(addr, data);

parameter ADDRESS_WIDTH = 12;
parameter DATA_WIDTH = 32;

input [ADDRESS_WIDTH-1:0] addr;
output [DATA_WIDTH-1:0] data;

reg [DATA_WIDTH-1:0] mem [0:2**ADDRESS_WIDTH-1];

wire [ADDRESS_WIDTH-1:0] shifted_addr;

assign shifted_addr = addr >> 2;

integer i;
initial begin
	for(i = 0; i < 2**ADDRESS_WIDTH; i=i+1)
		mem[i] = 0;
	$readmemh("C:/Users/sschaudh/OneDrive - Brown University/Desktop/sschaudh/ENGN1640/FinalProject/instruction_mem.txt", mem);
end

assign data = mem[shifted_addr];

endmodule
