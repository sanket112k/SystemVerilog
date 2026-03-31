`include "interface.sv"
`include "test.sv"

module tb;
  logic clk = 0;
  always #5 clk = ~clk;
  
  dff_if vif (clk);
  
  dff dut #(
    .N(N)
  )(
    .clk(clk),
    .reset(vif.reset),
    .count(vif.q)
  );
  test t;
