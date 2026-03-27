class driver;

  virtual dff_if vif;
  mailbox #(transaction) gen2drv;

  function new(virtual dff_if vif,
               mailbox #(transaction) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task run();
    transaction tr;

    forever begin
      gen2drv.get(tr);

      vif.cb.d     <= tr.d;
      vif.cb.reset <= tr.reset;

      @(vif.cb);
    end
  endtask

endclass
