class driver;
  virtual intf vif;
  mailbox #(transaction) gen2drv;
  
  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    transaction tr;
    forever begin
      gen2drv.get(tr);
      
      @(posedge vif.clk);
      vif.data <= tr.data;
      vif.reset <= tr.reset;
      tr.display("Driver class signals");
    end
  endtask
endclass
