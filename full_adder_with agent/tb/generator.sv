class generator;

  transaction tr;
  mailbox #(transaction) gen2drv;

  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
    repeat(10) begin
      tr = new();
      tr.randomize();
      gen2drv.put(tr);
    end
  endtask

endclass
