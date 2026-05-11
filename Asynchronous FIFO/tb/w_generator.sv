import tb_pkg::*;

class w_generator;
  
  w_transaction wtr;
  mailbox #(w_transaction) wgen2drv;
  mailbox wcount_mb;
  event gen_done;
  
  function new(mailbox #(w_transaction) wgen2drv, ref event done);
    this.wgen2drv = wgen2drv;
    this.gen_done = done;
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
    
    repeat(DEPTH) begin 	// write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      //wcount++;
      wtr.display("WGEN");
    end
    
    repeat(DEPTH) begin 	// Don't write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      //wcount++;
      wtr.display("WGEN");
    end
    
    repeat(8) begin 		// Both write and read
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b1;
      });
      wgen2drv.put(wtr.clone());
      //wcount++;
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
    
    -> gen_done;
    //$display("[%0t] WGEN:        wcount=%0d", $time, wcount);
  endtask
  
  
  
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
    
    repeat(10) begin	// randomized read and write
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      //wcount++;
      wtr.display("WGEN");
    end
    
     begin				// Done
      wtr = new();
      assert(wtr.randomize() with {
        wreset == 1'b0;
        wen    == 1'b0;
        wdata  == 1'b0;
      });
      wgen2drv.put(wtr.clone());
      //wcount++;
      wtr.display("WGEN");
    end
       
    -> gen_done;
    //$display("[%0t] WGEN:        wcount=%0d", $time, wcount);
  endtask
  */
endclass
