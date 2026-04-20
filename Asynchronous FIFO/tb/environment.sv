`include "w_transaction.sv"
`include "r_transaction.sv"
`include "w_agent.sv"
`include "r_agent.sv"
`include "scoreboard.sv"

class environment;
  w_agent wagt;
  r_agent ragt;
  scoreboard scb;
  
  function new(virtual fifo_write_if wvif, virtual fifo_read_if rvif);
    wagt = new(wvif);
    ragt = new(rvif);
    scb = new(wagt.wmon2scb,
              ragt.rmon2scb, 
              wagt.wcount_mb, 
              ragt.rcount_mb);
  endfunction
  
  task run();
    fork
      wagt.run();
      ragt.run();
      scb.run();
    join_none
    
    @(scb.done);
    scb.report();
    $finish;
  endtask
endclass
