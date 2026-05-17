class monitor;
  
  // transaction tr;
  virtual apb_if.mon_mp vif;
  mailbox mon2scb;
  
  function new(virtual apb_if.mon_mp vif, mailbox mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task run();
    apb_transaction tr;
    $display("[MON] Starting monitor");
    forever begin
      @(posedge vif.pclk);
      if (vif.mon_cb.psel && vif.mon_cb.penable && vif.mon_cb.pready) begin
        tr = new();
        tr.pwrite   = vif.mon_cb.pwrite;
        tr.paddr    = vif.mon_cb.paddr;
        tr.pwdata   = vif.mon_cb.pwdata;
        tr.prdata   = vif.mon_cb.prdata;
        tr.pslverr  = vif.mon_cb.pslverr;
        mon2scb.put(tr);
      end
      //tr.display("MON");
    end
  endtask
endclass
