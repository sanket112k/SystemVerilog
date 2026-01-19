class generator;
  int num_transactions = 10;
  
  mailbox #(transaction) gen2drv;
  
  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    transaction tr;
    repeat (num_transactions) begin
      tr = new();
      
      if (!tr.randomize() with {
        reset dist {1'b1 := 80, 1'b0:= 20};
      }) $fatal(1, "Randomization failed!");
      
      gen2drv.put(tr);
      
      #1;
    end
  endtask
endclass
