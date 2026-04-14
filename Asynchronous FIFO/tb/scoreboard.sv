//`include "tb_pkg.sv"
import tb_pkg::*;

class scoreboard;
  
  w_transaction wtr;
  r_transaction rtr;
  mailbox #(w_transaction) wmon2scb;
  mailbox #(r_transaction) rmon2scb;
  int pass, fail;
  event done;
    
  bit [DATA_WIDTH-1 : 0] ref_queue [$];
  
  bit [DATA_WIDTH-1 : 0] exp_rdata;
  bit exp_full;
  bit exp_empty;
  
  function new(mailbox #(w_transaction) wmon2scb, mailbox #(r_transaction) rmon2scb);
    this. wmon2scb = wmon2scb;
    this. rmon2scb = rmon2scb;
  endfunction
  
  task run();
    fork
      forever begin		// Thread 1: collect all writes into reference queue
        wmon2scb.get(wtr);
        if(!wtr.wreset && wtr.wen && !wtr.full)
          ref_queue.push_back(wtr.wdata);
      end
      
      forever begin		// Thread 2: check reads against reference queue
        rmon2scb.get(rtr);
        if(!rtr.rreset && rtr.rvalid) begin
          if(ref_queue.size() == 0) begin
            $display("[SCB] FAIL: rvalid seen but ref_queue is empty");
            fail++;
          end
          else begin
            exp_rdata = ref_queue.pop_front();
            if (rtr.rdata === exp_rdata) begin
              $display("[%0t] SCB: {PASS} wreset=%0b wen=%0b wdata=%0h full=%0b rreset=%0b ren=%0b rdata=%0h empty=%0b rvalid=%0b", $time, wtr.wreset, wtr.wen, wtr.wdata, wtr.full, rtr.rreset, rtr.ren, rtr.rdata, rtr.empty, rtr.rvalid);
              pass++;
            end
            else begin
              $display("[%0t] SCB: {FAIL} wreset=%0b wen=%0b wdata=%0h full=%0b rreset=%0b ren=%0b rdata=%0h empty=%0b rvalid=%0b | exp_data_out=%0h exp_full=%0b exp_empty=%0b", $time, wtr.wreset, wtr.wen, wtr.wdata, wtr.full, rtr.rreset, rtr.ren, rtr.rdata, rtr.empty, rtr.rvalid, exp_rdata, exp_full, exp_empty);
              fail++;
            end
          end
          $display("--------------------------------------------");
          if(pass + fail == (2*DEPTH + 10))
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
  
  function void report();
    $display("\n==== REPORT ====");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
  endfunction
endclass
