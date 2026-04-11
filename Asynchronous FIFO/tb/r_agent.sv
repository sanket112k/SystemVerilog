`include "r_generator.sv"
`include "r_driver.sv"
`include "r_monitor.sv"

class r_agent;
  
  mailbox #(r_transaction) rgen2drv;
  mailbox #(r_transaction) rmon2scb;
  
  r_generator rgen;
  r_driver    rdrv;
  r_monitor   rmon;
  
  function new(virtual fifo_read_if rvif);
    rgen2drv = new();
    rmon2scb = new();
    
    rgen = new(rgen2drv);
    rdrv = new(rvif, rgen2drv);
    rmon = new(rvif, rmon2scb);
  endfunction
endclass
