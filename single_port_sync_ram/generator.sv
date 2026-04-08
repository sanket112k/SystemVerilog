class generator;
  mailbox #(transaction) gen2drv;
  int iterations;
  event done;
  
  function new(mailbox #(transaction) gen2drv, int iterations);
    this.gen2drv = gen2drv;
    this.iterations = iterations;
  endfunction
  
  task run();
    transaction tr = new();
    transaction tr_copy;
    
    repeat (iterations) begin
      assert(tr.randomize() with {we == 1;});
      tr_copy = new tr;
      tr_copy.display("GEN");
      gen2drv.put(tr_copy);
    end
    
    repeat (iterations) begin
      assert(tr.randomize() with {we == 0;});
      tr_copy = new tr;
      tr_copy.display("GEN");
      gen2drv.put(tr_copy);
    end
    
    ->done;
  endtask
endclass
