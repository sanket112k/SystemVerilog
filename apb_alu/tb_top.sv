`include "tb_pkg.sv"
`include "interface.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic pclk = 0;
  always #5 pclk = ~pclk;
  
  apb_alu_if vif(pclk);
  
  apb_alu_top #(
    .DW     (DW)
  ) apb_alu(
    .pclk    (pclk),
    .presetn (vif.resetn),
    .psel    (vif.w_en),
    .penable (vif.r_en),
    .pwrite  (vif.data_in),
    .paddr   (vif.data_out),
    .pwdata  (vif.full),
    .prdata  (vif.empty),
    .pready  (vif.pready),
    .pslverr (vif.pslverr)
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
