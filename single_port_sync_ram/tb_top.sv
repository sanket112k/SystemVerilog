`include "tb_pkg.sv"
`include "interface.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic clk = 0;
  always #5 clk = ~clk;
  
  ram_if vif(clk);
  single_port_sync_ram #(
    .DEPTH(DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dut(
    .clk(vif.clk),
    .addr(vif.addr),
    .cs(vif.cs),
    .we(vif.we),
    .oe(vif.oe),
    .data(vif.data)
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
  
