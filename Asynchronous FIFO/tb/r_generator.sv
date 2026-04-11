import tb_pkg::*;

class r_generator;
  
  r_transaction rtr;
  mailbox #(r_transaction) rgen2drv;
  
  function new(mailbox #(r_transaction) rgen2drv);
    this.rgen2drv = rgen2drv;
  endfunction
  
  task run();
    repeat(2) begin			// reset
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b1;
      });
      rgen2drv.put(rtr);
      rtr.display("WGEN");
    end
    
    repeat(DEPTH) begin 	// write
      rtr = new();
      assert(rtr.randomize() with {
        rreset == 1'b0;
        ren == 1'b1;
      });
      rgen2drv.put(rtr);
      rtr.display("RGEN");
    end
    
  endtask
endclass
