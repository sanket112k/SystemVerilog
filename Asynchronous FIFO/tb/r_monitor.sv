class r_monitor;
  
  r_transaction rtr;
  virtual fifo_read_if rvif;
  mailbox #(r_transaction) rmon2scb;
  
  function new(virtual fifo_read_if rvif, mailbox #(r_transaction) rmon2scb);
    this.rvif = rvif;
    this.rmon2scb = rmon2scb;
  endfunction
  
  task run();
    @(rvif.r_mon_cb);
    forever begin
      rtr = new();
      
      @(rvif.r_mon_cb);
      
      rtr.rreset  = rvif.r_mon_cb.rreset;
      rtr.ren     = rvif.r_mon_cb.ren;
      rtr.rdata   = rvif.r_mon_cb.rdata;
      rtr.empty   = rvif.r_mon_cb.empty;
      rtr.rvalid  = rvif.r_mon_cb.rvalid;
      
      rmon2scb.put(rtr);
      rtr.display("RMON");
    end
  endtask
endclass
