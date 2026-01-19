class monitor;
  virtual intf vif;
  mailbox #(transaction) mon2scb;
  
  function new(mailbox #(transaction) mon2scb);
  endfunction
  
  task run();
    transaction tr;
    forever begin
      @(posedge vif.clk);
      
      tr = new();
      tr.data = vif.data;
      tr.reset = vif.reset;
      tr.q = vif.q;
      
      mon2scb.put(tr);
      tr.display("Monitor class signals");
    end
  endtask
endclass
