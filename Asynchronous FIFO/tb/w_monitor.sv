class w_monitor;
  
  w_transaction wtr;
  virtual fifo_write_if wvif;
  mailbox #(w_transaction) wmon2scb;
  
  function new(virtual fifo_write_if wvif, mailbox #(w_transaction) wmon2scb);
    this.wvif = wvif;
    this.wmon2scb = wmon2scb;
  endfunction
  
  task run();
    @(wvif.w_mon_cb);
    forever begin
      wtr = new();
      
      @(wvif.w_mon_cb);
      
      wtr.wreset = wvif.w_mon_cb.wreset;
      wtr.wen    = wvif.w_mon_cb.wen;
      wtr.wdata  = wvif.w_mon_cb.wdata;
      wtr.full   = wvif.w_mon_cb.full;
      
      wmon2scb.put(wtr);
      wtr.display("WMON");
    end
  endtask
endclass
