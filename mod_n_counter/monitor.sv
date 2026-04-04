class monitor;
  virtual count_if vif;
  mailbox #(transaction) mon2scb;
  
  function new(virtual count_if vif, mailbox #(transaction) mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task run();
    transaction tr;
    
    forever begin
      @(vif.cb);
      
      tr = new();
      tr.count = vif.count;
      tr.reset = vif.reset;
      
      mon2scb.put(tr);
    end
  endtask
endclass
