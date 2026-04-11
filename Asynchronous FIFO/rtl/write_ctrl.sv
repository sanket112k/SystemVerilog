// Write pointer & full generation logic

module write_ctrl #(
  parameter ADDR_WIDTH = 4
)(
  input  logic                    wclk,
  input  logic                    wreset,
  input  logic                    wen,
  input  logic [ADDR_WIDTH : 0]   rptr_sync,	// gray
  output logic [ADDR_WIDTH-1 : 0] waddr,		// binary
  output logic [ADDR_WIDTH : 0]   wptr_gray,	// gray
  output logic                    full
);
  logic [ADDR_WIDTH : 0] wptr_bin;		// binary
  logic [ADDR_WIDTH : 0] wgnext;		// gray next
  logic [ADDR_WIDTH : 0] wbnext;		// binary next
  
  always_ff @(posedge wclk) begin:next_transition
    if (wreset) begin
      wptr_bin  <= 0;
      wptr_gray <= 0;
    end
    else begin
      wptr_bin  <= wbnext;
      wptr_gray <= wgnext;
    end
  end:next_transition
  
  always_comb begin:ptr_increment_logic
    wbnext = wreset ? '0 ? wptr_bin + (wen & ~full);		// increment
    wgnext = (wbnext>>1) ^ wbnext;		// binary to gray conversion
  end:ptr_increment_logic
  
  assign waddr = wptr_bin[ADDR_WIDTH-1 : 0];
  
  always_ff @(posedge wclk) begin:full_flag
    if(wreset) full <= 0;
    else	   full <= (wgnext == {~rptr_sync[ADDR_WIDTH : ADDR_WIDTH-1], rptr_sync[ADDR_WIDTH-2 : 0]});
  end:full_flag
endmodule
