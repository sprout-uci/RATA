module rata (
    clk,    
    pc,
    data_wr,
    data_addr,
    dma_addr,
    dma_en,
    
    upLMT,
    reset
);
input           clk;
input   [15:0]  pc;
input           data_wr;
input   [15:0]  data_addr;
input   [15:0]  dma_addr;
input           dma_en;

output          upLMT;
output          reset;

// MACROS ///////////////////////////////////////////
//
parameter AR_BASE = 16'hE000;
parameter AR_SIZE = 16'h2000;
parameter LAST_AR_ADDR = AR_BASE + AR_SIZE - 2;

parameter LMT_BASE = 16'h0040;
parameter LMT_SIZE = 16'h0020;
parameter LAST_LMT_ADDR = LMT_BASE + LMT_SIZE - 2;

parameter SMEM_BASE = 16'hA000;
parameter SMEM_SIZE = 16'h4000;
parameter LAST_SMEM_ADDR = SMEM_BASE + SMEM_SIZE - 2;

parameter RESET_HANDLER = 16'h0000;
parameter AUTH_HANDLER = SMEM_BASE + 16'h0010;
// TODO: NEED THE CORRECT ADDRESS OF AUTHENTICATION SUCCESS.

parameter MOD  = 3'b0, NOTMOD = 3'b1, UPDATE = 3'b10, KILL = 3'b11, ATTEST =3'b100;

//-------------Internal Variables---------------------------
reg[2:0]             state;
reg              upLMT_res;
reg             rata_reset;

//
initial
    begin
        state = KILL;
        upLMT_res = 0;
        rata_reset = 0;
    end

wire is_AR_being_modified =  ((data_wr && data_addr >= AR_BASE && data_addr <= LAST_AR_ADDR) || (dma_en && dma_addr >= AR_BASE && dma_addr <= LAST_AR_ADDR));
wire is_lmt_being_modified = (data_wr && data_addr >= LMT_BASE && data_addr <= LAST_LMT_ADDR) || (dma_en && dma_addr >= LMT_BASE && dma_addr <= LAST_LMT_ADDR);

// XXX: State Transition Logic
always @(posedge clk)
    if(is_lmt_being_modified)
        state <= KILL;
	else if(state != KILL && is_AR_being_modified)
		state <= MOD;
    else if(state == KILL && pc == RESET_HANDLER)
        state <= MOD;
    else if(state == MOD && pc == AUTH_HANDLER)
        state <= UPDATE;
    else if(state == UPDATE && pc != AUTH_HANDLER)
        state <= ATTEST;	
    else if(state == ATTEST && pc == LAST_SMEM_ADDR)
        state <= NOTMOD;
    else if(state == ATTEST && pc == AUTH_HANDLER)
        state <= UPDATE;
    else if(state == NOTMOD && is_AR_being_modified)
        state <= MOD;
    else state <= state;

// XXX: Reset Output Logic
always @(posedge clk)
begin
    if(state == KILL || is_lmt_being_modified)
        rata_reset <= 1'b1;
    else if(state == MOD && is_lmt_being_modified)
        rata_reset <= 1'b1;
    else if(state == NOTMOD && is_lmt_being_modified)
        rata_reset <= 1'b1; 
    else if(state == UPDATE && is_lmt_being_modified)
        rata_reset <= 1'b1;
	else
		rata_reset <= 1'b0;
end

// XXX: upLMT Output Logic

always @(posedge clk)
begin
if ((state == MOD && pc == AUTH_HANDLER))
        upLMT_res <= 1'b1;
else
if ((state == ATTEST && pc == AUTH_HANDLER))
        upLMT_res <= 1'b1;
else
if (state == UPDATE)
        upLMT_res <= 1'b1;
else
        upLMT_res <= 1'b0;		
end


assign upLMT = upLMT_res;
assign reset = rata_reset;

endmodule
