class monitor;
  
  transaction tr;
  virtual fifo_if vif;
  mailbox #(transaction) mon2scb;
  
  function new(virtual fifo_if vif, mailbox #(transaction) mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task run();
    forever begin
      tr = new();
      
      @(vif.cb);
      
      tr.resetn   = vif.resetn;
      tr.w_en     = vif.w_en;
      tr.r_en     = vif.r_en;
      tr.data_in  = vif.data_in;
      tr.data_out = vif.data_out;
      tr.full     = vif.full;
      tr.empty    = vif.empty;
      
      mon2scb.put(tr);
      tr.display("MON");
    end
  endtask
endclass
