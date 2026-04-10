// Read pointer & empty generation logic
module read_ctrl #(
  parameter ADDR_WIDTH = 4
)(
  input  logic 					  rclk,
  input  logic 					  rreset,
  input  logic                    ren,
  input  logic [ADDR_WIDTH : 0]   wptr_sync,	// gray
  output logic [ADDR_WIDTH-1 : 0] raddr,		// binary
  output logic [ADDR_WIDTH : 0]   rptr_gray,	// gray
  output logic 					  empty,
  output logic 					  rvalid
);
  logic [ADDR_WIDTH : 0] rptr_bin;	// binary
  logic [ADDR_WIDTH : 0] rgnext;	// gray next
  logic [ADDR_WIDTH : 0] rbnext;	// binary next
  
  always_ff @(posedge rclk) begin:next_transition
    if (rreset) begin
      rptr_bin  <= 0;
      rptr_gray <= 0;
    end
    else begin
      rptr_bin  <= rbnext;
      rptr_gray <= rgnext;
    end
  end:next_transition
  
  always_ff @(posedge clk) begin:ptr_increment_logic
    rbnext = rptr_bin + (ren & ~empty);		// increment
    rgnext = (rbnext>>1) ^ rbnext;			// binary to gray convertion
  end:ptr_increment_logic
  
  assign raddr = rptr_bin[ADDR_WIDTH-1 : 0];
  
  always_ff @(posedge rclk) begin:empty_flag
    if(rreset)
      empty <= 1;
    else
      empty <= (rgnext == wptr_sync);
  end:empty_flag
  
  always_ff @(posedge rclk) begin:valid_generation
    if (rreset)
      rvalid <=0;
    else
      rvalid <= ren & ~empty;
  end:valid_generation
endmodule
