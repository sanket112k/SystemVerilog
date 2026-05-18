class apb_monitor;
  virtual apb_if.drv_mp apb_vif;
  mailbox #(apb_transaction) mon2scb;

  function new(virtual apb_if.drv_mp apb_vif,
               mailbox #(apb_transaction) mon2scb);
    this.apb_vif = apb_vif;
    this.mon2scb  = mon2scb;
  endfunction

  task run();
    forever begin
      @(posedge apb_vif.pclk);
      if (apb_vif.mon_cb.psel && apb_vif.mon_cb.penable && apb_vif.mon_cb.pready) begin
        apb_transaction apb_tr = new();
        apb_tr.pwrite  = apb_vif.mon_cb.pwrite;
        apb_tr.paddr   = apb_vif.mon_cb.paddr;
        apb_tr.pwdata  = apb_vif.mon_cb.pwdata;
        apb_tr.prdata  = apb_vif.mon_cb.prdata;
        mon2scb.put(apb_tr);
      end
    end
  endtask
endclass
