`include "transaction.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class environment;
  agent      agt;
  scoreboard scb;
  coverage   cov;
  
  virtual apb_if.drv_mp vif_drv;
  virtual apb_if.mon_mp vif_mon;
  
  function new(virtual apb_if vif);
    vif_drv = vif.drv_mp;
    vif_mon = vif.mon_mp;
    agt = new(vif_drv, vif_mon);
    scb = new(agt.drv2scb, agt.mon2scb);
    cov = new(agt.drv2cov);
  endfunction
  
  task run();
    $display("[ENV] Starting environment");
    scb.expected_alu_checks = agt.gen.num_items;
    fork
      agt.gen.run();
      agt.drv.run();
      agt.mon.run();
      scb.run();
      cov.run();
    join_none
    
    @(scb.all_done);
    #100;
    scb.report();
    cov.report();
  endtask
endclass
