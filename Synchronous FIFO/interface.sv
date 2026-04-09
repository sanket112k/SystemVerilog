interface fifo_if(input logic clk);
  import tb_pkg::*;
  
  logic resetn;
  logic w_en;
  logic r_en;
  logic [DATA_WIDTH-1 : 0] data_in;
  logic [DATA_WIDTH-1 : 0] data_out;
  logic full;
  logic empty;
  
  clocking cb @(posedge clk);
    default input #1step output #0;
    output resetn, w_en, r_en, data_in;
    input full, empty, data_out;
  endclocking
  
  modport drv (output resetn, w_en, r_en, data_in, input full, empty, data_out);
  modport mon (input resetn, w_en, r_en, data_in, full, empty, data_out);
endinterface
