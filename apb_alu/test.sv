`include "environment.sv"

class test;
  environment env;
  virtual apb_if vif;
  
  function new(virtual apb_if vif);
    this.vif = vif;
    env = new(vif);
  endfunction
  
  task run_directed();
    env.agt.gen.directed  = 1;
    env.agt.gen.num_items = 9;
    env.run();
  endtask
  
  task run_random(int num = 50, int seed_val = 1, int quota_val = 10);
    env.agt.gen.directed  = 0;
    env.agt.gen.num_items = num;
    env.agt.gen.seed      = seed_val;
    env.agt.gen.quota     = quota_val;
    env.run();
  endtask
endclass
