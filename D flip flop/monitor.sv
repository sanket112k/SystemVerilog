class monitor;

  virtual dff_if vif;
  mailbox #(transaction) mon2scb;

  function new(virtual dff_if vif,
               mailbox #(transaction) mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction

  task run();
    transaction tr;

    forever begin
      @(vif.cb);

      tr = new();
      tr.d     = vif.d;
      tr.reset = vif.reset;
      tr.q     = vif.q;

      mon2scb.put(tr);
    end
  endtask

endclass
