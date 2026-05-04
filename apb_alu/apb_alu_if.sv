interface apb_alu_if(input logic pclk);
  import tb_pkg::*;
  
  logic 		 presetn,
  logic 		 psel,
  logic 		 penable,
  logic 		 pwrite,
  logic [AW-1:0] paddr,
  logic [DW-1:0] pwdata,
  logic [DW-1:0] prdata,
  logic 		 pready,
  logic 		 pslverr,
  
  clocking drv_cb @(posedge clk);
    default input #1step output #0;
    output presetn, psel, penable, pwrite, paddr, pwdata;
    input prdata, pready, pslaverr;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1step output #0;
    input presetn, psel, penable, pwrite, paddr, pwdata, prdata, pready, pslaverr;
  endclocking
  
  modport drv_mp (clocking drv_cb);
  modport mom_mp (clocking mon_cb);
endinterface
