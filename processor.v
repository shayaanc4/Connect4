module processor(KEY, SW, CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS);

input CLOCK_50;
input [1:0] KEY;
input [6:0] SW;
output [3:0] VGA_R, VGA_G, VGA_B;
output VGA_HS, VGA_VS;
wire clk, rst, locked, vga_clk, vga_rd_clk, vga_sprite_clk;

reg key_debounce, reset;
reg [6:0] switch_debounce;
reg signed [11:0] pc;
wire signed [11:0] pc_next;
wire [31:0] instruction;

wire [31:0] reg_read_data1, reg_read_data2, reg_write_data, mem_read_data, alu_input1, alu_input2, alu_result, mem_addr;
reg [31:0] read_data;
wire [10:0] mem_addr_vga;

wire signed [31:0] imm;
wire [2:0] switch_concat, nn_out;

wire [2:0] alu_opcode;
wire [2:0] mem_selector;
wire branch, memtoreg, memwrite, alusrc, regwrite, z_flag, eq_flag, data_memwrite, vga_memwrite, ready_for_inf;

initial pc = 0;


always@(posedge clk) begin
	if (reset) pc <= 0;
	else if (instruction[6:0] != 7'b1111111) pc <= pc_next;
	key_debounce <= KEY[0];
	switch_debounce <= SW[6:0];
	reset <= ~KEY[1];
end

assign rst = 0;
assign alu_input1 = reg_read_data1;
assign alu_input2 = alusrc ? imm : reg_read_data2;
assign eq_flag = instruction[12] ? ~z_flag : z_flag;
assign vga_sprite_clk = vga_rd_clk;
assign data_memwrite = (mem_selector == 0) && memwrite;
assign vga_memwrite = (mem_selector == 5) && memwrite;
assign ready_for_inf = (mem_selector == 3);
// assign read_data = (mem_selector == 0) ? mem_read_data : ((mem_selector == 1) ? KEY[0] : switch_concat);
always@* begin 
	case (mem_selector)
		0: read_data = mem_read_data;
		1: read_data = key_debounce;
		2: read_data = switch_concat;
		4: read_data = nn_out;
		default: read_data = switch_concat;
	endcase
end

pc_updater pc_u(.pc(pc), .imm(imm), .alu_result(alu_result), .s({branch, instruction[3:2], eq_flag}), .pc_next(pc_next));

vga_pll vga_pll(.refclk(CLOCK_50), .rst(rst), .locked(locked), .outclk_0(vga_clk), .outclk_1(vga_rd_clk), .outclk_2(clk));

control_unit control(.instruction(instruction), .branch(branch), .memtoreg(memtoreg), 
							.alu_opcode(alu_opcode), .memwrite(memwrite), .alusrc(alusrc), .regwrite(regwrite));

rom instruction_mem(.addr(pc), .data(instruction));

reg_write_data_selector reg_wd_sel(pc, {instruction[2], memtoreg}, read_data, alu_result, reg_write_data);

register_file rf(
	.clk(clk), .regwrite_en(regwrite), .reset(reset), 
	.read_addr1(instruction[19:15]), .read_addr2(instruction[24:20]), .write_addr(instruction[11:7]), 
	.read_data1(reg_read_data1), .read_data2(reg_read_data2), .write_data(reg_write_data));
	
imm_gen immgen(.instruction(instruction), .imm(imm));
	
alu alu(.input1(alu_input1), .input2(alu_input2), .opcode(alu_opcode), .result(alu_result), .z_flag(z_flag));

switch_decoder sd(.SW(switch_debounce), .switch_concat(switch_concat));
mem_controller #(.DATA_MEM_CAPACITY(100)) mem_c(.mem_addr(alu_result), .mem_selector(mem_selector), .mem_addr_vga(mem_addr_vga));
ram_ip data_mem(.address(alu_result), .clock(~clk), .data(reg_read_data2), .wren(data_memwrite), .q(mem_read_data));
vga_driver vga(.vga_clk(vga_clk), .charbuf_rd_clock(vga_rd_clk), .charbuf_wr_clock(~clk), .sprite_rd_clock(vga_rd_clk), 
					.charbuf_wr_input(reg_read_data2), .charbuf_wr_addr(mem_addr_vga), .charbuf_wr_enable(vga_memwrite), 
					.vga_red(VGA_R), .vga_green(VGA_G), .vga_blue(VGA_B), .vga_hsync(VGA_HS), .vga_vsync(VGA_VS));
nn_IO nn_top(.clk(clk), .addr(alu_result), .write_data(reg_read_data2), .memwrite(data_memwrite), .ready_for_inf(ready_for_inf), .nn_out(nn_out));
// ram data_mem(.clk(clk), .addr(alu_result), .read_data(mem_read_data), .write_data(reg_read_data2), .memwrite_en(memwrite));

endmodule
