`include "apb_alu_defines.svh"

class driver;
  
  //transaction tr;
  virtual apb_if.drv_mp vif;
  mailbox gen2drv;
  mailbox drv2scb;
  mailbox drv2cov;
  int timeout_cycles = 500;
  
  function new(virtual apb_if.drv_mp vif, mailbox gen2drv, mailbox drv2scb, mailbox drv2cov);
    this.vif = vif;
    this.gen2drv = gen2drv;
    this.drv2scb = drv2scb;
    this.drv2cov = drv2cov;
  endfunction
  
  task run();
    alu_in_transaction in_tr;
    alu_out_transaction out_tr;
    $display("[DRV] Starting driver");
    forever begin
      gen2drv.get(in_tr);
      out_tr = new();
      run_alu_sequence(in_tr, out_tr);
      drv2scb.put(in_tr);
      drv2scb.put(out_tr);
      if (drv2cov != null) begin
        drv2cov.put(in_tr);
        drv2cov.put(out_tr);
      end
    end
  endtask
  
  task run_alu_sequence(alu_in_transaction in_tr, alu_out_transaction out_tr);
    // Write A, B & opcode
    apb_write(`A_OPA, in_tr.op_a);
    apb_write(`A_OPB, in_tr.op_b);
    apb_write(`A_OPCODE, {28'h0, in_tr.opcode});
    // start
    apb_write(`A_CTRL, 32'h1);
    // poll done
    apb_poll_done();
    // read status, result, flags
    apb_read(`A_STATUS);
    out_tr.opc_illegal = vif.drv_cb.prdata[`STATUS_ERR];
    apb_read(`A_RESULT);
    out_tr.y = vif.drv_cb.prdata;
    apb_read(`A_FLAGS);
    out_tr.flags = vif.drv_cb.prdata[3:0];
    // clear done
    apb_write(`A_STATUS, `W1C_DONE);
  endtask
  
  task apb_write(byte addr, bit [DW-1:0] data);
    @(posedge vif.pclk);
    vif.drv_cb.psel    <= 1;
    vif.drv_cb.pwrite  <= 1;
    vif.drv_cb.paddr   <= addr;
    vif.drv_cb.pwdata  <= data;
    vif.drv_cb.penable <= 0;
    @(posedge vif.pclk);
    vif.drv_cb.penable <= 1;
    @(posedge vif.pclk);
    while (!vif.drv_cb.pready) @(posedge vif.pclk);
    vif.drv_cb.psel    <= 0;
    vif.drv_cb.pwrite  <= 0;
    vif.drv_cb.paddr   <= 0;
    vif.drv_cb.pwdata  <= 0;
    vif.drv_cb.penable <= 0;
  endtask
  
  task apb_read(byte addr);
    @(posedge vif.pclk);
    vif.drv_cb.psel    <= 1;
    vif.drv_cb.pwrite  <= 0;
    vif.drv_cb.paddr   <= addr;
    vif.drv_cb.pwdata  <= 0;
    vif.drv_cb.penable <= 0;
    @(posedge vif.pclk);
    vif.drv_cb.penable <= 1;
    @(posedge vif.pclk);
    while (!vif.drv_cb.pready) @(posedge vif.pclk);
    vif.drv_cb.psel    <= 0;
    vif.drv_cb.paddr   <= 0;
    vif.drv_cb.penable <= 0;
  endtask
  
  task apb_poll_done();
    int k = 0;
    apb_read(`A_STATUS);
    while (vif.drv_cb.prdata[`STATUS_DONE] != 1) begin
      apb_read(`A_STATUS);
      k++;
      if (k > timeout_cycles) begin
        $error("[DRV] Timeout waiting for done");
        return;
      end
    end
  endtask
endclass
