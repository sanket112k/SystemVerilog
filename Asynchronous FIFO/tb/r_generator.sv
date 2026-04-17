import tb_pkg::*;

class r_generator;
  
  r_transaction rtr;
  mailbox #(r_transaction) rgen2drv;
  bit rdone;
  
  function new(mailbox #(r_transaction) rgen2drv);
    this.rgen2drv = rgen2drv;
  endfunction
  
  task run();
    repeat(2) begin			// reset
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b1;
        rdone  == 1'b0;
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
      rtr.display("RGEN");
    end
    
    repeat(10) begin 	// read
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b0;
        ren    == 1'b1;
      });
      rgen2drv.put(rtr.clone());
      rtr.display("RGEN");
    end
    
    repeat(8) begin 		// Both write and read
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b0;
        ren    == 1'b1;
      });
      rgen2drv.put(rtr.clone());
      rtr.display("RGEN");
    end
    
    begin 		// Both write and read
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b0;
        ren    == 1'b1;
      });
      rgen2drv.put(rtr.clone());
      rtr.display("RGEN");
    end
    
    rdone = 1'b1;
  endtask
endclass
