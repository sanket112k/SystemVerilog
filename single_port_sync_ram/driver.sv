class driver;
  virtual ram_if vif;
  mailbox #(transaction) gen2drv;
  
  function new(virtual ram_if vif, mailbox #(transaction) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    transaction tr;
    
    forever begin
      //$display("[DRV] Waiting for transaction");
      gen2drv.get(tr);
      //$display("[DRV] Got transaction");
      
      @(vif.cb);
      
      vif.cb.addr <= tr.addr;
      vif.cb.cs <= tr.cs;
      vif.cb.we <= tr.we;
      vif.cb.oe <= tr.oe;
      if (tr.we)
        vif.cb.data <= tr.data;
      else
        vif.cb.data <= 'bz;
      //$display("[DRV] Converted to signal level");
      
      tr.display("DRV");
    end
  endtask
endclass
