class driver;

  virtual fa_if vif;
  mailbox #(transaction) gen2drv;
  transaction tr;
  event drv_done;

  function new(virtual fa_if vif, mailbox #(transaction) gen2drv, event drv_done);
    this.vif      = vif;
    this.gen2drv  = gen2drv;
    this.drv_done = drv_done;
  endfunction

  task run();
    forever begin
      gen2drv.get(tr);
      @(vif.drv_cb);
      
      vif.drv_cb.a   <= tr.a;
      vif.drv_cb.b   <= tr.b;
      vif.drv_cb.cin <= tr.cin;

      tr.display("DRV");
      -> drv_done;
    end
  endtask

endclass
