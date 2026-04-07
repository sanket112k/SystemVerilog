interface ram_if(input logic clk);
  import tb_pkg::*;
  logic [ADDR_WIDTH-1 : 0] addr;
  logic cs, we, oe;
  wire [DATA_WIDTH-1 : 0] data;
  
  clocking cb @(posedge clk);
    default input #1step output #0;
    output addr, cs, we, oe;
    inout data;
  endclocking
  
  modport drv (clocking cb);
  modport mon (clocking cb);
  
  //modport drv (output addr, cs, we, oe, inout data, input clk);
  //modport mon (input addr, cs, we, oe, data, clk);
  
endinterface
