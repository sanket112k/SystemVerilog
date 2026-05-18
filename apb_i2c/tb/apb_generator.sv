class apb_generator;
  mailbox #(apb_transaction) gen2drv;
  event gen_done;
  int   num_transactions;
  bit   randomize_data = 1;
  
  function new(mailbox #(apb_transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    repeat (num_transactions) begin
      apb_transaction apb_tr = new();
      assert (!apb_tr.randomize())
        $error("APB transaction randonization failed");
      gen2drv.put(apb_tr);
      @(gen_done);
    end
  endtask
endclass
