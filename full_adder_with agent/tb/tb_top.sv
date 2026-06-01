`timescale 1ns/1ns

`include "interface.sv"
`include "test.sv"

module tb_top;
  
  logic clk = 0;
  always #5 clk = ~clk;
  
  fa_if vif(clk);

  full_adder dut(
    .a   (vif.a),
    .b   (vif.b),
    .cin (vif.cin),
    .sum (vif.sum),
    .cout(vif.cout)
  );

  test t;

  initial begin
    t = new(vif);
    t.run();
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, tb_top);
  end

endmodule
