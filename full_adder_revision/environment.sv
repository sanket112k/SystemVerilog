`include "transaction.sv"
`include "agent.sv"
`include "scoreboard.sv"

class environment;

  function new(virtual fa_if vif);
    agt = new(vif);
    scb = new(agt.mon2scb);
  endfunction

  task run();
    fork
      agt.gen.run();
      agt.gen.run();
      agt.gen.run();
      scb.run();
    join_none
  endtask
endclass
