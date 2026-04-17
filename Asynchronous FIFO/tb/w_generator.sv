import tb_pkg::*;

class w_generator;
  
  w_transaction wtr;
  mailbox #(w_transaction) wgen2drv;
  bit wdone;
  
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
    /*
    repeat(2*DEPTH) begin
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    */
    repeat(10) begin 	// write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    repeat(10) begin 	// Don't write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    repeat(8) begin 	// Both write and read
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    begin 	// done
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    wdone = 1'b1;
  endtask
endclass
