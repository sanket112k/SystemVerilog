class w_driver;
  
  w_transaction wtr;
  virtual fifo_write_if wvif;
  mailbox #(w_transaction) wgen2drv;
  
  function new(virtual fifo_write_if wvif, mailbox #(w_transaction) wgen2drv);
    this.wvif = wvif;
    this.wgen2drv = wgen2drv;
  endfunction
  
  task run();
    forever begin
      wgen2drv.get(wtr);
      wtr.display("WDRV");
      
      @(wvif.w_drv_cb);
      
      wvif.w_drv_cb.wreset <= wtr.wreset;
      wvif.w_drv_cb.wen    <= wtr.wen;
      wvif.w_drv_cb.wdata  <= wtr.wdata;
    end
  endtask
endclass
