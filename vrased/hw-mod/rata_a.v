module rata_a (
    clk,
    
    pc,
    puc,
    
    data_wr,
    data_addr,
    
    dma_addr,
    dma_en,
    
    setLMT,
    reset
);
input           clk;
input   [15:0]  pc;
input           puc;
input           data_wr;
input   [15:0]  data_addr;
input   [15:0]  dma_addr;
input           dma_en;
output          setLMT;
output          reset;

// MACROS ///////////////////////////////////////////
//
parameter AR_BASE = 16'hE000;
parameter AR_SIZE = 16'h2000;
parameter LAST_AR_ADDR = AR_BASE + AR_SIZE - 2;

parameter LMT_BASE = 16'h000A;
parameter LMT_SIZE = 16'h0010;
parameter LAST_LMT_ADDR = LMT_BASE + LMT_SIZE - 2;

parameter RESET_HANDLER = 16'h0000;

parameter MOD  = 2'b0, NOTMOD = 2'b1, KILL = 2'b10;
//-------------Internal Variables---------------------------
reg[1:0]             state;
reg             setLMT_res;
reg             rata_reset;
//
initial
    begin
        state = NOTMOD;
        setLMT_res = 0;
        rata_reset = 0;
    end

wire is_AR_being_modified = !puc && ((data_wr && data_addr >= AR_BASE && data_addr <= LAST_AR_ADDR) || (dma_en && dma_addr >= AR_BASE && dma_addr <= LAST_AR_ADDR));
wire is_lmt_being_modified = (data_wr && data_addr >= LMT_BASE && data_addr <= LAST_LMT_ADDR) || (dma_en && dma_addr >= LMT_BASE && dma_addr <= LAST_LMT_ADDR);

always @(posedge clk)
    if(is_lmt_being_modified)
        state <= KILL;
    else if(state == MOD && !is_AR_being_modified)
        state <= NOTMOD;
    else if(state == NOTMOD && is_AR_being_modified)
        state <= MOD;
    else if(state == KILL && pc == RESET_HANDLER)
        state <= MOD;
    else state <= state;
    
always @(posedge clk)
    if(is_lmt_being_modified && !is_AR_being_modified)
    begin
        rata_reset <= 1'b1;
        setLMT_res <= 1'b0;
    end
    else if(is_lmt_being_modified && is_AR_being_modified)
    begin
        rata_reset <= 1'b1;
        setLMT_res <= 1'b1;
    end
    else if(state == MOD && !is_AR_being_modified)
    begin
        rata_reset <= 1'b0;
        setLMT_res <= 1'b0;
    end
    else if(state == NOTMOD && is_AR_being_modified)
    begin
        rata_reset <= 1'b0;
        setLMT_res <= 1'b1;
    end
    else if(state == KILL && pc == RESET_HANDLER)
    begin
        rata_reset <= 1'b0;
        setLMT_res <= 1'b1;
    end
    else if(state == MOD)
    begin
        rata_reset <= 1'b0;
        setLMT_res <= 1'b1;
    end
    else if(state == NOTMOD)
    begin
        rata_reset <= 1'b0;
        setLMT_res <= 1'b0;
    end
    else if(state == KILL && pc != RESET_HANDLER)
    begin
        rata_reset <= 1'b1;
        setLMT_res <= 1'b1;
    end
    else 
    begin
        rata_reset <= 1'b1;
        setLMT_res <= 1'b1;
    end
        


assign setLMT = setLMT_res;
assign reset = rata_reset;

endmodule