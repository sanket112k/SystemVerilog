import tb_pkg::*;

class w_generator;
  
  w_transaction wtr;
  mailbox #(w_transaction) wgen2drv;
  mailbox wcount_mb;
  int wcount;
  
  function new(mailbox #(w_transaction) wgen2drv, mailbox wcount_mb);
    this.wgen2drv = wgen2drv;
    this.wcount_mb = wcount_mb;
  endfunction
  
  ///*
  task run();
    repeat(2) begin			// reset
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    repeat(10) begin 	// write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wcount++;
      wtr.display("WGEN");
    end
    
    repeat(10) begin 	// Don't write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      wcount++;
      wtr.display("WGEN");
    end
    
    repeat(8) begin 	// Both write and read
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wcount++;
      wtr.display("WGEN");
    end
    
    begin 	// Stop write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    wcount_mb.put(wcount);
    $display("[%0t] WGEN:        wcount=%0d", $time, wcount);
  endtask
  //*/
  
  
  /*
  task run();
    repeat(2) begin			// reset
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      wtr.display("WGEN");
    end
    
    repeat(2*DEPTH) begin	// randomized read and write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      wcount++;
      wtr.display("WGEN");
    end
       
    wcount_mb.put(wcount);
    $display("[%0t] WGEN:        wcount=%0d", $time, wcount);
  endtask
  */
endclass
