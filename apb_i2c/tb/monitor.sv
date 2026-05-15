class monitor;
  
  transaction tr;
  virtual apb_alu_if vif;
  mailbox #(transaction) mon2scb;
  
  function new(virtual apb_alu_if vif, mailbox #(transaction) mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task run();
    @(vif.mon_cb);
    forever begin
      tr = new();
      
      @(vif.mon_cb);
      
      tr.presetn  = vif.mon_cb.presetn;
      tr.psel     = vif.mon_cb.psel;
      tr.penable  = vif.mon_cb.penable;
      tr.pwrite   = vif.mon_cb.pwrite;
      tr.paddr    = vif.mon_cb.paddr;
      tr.pwdata   = vif.mon_cb.pwdata;
      tr.prdata   = vif.mon_cb.prdata;
      tr.pready   = vif.mon_cb.pready;
      tr.pslverr  = vif.mon_cb.pslverr;
      
      tr.scl_i    = vif.mon_cb.scl_i  ;
      tr.scl_o    = vif.mon_cb.scl_o  ;
      tr.scl_oen  = vif.mon_cb.scl_oen;
      tr.sda_i    = vif.mon_cb.sda_i  ;
      tr.sda_o    = vif.mon_cb.sda_o  ;
      tr.sda_oen  = vif.mon_cb.sda_oen;
      
      mon2scb.put(tr);
      tr.display("MON");
    end
  endtask
endclass
