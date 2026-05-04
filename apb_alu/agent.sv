`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent;
  
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb;
  
  generator gen;
  driver drv;
  monitor mon;
  
  function new(virtual fifo_if vif);
    gen2drv = new();
    mon2scb = new();
    
    gen = new(gen2drv);
    drv = new(vif, gen2drv);
    mon = new(vif, mon2scb);
  endfunction
endclass
