class monitor;

  virtual fa_if vif;
  mailbox #(transaction) mon2scb;
  transaction tr;

  function new(virtual fa_if vif, mailbox #(transaction) mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction

  task run();
    forever begin
      tr = new();

      #1;

      tr.a   = vif.a;
      tr.b   = vif.b;
      tr.cin = vif.cin;
      tr.sum = vif.sum;
      tr.cout= vif.cout;

      mon2scb.put(tr);
    end
  endtask

endclass
