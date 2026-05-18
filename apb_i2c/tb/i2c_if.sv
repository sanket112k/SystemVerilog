interface i2c_if();
  import tb_pkg::*;
  
  wire scl;
  wire sda;
  
  pullup(scl);
  pullup(sda);
  
  clocking drv_cb @(posedge scl);
    default input #1step output #0;
    output sda;
  endclocking
  
  clocking mon_cb @(posedge scl);
    default input #1step output #0;
    input scl, sda;
  endclocking
  
  modport drv_mp (clocking drv_cb);
  modport mom_mp (clocking mon_cb);
endinterface
