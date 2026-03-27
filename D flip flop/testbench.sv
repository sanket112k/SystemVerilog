`include "interface.sv"
`include "test.sv"

module tb;

  logic clk = 0;
  always #5 clk = ~clk;

  dff_if vif(clk);

  dff dut (
    .clk   (clk),
    .reset (vif.reset),
    .d     (vif.d),
    .q     (vif.q)
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
