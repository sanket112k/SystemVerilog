/*
//`include "tb_pkg.sv"
import tb_pkg::*;

class scoreboard;
  
  w_transaction wtr;
  r_transaction rtr;
  mailbox #(w_transaction) wmon2scb;
  mailbox #(r_transaction) rmon2scb;
  mailbox wcount_mb;
  mailbox rcount_mb;
  int pass, fail;
  int wcount, rcount;
  event done;
    
  bit [DATA_WIDTH-1 : 0] ref_queue [$];
  
  bit [DATA_WIDTH-1 : 0] exp_rdata;
  bit exp_full;
  bit exp_empty;
  
  function new(mailbox #(w_transaction) wmon2scb, 
               mailbox #(r_transaction) rmon2scb, 
               mailbox wcount_mb, 
               mailbox rcount_mb);
    this. wmon2scb = wmon2scb;
    this. rmon2scb = rmon2scb;
    this. wcount_mb = wcount_mb;
    this. rcount_mb = rcount_mb;
  endfunction
  
  task run();
    
    fork
      
      forever begin		// Thread 1: collect all writes into reference queue
        wmon2scb.get(wtr);
        if(!wtr.wreset && wtr.wen && !wtr.full) begin
          ref_queue.push_back(wtr.wdata);
          exp_full  = (ref_queue.size() == DEPTH);
          /*
          if (wtr.full   === exp_full) begin
            $display("[%0t]  SCB: {PASS} wreset=%0b wen=%0b wdata=%0h full=%0b", $time, wtr.wreset, wtr.wen, wtr.wdata, wtr.full);
            pass++;
          end
          else begin
            $display("[%0t]  SCB: {PASS} wreset=%0b wen=%0b wdata=%0h full=%0b | exp_full=%0b", $time, wtr.wreset, wtr.wen, wtr.wdata, wtr.full, exp_full);
            fail++;
          end
          */
/*
          $display("[%0t]  SCB:        wreset=%0b wen=%0b wdata=%0h full=%0b", $time, wtr.wreset, wtr.wen, wtr.wdata, wtr.full);
          $display("----------------------------------------------");
        end
      end
      
      forever begin		// Thread 2: check reads against reference queue
        rmon2scb.get(rtr);
        if(!rtr.rreset && rtr.rvalid) begin
          if(ref_queue.size() == 0) begin
            $display("[%0t]  SCB: {FAIL} ren seen but ref_queue is empty", $time);
            fail++;
          end
          else begin
            exp_rdata = ref_queue.pop_front();
            exp_empty = (ref_queue.size() == 0);
            if (rtr.rdata  === exp_rdata &&
         		rtr.empty  === exp_empty) begin
              $display("[%0t]  SCB: {PASS} rreset=%0b ren=%0b rdata=%0h empty=%0b rvalid=%0b", $time, rtr.rreset, rtr.ren, rtr.rdata, rtr.empty, rtr.rvalid);
              pass++;
            end
            else begin
              $display("[%0t]  SCB: {FAIL} rreset=%0b ren=%0b rdata=%0h empty=%0b rvalid=%0b | exp_data_out=%0h exp_empty=%0b", $time, rtr.rreset, rtr.ren, rtr.rdata, rtr.empty, rtr.rvalid, exp_rdata, exp_empty);
              fail++;
            end
          end
          wcount_mb.try_get(wcount);
          rcount_mb.try_get(rcount);
          $display("-----------------------Pass=%0d Fail=%0d wcount=%0d rcount=%0d---------------------", pass, fail, wcount, rcount);
          if(/*(pass + fail == wcount) &&*//* (pass + fail == rcount))
            -> done;
        end
      end
    join_none
  endtask
    
    
    /*
    forever begin
      wmon2scb.get(wtr);
      rmon2scb.get(rtr);
      
      // Update the model
      if(rtr.rreset) begin
        exp_rdata = 0;
      end
      else begin
        if (wtr.wen && !exp_full)
          ref_queue.push_back(wtr.wdata);
        if (rtr.ren && !exp_empty)
          exp_rdata = ref_queue.pop_front();
      end
      
      exp_full  = (ref_queue.size() == DEPTH);
      exp_empty = (ref_queue.size() == 0);
      
      
      // Compare
      if(rtr.rdata  === exp_rdata &&
         wtr.full   === exp_full &&
         rtr.empty  === exp_empty) begin
        $display("[%0t] SCB: {PASS} wreset=%0b wen=%0b wdata=%0h full=%0b rreset=%0b ren=%0b rdata=%0h empty=%0b rvalid=%0b", $time, wtr.wreset, wtr.wen, wtr.wdata, wtr.full, rtr.rreset, rtr.ren, rtr.rdata, rtr.empty, rtr.rvalid);
          pass++;
        end
        else begin
          $display("[%0t] SCB: {FAIL} wreset=%0b wen=%0b wdata=%0h full=%0b rreset=%0b ren=%0b rdata=%0h empty=%0b rvalid=%0b | exp_data_out=%0h exp_full=%0b exp_empty=%0b", $time, wtr.wreset, wtr.wen, wtr.wdata, wtr.full, rtr.rreset, rtr.ren, rtr.rdata, rtr.empty, rtr.rvalid, exp_rdata, exp_full, exp_empty);
          fail++;
        end
      
      $display("--------------------------------------------");
      if(pass+fail == (2*DEPTH + 10))
        -> done;
    end
  endtask
  */
  /*
  function void report();
    $display("\n==== REPORT ====");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
  endfunction
endclass
*/

class scoreboard;
  w_transaction wtr;
  r_transaction rtr;
  mailbox #(w_transaction) wmon2scb;
  mailbox #(r_transaction) rmon2scb;

  int pass, fail;
  int items_written;
  event wgen_done, rgen_done;   // signalled by generators
  event done;

  bit [DATA_WIDTH-1:0] ref_queue[$];
  bit [DATA_WIDTH-1:0] exp_rdata;
  bit exp_empty;

  function new(mailbox #(w_transaction) wmon2scb,
               mailbox #(r_transaction) rmon2scb);
    this.wmon2scb = wmon2scb;
    this.rmon2scb = rmon2scb;
  endfunction

  task run();
    fork

      // Thread 1 — collect writes
      forever begin
        wmon2scb.get(wtr);
        if (!wtr.wreset && wtr.wen && !wtr.full) begin
          ref_queue.push_back(wtr.wdata);
          items_written++;
          $display("[%0t]  SCB:        queued wdata=%0h (queue depth=%0d)",
                   $time, wtr.wdata, ref_queue.size());
        end
      end

      // Thread 2 — check reads
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
          $display("----------------------- Pass=%0d Fail=%0d ---------------------", pass, fail);
        end
      end

      // Thread 3 — termination: wait for generators done,
      // then wait until all written items have been read
      begin
        @(wgen_done);
        @(rgen_done);
        $display("[%0t]  SCB: generators done, waiting for drain...", $time);

        // Wait until scoreboard has processed all written items
        wait (pass + fail == items_written);
        #50;   // small drain window for any in-flight CDC transactions
        -> done;
      end

    join_none
  endtask

  function void report();
    $display("\n==== REPORT ====");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
    $display("================");
  endfunction
endclass
