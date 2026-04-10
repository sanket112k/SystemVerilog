class scoreboard;
  
  transaction tr;
  mailbox #(transaction) mon2scb;
  int pass, fail;
  event done;
    
  bit [DATA_WIDTH-1 : 0] ref_queue [$];
  
  bit [DATA_WIDTH-1 : 0] exp_data_out;
  bit exp_full;
  bit exp_empty;
  
  function new(mailbox #(transaction) mon2scb);
    this. mon2scb = mon2scb;
  endfunction
  
  task run();
    forever begin
      mon2scb.get(tr);
      
      // Update the model
      if(!tr.resetn) begin
        exp_data_out = 0;
      end
      else begin
        if (tr.w_en && !exp_full)
          ref_queue.push_back(tr.data_in);
        if (tr.r_en && !exp_empty)
          exp_data_out = ref_queue.pop_front();
      end
      
      exp_full = (ref_queue.size() == DEPTH);
      exp_empty = (ref_queue.size() == 0);
      
      
      // Compare
        if(tr.data_out === exp_data_out &&
           tr.full     === exp_full &&
           tr.empty    === exp_empty) begin
          $display("[%0t] SCB: {PASS} resetn=%0b w_en=%0b r_en=%0b data_in=%0h data_out=%0h full=%0b empty=%0b", $time, tr.resetn, tr.w_en, tr.r_en, tr.data_in, tr.data_out, tr.full, tr.empty);
          pass++;
        end
        else begin
          $display("[%0t] SCB: {FAIL} resetn=%0b w_en=%0b r_en=%0b data_in=%0h data_out=%0h full=%0b empty=%0b | exp_data_out=%0h exp_full=%0b exp_empty=%0b", $time, tr.resetn, tr.w_en, tr.r_en, tr.data_in, tr.data_out, tr.full, tr.empty, exp_data_out, exp_full, exp_empty);
          fail++;
        end
      
      $display("--------------------------------------------");
      if(pass+fail == (2*DEPTH + 10))
        -> done;
    end
  endtask
  
  function void report();
    $display("\n==== REPORT ====");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
  endfunction
endclass
