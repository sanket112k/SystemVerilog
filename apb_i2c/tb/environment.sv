`include "transaction.sv"
`include "agent.sv"
`include "scoreboard.sv"

class environment;
  agent agt;
  scoreboard scb;
  
  function new(virtual fifo_if vif);
    agt = new(vif);
    scb = new(agt.mon2scb);
  endfunction
  
  task run();
    fork
      agt.gen.run();
      agt.drv.run();
      agt.mon.run();
      scb.run();
    join_none
    
    @(scb.done);
    scb.report();
    $finish;
  endtask
endclass
