`include "interface.sv"
`include "test.sv"

module tb;

  logic clk;

  always #5 clk = ~clk;

  fa_if vif(clk);

  full_adder dut(
    .a(vif.a),
    .b(vif.b),
    .cin(vif.cin),
    .sum(vif.sum),
    .cout(vif.cout)
  );

  test t;

  initial
  begin
    t = new(vif);
    t.run();
    #100 $finish;
  end

endmodule
