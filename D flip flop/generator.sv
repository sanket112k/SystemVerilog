class generator;

  mailbox #(transaction) gen2drv;
  int count;
  event done;

  function new(mailbox #(transaction) gen2drv, int count);
    this.gen2drv = gen2drv;
    this.count   = count;
  endfunction

  task run();
    transaction tr;
    repeat (count) begin
      tr = new();
      assert(tr.randomize());
      gen2drv.put(tr);
    end
    ->done;
  endtask

endclass
