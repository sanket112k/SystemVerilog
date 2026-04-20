import tb_pkg::*;

class r_generator;
  
  r_transaction rtr;
  mailbox #(r_transaction) rgen2drv;
  mailbox rcount_mb;
  int rcount;
  
  function new(mailbox #(r_transaction) rgen2drv, mailbox rcount_mb);
    this.rgen2drv = rgen2drv;
    this.rcount_mb = rcount_mb;
  endfunction
  
  ///*
  task run();
    repeat(2) begin			// reset
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b1;
      });
      rgen2drv.put(rtr.clone());
      rtr.display("RGEN");
    end
    
    repeat(10) begin 	// Don't read
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b0;
        ren    == 1'b0;
      });
      rgen2drv.put(rtr.clone());
      rcount++;
      rtr.display("RGEN");
    end
    
    repeat(10) begin 	// read
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b0;
        ren    == 1'b1;
      });
      rgen2drv.put(rtr.clone());
      rcount++;
      rtr.display("RGEN");
    end
    
    repeat(8) begin 		// Both write and read
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b0;
        ren    == 1'b1;
      });
      rgen2drv.put(rtr.clone());
      rcount++;
      rtr.display("RGEN");
    end
       
    rcount_mb.put(rcount);
    $display("[%0t] RGEN:        rcount=%0d", $time, rcount);
  endtask
  //*/
  
  /*
  task run();
    repeat(2) begin			// reset
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b1;
      });
      rgen2drv.put(rtr.clone());
      rtr.display("RGEN");
    end
    
    repeat(2*DEPTH) begin 	// randomized read and write
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b0;
      });
      rgen2drv.put(rtr.clone());
      rcount++;
      rtr.display("RGEN");
    end
       
    rcount_mb.put(rcount);
    $display("[%0t] RGEN:        rcount=%0d", $time, rcount);
  endtask
  */
endclass
