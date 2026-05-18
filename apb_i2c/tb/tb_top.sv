`timescale 1ns/1ps

`include "i2c_master_defines.svh"
`include "tb_pkg.sv"
`include "interface.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic pclk;
  logic presetn;
  
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk;
  end
  
  initial begin
    presetn = 0;
    repeat(5) @(posedge pclk);
    presetn = 1;
  end
  
  apb_if apb_if_inst(.pclk(pclk), .presetn(presetn));
  i2c_if i2c_if_inst();
  
  apb_i2c #(
    .DW(DW),
    .AW(AW)
  ) DUT (
    .pclk    (pclk),
    .presetn (presetn),
    
    .psel    (apb_if_inst.psel),
    .penable (apb_if_inst.penable),
    .pwrite  (apb_if_inst.pwrite),
    .paddr   (apb_if_inst.paddr),
    .pwdata  (apb_if_inst.pwdata),
    .prdata  (apb_if_inst.prdata),
    .pready  (apb_if_inst.pready),
    .pslverr (apb_if_inst.pslverr),
    
    .scl_i	 (i2c_if_inst.scl),
    .scl_o	 (dut_scl_o),
    .scl_oen (dut_scl_oen),
    .sda_i	 (i2c_if_inst.sda),
    .sda_o	 (dut_sda_o),
    .sda_oen (dut_sda_oen)
  );
  
  // Connect I2C tristates
  assign i2c_if_inst.scl = dut_scl_oen ? 1'bz : dut_scl_o;
  assign i2c_if_inst.sda = dut_sda_oen ? 1'bz : dut_sda_o;
  
  test t;
  initial begin
    t = new(apb_if_inst, i2c_if_inst);
    
    wait(presetn == 1);
    repeat(2) @(posedge pclk);
    t.run();
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, tb_top);
  end
endmodule
