class generator;

  transaction tr;
  mailbox #(transaction) gen2drv;
  int num_trans;
  event scb_done;

  function new(mailbox #(transaction) gen2drv, int num_trans, event scb_done);
    this.gen2drv   = gen2drv;
    this.num_trans = num_trans;
    this.scb_done  = scb_done;
  endfunction

  task run();
    repeat(num_trans) begin
      tr = new();
      tr.randomize();
      gen2drv.put(tr);
      
      tr.display("GEN");
      @(scb_done);
    end
  endtask
endclass
