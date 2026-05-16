class generator;
  mailbox gen2drv;
  int num_items = 100;
  int seed      = 1;
  bit directed  = 0;	// 0 = random; 1 = smoke
  int quota     = 20;
  rand bit [DW-1:0] op_a;
  rand bit [DW-1:0] op_b;
  rand bit [3:0]    opcode;
  
  constraint c_opcode_legal{
    opcode inside {[0:9]};
  }
  
  constraint c_opcode_weighted{
    opcode inside {4'h0:=25,
                   4'h1:=25
                   [4'h2:4'h4]:=10,
                   [4'h5:4'h7]:=15,
                   [4'h8:4'h9]:=10};
  }
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    
  endtask
  
endclass



/*
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
*/
