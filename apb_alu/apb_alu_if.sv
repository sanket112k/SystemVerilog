interface apb_if(input logic pclk, input logic presetn);
  import tb_pkg::*;
  
  logic 		 psel;
  logic 		 penable;
  logic 		 pwrite;
  logic [AW-1:0] paddr;
  logic [DW-1:0] pwdata;
  logic [DW-1:0] prdata;
  logic 		 pready;
  logic 		 pslverr;
  
  clocking drv_cb @(posedge pclk);
    default input #1step output #0;
    output psel, penable, pwrite, paddr, pwdata;
    input prdata, pready, pslverr;
  endclocking
  
  clocking mon_cb @(posedge pclk);
    default input #1step output #0;
    input psel, penable, pwrite, paddr, pwdata, prdata, pready, pslverr;
  endclocking
  
  modport drv_mp (clocking drv_cb, input pclk, presetn);
  modport mon_mp (clocking mon_cb, input pclk, presetn);
endinterface
