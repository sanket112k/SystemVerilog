`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent;
  mailbox gen2drv;
  mailbox mon2scb;
  mailbox drv2scb;
  mailbox drv2cov;
  
  generator gen;
  driver    drv;
  monitor   mon;
  
  virtual apb_if.drv_mp vif_drv;
  virtual apb_if.mon_mp vif_mon;
  
  function new(virtual apb_if.drv_mp vif_drv, virtual apb_if.mon_mp vif_mon);
    this.vif_drv = vif_drv;
    this.vif_mon = vif_mon;
    gen2drv = new();
    mon2scb = new();
    drv2scb = new();
    drv2cov = new();
    gen = new(gen2drv);
    drv = new(vif_drv, gen2drv, drv2scb, drv2cov);
    mon = new(vif_mon, mon2scb);
  endfunction
endclass
