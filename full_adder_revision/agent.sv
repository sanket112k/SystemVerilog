`include "genrator.v"
`include "driver.v"
`include "monitor.v"

class agent;

  generator gen;
  driver drv;
  monitor mon;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb;

  function new(virtual fa_if vif);
    gen2drv = new();
    mon2scb = new();

    gen = new(gen2drv);
    mon = new(vif, gen2drv);
    drv = new(vif, mon2scb);
  endfunction
endclass
