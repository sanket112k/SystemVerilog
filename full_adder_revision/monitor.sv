class monitor;

  virtual fa_if vif;
  mailbox #(transation) mon2scb;
  transaction tr;

  function new(virtual fa_if vif, mailbox #(transation) mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction

  task run();
    forever begin
      tr = new();         // 1st creates a new object in every single iteration
      #1;                 // 2nd wait for the operation to complete
      tr.a = vif.a;       // 3rd convert signal level to transaction level
      tr.b = vif.b;
      tr.cin = vif.cin;
      tr.sum = vif.sum;
      mon2scb.put(tr);    // 4th send data to scoreboard
    end
  endtask
endclass
