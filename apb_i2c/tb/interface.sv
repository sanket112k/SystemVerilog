interface apb_i2c_if(input logic pclk, input logic presetn);
  import tb_pkg::*;
  
  logic 		 psel;
  logic 		 penable;
  logic 		 pwrite;
  logic [AW-1:0] paddr;
  logic [DW-1:0] pwdata;
  logic [DW-1:0] prdata;
  logic 		 pready;
  logic 		 pslverr;
  
  logic          scl_i,
  logic          scl_o,
  logic          scl_oen,
  logic          sda_i,
  logic          sda_o,
  logic          sda_oen
  
  clocking drv_cb @(posedge clk);
    default input #1step output #0;
    output psel, penable, pwrite, paddr, pwdata;
    input prdata, pready, pslaverr;
    output scl_i, sda_i;
    input scl_o, sda_o, scl_oen, sda_oen;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1step output #0;
    input psel, penable, pwrite, paddr, pwdata, prdata, pready, pslaverr;
    input scl_i, sda_i, scl_o, sda_o, scl_oen, sda_oen;
  endclocking
  
  modport drv_mp (clocking drv_cb, input pclk, presetn);
  modport mom_mp (clocking mon_cb, input pclk, presetn);
endinterface
