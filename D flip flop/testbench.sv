`include "interface.sv"
`include "test.sv"

module testbench;
  intf intff();
  test tst(intff);
  
  dff_async_reset ff(
    .clk(intff.clk),
    .reset(intff.reset),
    .data(intff.data),
    .q(intff.q)
  );
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
  end
  
endmodule
