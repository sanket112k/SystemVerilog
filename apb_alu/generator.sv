import tb_pkg::*;

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
    opcode dist {4'h0:=25,
                 4'h1:=25,
                 [4'h2:4'h4]:=10,
                 [4'h5:4'h7]:=15,
                 [4'h8:4'h9]:=10};
  }
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    alu_in_transaction tr;
    //int i, q;
    $display("[GEN] Starting: num_items=%0d seed=%0d directed=%0d", num_items, seed, directed);
    if (gen2drv == null) begin
      $error("[GEN] gen2drv mailbox is null");
      return;
    end
    if (directed)
      run_directed(tr);
    else
      run_random(tr);
    $display("[GEN] Done. Generated %0d commands.", num_items);
  endtask
  
  task run_directed(alu_in_transaction tr);
    // Smoke-style: per-op sanity + overflow, borrow, illegal
    push_cmd(32'h1, 32'h2, 4'h0);                   // ADD
    push_cmd(32'h2, 32'h1, 4'h1);                   // SUB
    push_cmd(32'hFFFF_0000, 32'h0F0F_F0F0, 4'h2);	// AND
    push_cmd(32'h8000_0000, 32'h1, 4'h7);           // SRA
    push_cmd(32'h7FFF_FFFF, 32'h1, 4'h0);           // ADD overflow
    push_cmd(32'h0, 32'h1, 4'h1);                   // SUB borrow
    push_cmd(32'hFFFF_FFFF, 32'h1, 4'h8);           // SLT
    push_cmd(32'hFFFF_FFFF, 32'h1, 4'h9);           // SLTU
    push_cmd(32'h1234, 32'h5678, 4'hF);             // illegal
    num_items = 9;
  endtask
  
  task push_cmd(bit [DW-1:0] op_a, bit [DW-1:0] op_b, bit [3:0] opcode);
    alu_in_transaction tr = new(op_a, op_b, opcode);
    gen2drv.put(tr);
  endtask
  
  task run_random(alu_in_transaction tr);
    srandom(seed);
    for (int q = 0; q < quota; q++) begin
      for (int op = 0; op <= 9; op++) begin
        tr = new();
        tr.op_a   = $urandom();
        tr.op_b   = $urandom();
        tr.opcode = op[3:0];
        gen2drv.put(tr);
      end
    end
    for (int i = 0; i < num_items; i++) begin
      void'(randomize());
      tr.op_a = op_a;
      tr.op_b = op_b;
      tr.opcode = ($urandom_range(100) < 10) ? $urandom_range(15, 10) : opcode;
      gen2drv.put(tr);
    end
  endtask
endclass
