`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb;
  
  virtual intf vif;
  function new (virtual intf vif);
    this.vif = vif;
    gen2drv = new();
    mon2scb = new();
  	gen = new(gen2drv);
  	drv = new(gen2drv);
  	mon = new(mon2scb);
  	scb = new(mon2scb);
  endfunction
  
  task test_run();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none
    
    wait(gen.num_transactions == 0);
    #10;
    scb.report();
    $finish;
  endtask
endclass
