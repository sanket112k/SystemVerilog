import tb_pkg::*;

class w_generator;
  
  w_transaction wtr;
  mailbox #(w_transaction) wgen2drv;
  mailbox wcount_mb;
  
  function new(mailbox #(w_transaction) wgen2drv);
    this.wgen2drv = wgen2drv;
  endfunction
  
  
  task run();
    
    repeat(2) begin			// reset
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    repeat (DEPTH+20) begin 	// write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    repeat(5) begin 	// write few more times after full
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    repeat(DEPTH+30) begin 	// Don't write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    repeat(8) begin 		// Both write and read
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    begin 					// Stop write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b0;
        wdata  == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
  endtask
endclass
