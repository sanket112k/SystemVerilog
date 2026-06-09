class scoreboard;
  w_transaction wtr;
  r_transaction rtr;
  mailbox #(w_transaction) wmon2scb;
  mailbox #(r_transaction) rmon2scb;

  int pass, fail;
  int items_written;
  event done;

  bit [DATA_WIDTH-1:0] ref_queue[$];
  bit [DATA_WIDTH-1:0] exp_rdata;
  bit exp_empty;

  function new(mailbox #(w_transaction) wmon2scb, mailbox #(r_transaction) rmon2scb);
    this.wmon2scb = wmon2scb;
    this.rmon2scb = rmon2scb;
  endfunction

  task run();
    fork
      forever begin
        wmon2scb.get(wtr);
        if (!wtr.wreset && wtr.wen && !wtr.full) begin
          ref_queue.push_back(wtr.wdata);
          items_written++;
          $display("[%0t]  SCB:        queued wdata=%0h (queue depth=%0d)", $time, wtr.wdata, ref_queue.size());
        end
        $display("---------------------------------------------------------------------------------");
      end

      forever begin
        rmon2scb.get(rtr);
        if (!rtr.rreset && rtr.rvalid) begin
          if (ref_queue.size() == 0) begin
            $error("[SCB]  SCB: {FAIL} rvalid but queue empty at %0t", $time);
            fail++;
          end else begin
            exp_rdata = ref_queue.pop_front();
            exp_empty = (ref_queue.size() == 0);

            if (rtr.rdata === exp_rdata) begin
              $display("[%0t]  SCB: {PASS} exp=%0h got=%0h", $time, exp_rdata, rtr.rdata);
              pass++;
            end else begin
              $error("[%0t]  SCB: {FAIL} exp=%0h got=%0h", $time, exp_rdata, rtr.rdata);
              fail++;
            end
          end
        end
        $display("----------------------- items_written=%0d Pass=%0d Fail=%0d ---------------------", items_written, pass, fail);
      end
      
      begin
        wait (pass + fail == items_written && items_written != 0);
        #50;
        -> done;
      end
    join_none
  endtask

  function void report();
    $display("======== REPORT ========");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
    $display("========================");
  endfunction
endclass
