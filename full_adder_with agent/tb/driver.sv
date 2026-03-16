class driver;

  virtual fa_if vif;
  mailbox #(transaction) gen2drv;
  transaction tr;

  function new(virtual fa_if vif, mailbox #(transaction) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task run();
    forever begin
      gen2drv.get(tr);

      vif.a   <= tr.a;
      vif.b   <= tr.b;
      vif.cin <= tr.cin;

      #1;
    end
  endtask

endclass
