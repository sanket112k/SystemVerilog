class apb_driver;
  virtual apb_if.drv_mp apb_vif;
  mailbox #(apb_transaction) gen2drv;
  event   drv_done;

  function new(virtual apb_if.drv_mp apb_vif,
               mailbox #(apb_transaction) gen2drv);
    this.apb_vif = apb_vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    apb_transaction apb_tr;
    forever begin
      gen2drv.get(apb_tr);
      @(posedge apb_vif.pclk);
      apb_vif.drv_cb.psel    <= 1;
      apb_vif.drv_cb.penable <= 0;
      apb_vif.drv_cb.pwrite  <= apb_tr.pwrite;
      apb_vif.drv_cb.paddr   <= apb_tr.paddr;
      apb_vif.drv_cb.pwdata  <= apb_tr.pdata;
      
      @(posedge apb_vif.pclk);
      vif.drv_cb.penable <= 1;
      @(posedge apb_vif.pclk);
      while (!apb_vif.drv_cb.pready) @(posedge vif.pclk);
      
      if (!apb_tr.write) begin
        apb_tr.prdata <= apb_vif.drv_cb.prdata;
      end
      
      apb_vif.drv_cb.psel    <= 0;
      apb_vif.drv_cb.penable <= 0;
      -> drv_done;
    end
  endtask
endclass
