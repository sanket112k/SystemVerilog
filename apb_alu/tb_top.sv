`include "tb_pkg.sv"
`include "interface.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic pclk = 0;
  always #5 pclk = ~pclk;
  
  apb_alu_if apb_if(pclk);
  
  apb_alu_top #(.DW (DW)) apb_alu(
    .pclk    (pclk),
    .presetn (presetn),
    .psel    (apb_if.psel),
    .penable (apb_if.penable),
    .pwrite  (apb_if.pwrite),
    .paddr   (apb_if.paddr),
    .pwdata  (apb_if.pwdata),
    .prdata  (apb_if.prdata),
    .pready  (apb_if.pready),
    .pslverr (apb_if.pslverr),
  );
  
  initial begin
    presetn = 0;
    repeat(5) @(posedge pclk);
    presetn = 1;
  end
  
  test t;
  initial begin
    t = new(apb_if);
    
    wait(presetn == 1);
    repeat(2) @(posedge pclk);
    t.run();
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, tb_top);
  end
endmodule
