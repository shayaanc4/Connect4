module mem_controller(mem_addr, mem_selector, mem_addr_vga);

parameter DATA_MEM_CAPACITY = 100;

input [31:0] mem_addr;
output reg [2:0] mem_selector;
output [10:0] mem_addr_vga;

assign mem_addr_vga = mem_addr - (DATA_MEM_CAPACITY + 4); 

always@* begin
	if (mem_addr >= DATA_MEM_CAPACITY + 4) mem_selector = 5; // vga
	else if (mem_addr == DATA_MEM_CAPACITY + 3) mem_selector = 4; // nn_read
	else if (mem_addr == DATA_MEM_CAPACITY + 2) mem_selector = 3; // nn_start
	else if (mem_addr == DATA_MEM_CAPACITY + 1) mem_selector = 2; // switch
	else if (mem_addr == DATA_MEM_CAPACITY) mem_selector = 1;// Key
	else mem_selector = 0;
end
endmodule
