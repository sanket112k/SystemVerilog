class monitor;
  
  transaction tr;
  virtual fifo_if vif;
  mailbox #(transaction) mon2scb;
  
  function new(virtual fifo_if vif, mailbox #(transaction) mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task run();
    @(vif.mon_cb);
    forever begin
      tr = new();
      
      @(vif.mon_cb);
      
      tr.resetn   = vif.mon_cb.resetn;
      tr.w_en     = vif.mon_cb.w_en;
      tr.r_en     = vif.mon_cb.r_en;
      tr.data_in  = vif.mon_cb.data_in;
      tr.data_out = vif.mon_cb.data_out;
      tr.full     = vif.mon_cb.full;
      tr.empty    = vif.mon_cb.empty;
      
      mon2scb.put(tr);
      tr.display("MON");
    end
  endtask
endclass
