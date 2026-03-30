class driver;

  virtual fa_if vif;                // virtual handle of inf to send data
  mailbox #(transaction) gen2drv;
  transaction tr;

  function new(virtual fa_if vif, mailbox #(transaction) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task run();
    forever begin
      gen2drv.get(tr);    // 1st get data
      vif.a   <= tr.a;    // 2nd trnsaction level to signal level
      vif.b   <= tr.b;
      vif.cin <= tr.cin;
      #1;                 // 3rd wait before sending next signals
    end
  endtask
endclass
