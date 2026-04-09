`include "tb_pkg.sv"
`include "interface.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic clk = 0;
  always #5 clk = ~clk;
  
  fifo_if vif(clk);
  
  synchronous_fifo #(
    .DEPTH     (DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) sfifo(
    .clk     (clk),
    .resetn  (vif.resetn),
    .w_en    (vif.w_en),
    .r_en    (vif.r_en),
    .data_in (vif.data_in),
    .data_out(vif.data_out),
    .full    (vif.full),
    .empty   (vif.empty)
  );
  
  test t;
  
  initial begin
    t = new(vif);
    t.run();
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
  end
endmodule
