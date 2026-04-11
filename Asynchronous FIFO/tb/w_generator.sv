import tb_pkg::*;

class w_generator;
  
  w_transaction wtr;
  mailbox #(w_transaction) wgen2drv;
  
  function new(mailbox #(w_transaction) wgen2drv);
    this.wgen2drv = wgen2drv;
  endfunction
  
  task run();
    repeat(2) begin			// reset
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b1;
      });
      wgen2drv.put(wtr);
      wtr.display("WGEN");
    end
    
    repeat(DEPTH) begin 	// write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr);
      wtr.display("WGEN");
    end
    
  endtask
endclass
