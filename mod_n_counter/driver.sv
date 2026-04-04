class driver;
  
  virtual count_if vif;
  mailbox #(transaction) gen2drv;
  
  function new(virtual count_if vif, mailbox #(transaction) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    transaction tr;
    
    forever begin
      gen2drv.get(tr);
      
      vif.cb.reset <= tr.reset;
      
      @(vif.cb);
    end
  endtask
  
endclass
