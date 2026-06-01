class monitor;

  virtual fa_if vif;
  mailbox #(transaction) mon2scb;
  transaction tr;
  event drv_done;

  function new(virtual fa_if vif, mailbox #(transaction) mon2scb, event drv_done);
    this.vif      = vif;
    this.mon2scb  = mon2scb;
    this.drv_done = drv_done;
  endfunction

  task run();
    @(vif.mon_cb);
    forever begin
      tr = new();
      
      @(vif.mon_cb);

      tr.a   = vif.mon_cb.a;
      tr.b   = vif.mon_cb.b;
      tr.cin = vif.mon_cb.cin;
      tr.sum = vif.mon_cb.sum;
      tr.cout= vif.mon_cb.cout;

      mon2scb.put(tr);
      tr.display("MON");
      @(drv_done);
    end
  endtask

endclass
