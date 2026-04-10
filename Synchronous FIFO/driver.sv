class driver;
  
  transaction tr;
  virtual fifo_if vif;
  mailbox #(transaction) gen2drv;
  
  function new(virtual fifo_if vif, mailbox #(transaction) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    forever begin
      gen2drv.get(tr);
      tr.display("DRV");
      
      @(vif.drv_cb);
      
      vif.drv_cb.resetn  <= tr.resetn;
      vif.drv_cb.w_en    <= tr.w_en;
      vif.drv_cb.r_en    <= tr.r_en;
      vif.drv_cb.data_in <= tr.data_in;
    end
  endtask
endclass
