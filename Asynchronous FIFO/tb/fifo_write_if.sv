interface fifo_write_if(input logic wclk);
  import tb_pkg::*;
  
  logic 				   wreset;
  logic 				   wen;
  logic [DATA_WIDTH-1 : 0] wdata;
  logic 				   full;
  
  clocking w_drv_cb @(posedge wclk);
    default input #1step output #0;
    output wreset, wen, wdata;
    input full;
  endclocking
  
  clocking w_mon_cb @(posedge wclk);
    default input #0;
    input wreset, wen, wdata;
    input full;
  endclocking
  
  modport w_drv_mp (clocking w_drv_cb, import task wait_clocks(int n));
  modport w_mon_mp (clocking w_mon_cb);
  modport dut_mp   (input wreset, wen, wdata, input full);
  
  task automatic wait_clock(int n);
    repeat(n) @(posedge wclk);
  endtask
endinterface
