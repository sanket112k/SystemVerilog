`include "w_generator.sv"
`include "w_driver.sv"
`include "w_monitor.sv"

class w_agent;
  
  mailbox #(w_transaction) wgen2drv;
  mailbox #(w_transaction) wmon2scb;
  
  w_generator wgen;
  w_driver    wdrv;
  w_monitor   wmon;
  
  function new(virtual fifo_write_if wvif);
    wgen2drv = new();
    wmon2scb = new();
    
    wgen = new(wgen2drv);
    wdrv = new(wvif, wgen2drv);
    wmon = new(wvif, wmon2scb);
    
  endfunction
  
  task run();
    fork
      wgen.run();
      wdrv.run();
      wmon.run();
    join_none
  endtask
endclass
