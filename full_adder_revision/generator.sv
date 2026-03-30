class generator;

  transaction tr;
  mailbox #(transaction) gen2drv;

  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
    repeat (10) begin
      tr = new();       // 1st creates a new object in every single iteration
      tr.randomize();   // 2nd randomize
      gen2drv.put(tr);  // 3rd send data
    end
  endtask
endclass
