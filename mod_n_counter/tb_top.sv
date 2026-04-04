`include "tb_pkg.sv"
import tb_pkg::*;
`include "interface.sv"
`include "test.sv"

module tb;
  logic clk = 0;
  always #5 clk = ~clk;
  
  count_if vif (clk);
  
  mod_n_counter #(
    .N(N)
  ) dut(
    .clk(clk),
    .reset(vif.reset),
    .count(vif.count)
  );
  test t;
  
  initial begin
    t = new(vif);
    t.run;
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
  end
endmodule
