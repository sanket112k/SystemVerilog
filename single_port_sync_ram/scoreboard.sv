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
        if (model_mem[tr.addr] !== tr.rdata) begin
          fail++;
          $display("[SCB] {FAIL=%0d} addr=%0d Expected=%0h Got=%0h", fail, tr.addr, model_mem[tr.addr], tr.rdata);
        end
        else begin
          pass++;
          $display("[SCB] {PASS=%0d} addr=%0d rdata=%0h", pass, tr.addr, tr.rdata);
        end
      end
      if ((pass + fail) == iterations)
        ->done;
      $display("----------------------------------------------------");
    end
  endtask
  
  function void report();
    $display("\n==== REPORT ====");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
  endfunction
    
endclass
