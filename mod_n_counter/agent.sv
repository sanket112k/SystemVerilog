`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent;

  generator gen;
  driver drv;
  monitor mon;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb;

  function new(virtual count_if vif);

    gen2drv = new();
    mon2scb = new();

    gen = new(gen2drv, 50);
    drv = new(vif, gen2drv);
    mon = new(vif, mon2scb);

  endfunction

endclass
