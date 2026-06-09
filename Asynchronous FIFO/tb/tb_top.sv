`timescale 1ns/1ps

`include "tb_pkg.sv"
`include "fifo_write_if.sv"
`include "fifo_read_if.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic wclk = 0;
  logic rclk = 0;
  always #5.0  wclk = ~wclk;		// 100MHz
  always #3.65 rclk = ~rclk;		// ~137MHz
  
  fifo_write_if wif(wclk);
  fifo_read_if  rif(rclk);
  
  async_fifo_top #(
    .DEPTH		(DEPTH),
    .DATA_WIDTH	(DATA_WIDTH)
  ) dut(
    .wclk  (wif.wclk),
    .wreset(wif.wreset),
    .wen   (wif.wen),
    .wdata (wif.wdata),
    .full  (wif.full),
    
    .rclk  (rif.rclk),
    .rreset(rif.rreset),
    .ren   (rif.ren),
    .rdata (rif.rdata),
    .empty (rif.empty),
    .rvalid(rif.rvalid)
  );
  
  test t;
  
  initial begin
    t = new(wif, rif);
    t.run();
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
  end
endmodule
