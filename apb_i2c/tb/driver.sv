class driver;
  
  transaction tr;
  virtual apb_alu_if vif;
  mailbox #(transaction) gen2drv;
  
  function new(virtual apb_alu_if vif, mailbox #(transaction) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    forever begin
      gen2drv.get(tr);
      tr.display("DRV");
      
      @(vif.drv_cb);
      
      vif.drv_cb.presetn <= tr.presetn;
      vif.drv_cb.psel    <= tr.psel;
      vif.drv_cb.penable <= tr.penable;
      vif.drv_cb.pwrite  <= tr.pwrite;
      vif.drv_cb.paddr   <= tr.paddr;
      vif.drv_cb.pwdata  <= tr.pwdata;
      
      vif.drv_cb.scl_i   <= tr.scl_i;
      vif.drv_cb.sda_i   <= tr.sda_i;
    end
  endtask
endclass
