class generator;
  
  mailbox #(transaction) gen2drv;
  int iterations;
  event done;
  
  function new(mailbox #(transaction) gen2drv, iterations);
    this.gen2drv = gen2drv;
    this.iterations = iterations;
  endfunction
  
  task run();
    transaction tr;
    repeat(iteration) begin
      tr.randonmize();
      gen2drv.put(tr);
    end
    -> done;
  endtask
endclass
