class r_driver;
  
  r_transaction rtr;
  virtual fifo_read_if rvif;
  mailbox #(r_transaction) rgen2drv;
  
  function new(virtual fifo_read_if rvif, mailbox #(r_transaction) rgen2drv);
    this.rvif = rvif;
    this.rgen2drv = rgen2drv;
  endfunction
  
  task run();
    forever begin
      rgen2drv.get(rtr);
      rtr.display("RDRV");
      
      @(rvif.r_drv_cb);
      
      rvif.r_drv_cb.rreset <= rtr.rreset;
      rvif.r_drv_cb.ren    <= rtr.ren;
    end
  endtask
endclass
