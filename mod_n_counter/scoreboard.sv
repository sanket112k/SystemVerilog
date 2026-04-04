class scoreboard;
  int iterations;
  event done;
  
  mailbox #(transaction) mon2scb;
  int pass, fail;
  
  function new(mailbox #(transaction) mon2scb, int iterations);
    this.mon2scb = mon2scb;
    this.iterations = iterations;
  endfunction
  
  task run();
    transaction tr;
    bit [$clog2(N)-1 : 0] expected_count;
    
    forever begin
      mon2scb.get(tr);
      if(tr.reset || expected_count == N-1)
        expected_count = 0;
      else
        expected_count++;
      
      if(tr.count === expected_count) begin
        pass++;
        $display("[PASS] count=%0d reset=%0b", tr.count, tr.reset);
      end else begin
        fail++;
        $display("[FAIL] count=%0d reset=%0b expected_count=%0d", tr.count, tr.reset, expected_count);
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
