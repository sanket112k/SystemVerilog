// FIFO top module
`include "fifo_sync.sv"
`include "fifo_mem.sv"
`include "write_ctrl.sv"
`include "read_ctrl.sv"

module async_fifo_top #(
  parameter DEPTH = 8,
  parameter DATA_WIDTH = 16,
  localparam ADDR_WIDTH = $clog2(DEPTH)
)(
  input  logic 					  wclk,
  input  logic 					  wreset,
  input  logic 					  wen,
  input  logic [DATA_WIDTH-1 : 0] wdata,
  output logic 					  full,
  
  input  logic 					  rclk,
  input  logic 					  rreset,
  input  logic 					  ren,
  output logic [DATA_WIDTH-1 : 0] rdata,
  output logic 					  empty,
  output logic 					  rvalid
);
  logic [ADDR_WIDTH-1:0] waddr;
  logic [ADDR_WIDTH-1:0] raddr;
  logic [ADDR_WIDTH:0]   wptr_gray;
  logic [ADDR_WIDTH:0]   rptr_gray;
  logic [ADDR_WIDTH:0]   wptr_sync;
  logic [ADDR_WIDTH:0]   rptr_sync;
  
  fifo_mem #(
    .DEPTH     (DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) f_mem(
    .wclk (wclk),
    .wen  (wen & ~full),
    .wdata(wdata),
    .waddr(waddr),
    
    .rclk (rclk),
    .ren  (ren & ~empty),
    .raddr(raddr),
    .rdata(rdata)
  );
  
  fifo_sync #(
    .ADDR_WIDTH(ADDR_WIDTH)
  ) r2w(
    .xclk   (wclk),
    .xreset (wreset),
    .ptr_in (rptr_gray),
    .ptr_out(rptr_sync)
  );
  
  fifo_sync #(
    .ADDR_WIDTH(ADDR_WIDTH)
  ) w2r(
    .xclk   (rclk),
    .xreset (rreset),
    .ptr_in (wptr_gray),
    .ptr_out(wptr_sync)
  );
  
  write_ctrl #(
    .ADDR_WIDTH(ADDR_WIDTH)
  ) w_ctrl(
    .wclk     (wclk),
    .wreset   (wreset),
    .wen      (wen),
    .rptr_sync(rptr_sync),
    .waddr    (waddr),
    .wptr_gray(wptr_gray),
    .full     (full)
  );
  
  read_ctrl #(
    .ADDR_WIDTH(ADDR_WIDTH)
  ) r_ctrl(
    .rclk(rclk),
    .rreset(rreset),
    .ren(ren),
    .wptr_sync(wptr_sync),
    .raddr(raddr),
    .rptr_gray(rptr_gray),
    .empty(empty),
    .rvalid(rvalid)
  );
endmodule
