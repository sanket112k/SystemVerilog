import tb_pkg::*;

class generator;
  
  transaction tr;
  mailbox #(transaction) gen2drv;
  
  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    repeat(2) begin			// reset
      tr = new();
      assert(tr.randomize() with {
        resetn == 1'b0;
      });
      gen2drv.put(tr);
      tr.display("GEN");
    end
    
    
    $display("==========================================");
  endtask
endclass
