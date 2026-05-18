class i2c_generator;
  mailbox #(i2c_transaction) gen2drv;
  event   gen_done;
  int     num_transactions;

  function new(mailbox #(i2c_transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task run();
    repeat (num_transactions) begin
      i2c_transaction i2c_tr = new();
      assert (!i2c_tr.randomize())
        $error("I2C transaction randomization failed");
      gen2drv.put(i2c_tr);
      @(gen_done);
    end
  endtask
endclass
