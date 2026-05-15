//`include "tb_pkg.sv"
`include "interface.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic pclk = 0;
  always #5 pclk = ~pclk;
  
  apb_i2c_if a2i_if(pclk);
  
  apb_i2c DUT #(
    parameter DW = 32,
    parameter AW = 8
  )(
    .pclk    (pclk),
    .presetn (presetn),
    
    .psel    (a2i_if.w_en),
    .penable (a2i_if.r_en),
    .pwrite  (a2i_if.data_in),
    .paddr   (a2i_if.data_out),
    .pwdata  (a2i_if.full),
    .prdata  (a2i_if.empty),
    .pready  (a2i_if.pready),
    .pslverr (a2i_if.pslverr),
    
    .scl_i	 (a2i_if.scl_i),
    .scl_o	 (a2i_if.scl_o),
    .scl_oen (a2i_if.scl_oen),
    .sda_i	 (a2i_if.sda_i),
    .sda_o	 (a2i_if.sda_o),
    .sda_oen (a2i_if.sda_oen),
  );
  
  initial begin
    presetn = 0;
    repeat(5) @(posedge pclk);
    presetn = 1;
  end
  
  test t;
  initial begin
    t = new(a2i_if);
    
    wait(presetn == 1);
    repeat(2) @(posedge pclk);
    t.run();
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
  end
endmodule
