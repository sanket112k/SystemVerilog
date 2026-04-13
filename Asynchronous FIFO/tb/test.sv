`include "environment.sv"

class test;
  environment env;
  
  function new(virtual fifo_write_if wvif, virtual fifo_read_if rvif);
    env = new(wvif, rvif);
  endfunction
  
  task run;
    env.run();
  endtask
endclass
