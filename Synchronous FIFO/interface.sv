interface fifo_if(input logic clk);
  import tb_pkg::*;
  
  logic resetn;
  logic w_en;
  logic r_en;
  logic [DATA_WIDTH-1 : 0] data_in;
  logic [DATA_WIDTH-1 : 0] data_out;
  logic full;
  logic empty;
  
  clocking drv_cb @(posedge clk);
    default input #1step output #0;
    output resetn, w_en, r_en, data_in;
    input full, empty, data_out;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #0;
    input resetn, w_en, r_en, data_in;
    input full, empty, data_out;
  endclocking
  
  modport drv_mp (clocking drv_cb);
  modport mon_mp (clocking mon_cb);
  
endinterface
