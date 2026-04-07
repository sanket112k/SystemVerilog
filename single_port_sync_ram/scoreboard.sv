class scoreboard;
  int iterations;
  event done;
  mailbox #(transaction) mon2scb;
  int pass, fail;
  
  bit [DATA_WIDTH-1 : 0] model_mem [DEPTH];
  
  function new(mailbox #(transaction) mon2scb, int iterations);
    this.mon2scb = mon2scb;
    this.iterations = iterations;
  endfunction
  
  task run();
    transaction tr;
    
    forever begin
      mon2scb.get(tr);
      tr.display("SCB");
      
      if(tr.we)
        model_mem[tr.addr] = tr.data;
      else begin
        if (model_mem[tr.addr] !== tr.data) begin
          $display("[FAIL] Addr=%0d Expected=%0h Got=%0h", tr.addr, model_mem[tr.addr], tr.rdata);
          pass++;
        end
        else begin
          $display("[PASS] Addr=%0d Data=%0h", tr.addr, tr.rdata);
          fail++;
        end
      end
      if ((pass + fail) == iterations)
        ->done;
    end
  endtask
  
  function void report();
    $display("\n==== REPORT ====");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
  endfunction
    
endclass
