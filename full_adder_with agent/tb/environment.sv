`include "transaction.sv"
`include "agent.sv"
`include "scoreboard.sv"

class environment;

  agent agt;
  scoreboard scb;
  event scb_done;

  function new(virtual fa_if vif);
    agt = new(vif, scb_done);
    scb = new(agt.mon2scb, agt.gen.num_trans, scb_done);
  endfunction

  task run();

    fork
      agt.gen.run();
      agt.drv.run();
      agt.mon.run();
      scb.run();
    join_none
    
    fork
      begin
        @(scb.test_done);
        $display("Scoreboard ended");
      end
      begin
        #300;
        $display("Time-out");
      end
    join_any
    #20;
    scb.report();
    $finish;
  endtask
endclass
