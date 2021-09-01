module  LMT (

// OUTPUTs
    per_dout,                       // Peripheral data output

// INPUTs
    mclk,                           // Main system clock
    per_addr,                       // Peripheral address
    per_din,                        // Peripheral data input
    per_en,                         // Peripheral enable (high active)
    per_we,                         // Peripheral write enable (high active)
    puc_rst,                         // Main system reset

	d_addr,
	w_en,
	dmem_din,

    upLMT                          // VAPE exec_flag TODO: change to input
);

// OUTPUTs
//=========
output      [15:0] per_dout;        // Peripheral data output


// INPUTs
//=========
input              mclk;            // Main system clock
input       [13:0] per_addr;        // Peripheral address
input       [15:0] per_din;         // Peripheral data input
input              per_en;          // Peripheral enable (high active)
input        [1:0] per_we;          // Peripheral write enable (high active)
input              puc_rst;         // Main system reset

input		 [15:0]	   d_addr;
input		 [1:0]	   w_en;
input		 [15:0]	   dmem_din;

input              upLMT;           // VAPE exec_flag


//=============================================================================
// 1)  PARAMETER DECLARATION
//=============================================================================
// MR Region
parameter MR_BASE = 16'h0230;
parameter MR_SIZE = 16'h0020;

parameter LMT_BASE = 16'h0040;
parameter LMT_SIZE = 16'h0020;

wire addr_in_MR = (d_addr >= MR_BASE && d_addr < MR_BASE + MR_SIZE);
wire [1:0] write_to_MR = {addr_in_MR, addr_in_MR} & w_en; // & bitwise logical and
wire read_LMT = (per_addr >= LMT_BASE && per_addr < LMT_BASE + LMT_SIZE) && per_en;
                                                                                                                                                                           
parameter              CHAL_SIZE = 16;         // 32 Bytes

parameter              MEM_SIZE = 16; 	// 32 Bytes

//============================================================================
// 2)  MEMORY & INITIALIZATION
//============================================================================

reg [15:0]             MR_mem [15:0];
reg [15:0]             LMT_mem [15:0];
  

integer i;
always @ (posedge mclk) begin
	if (puc_rst == 1'b1) begin
		for(i = 0; i < MEM_SIZE; i = i + 1) begin
			LMT_mem[i] <= 5;
			MR_mem[i] <= 0;
		end
	end
end

//============================================================================
// 2)  COPY ON upLMT
//============================================================================
always @ (posedge mclk) begin
	if (upLMT == 1'b1) begin
		for(i = 0; i < MEM_SIZE; i = i + 1) begin
			LMT_mem[i] <= MR_mem[i];
		end
	end
end
//============================================================================
// 3)  UPDATE MR MIRROR WHEN ACTUAL MR IS WRITTEN
// w_en is two-bit
// This is tricky; i'll explain by using examples:
// If d_addr = MR_BASE and w_en = 2'b01 -> only the fist 8-bit of MR_mem[0] is updated
// If d_addr = MR_BASE+1 and w_en = 2'b10 -> only the last 8-bit is updated
// If d_addr = MR_BASE and w_en = 2'b11 -> MR_mem[0] is updated
// I don't think w_en != 2'b10 when d_addr is odd (e.g., MR_BASE+1)
//============================================================================
wire        [15:0] diff = (d_addr-MR_BASE);
wire        [14:0] idx = diff[15:1];
wire        [15:0] mem_val = MR_mem[idx];
always @ (posedge mclk) begin
	if (write_to_MR==2'b11) MR_mem[idx] <= dmem_din ;
	else if (write_to_MR==2'b10) MR_mem[idx] <= {dmem_din[15:8], mem_val[7:0]};
	else if (write_to_MR==2'b01) MR_mem[idx] <= {mem_val[15:8], dmem_din[7:0]};
end
//============================================================================
// 4)  MAKE LMT READABLE
//============================================================================
assign per_dout = (read_LMT) ? LMT_mem[per_addr-LMT_BASE] : 0;

endmodule
