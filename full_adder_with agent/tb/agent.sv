`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent;
  
  int num_trans = 10;
  generator gen;
  driver drv;
  monitor mon;
  event drv_done, scb_done;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb;

  function new(virtual fa_if vif, event scb_done);

    gen2drv = new(1);
    mon2scb = new(1);

    gen = new(gen2drv, num_trans, scb_done);
    drv = new(vif, gen2drv, drv_done);
    mon = new(vif, mon2scb, drv_done);
    this.scb_done = scb_done;

  endfunction

endclass
