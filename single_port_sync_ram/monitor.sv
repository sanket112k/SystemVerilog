class monitor;
  virtual ram_if vif;
  mailbox #(transaction) mon2scb;
  
  function new(virtual ram_if vif, mailbox #(transaction) mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task run();
    transaction tr;
    
    forever begin
      @(posedge vif.clk);
      
      if (vif.cs) begin
        tr = new();
        tr.addr = vif.data;
        tr.cs = vif.cs;
        tr.we = vif.we;
        tr.oe = vif.oe;
        
        if (vif.we)
          tr.data = vif.data;
        else
          tr.rdata = vif.data;
        
        mon2scb.put(tr);
        tr.display("MON");
      end
    end
  endtask
endclass
        
