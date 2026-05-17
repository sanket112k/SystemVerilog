`include "apb_alu_defines.svh"
`include "ref_model.sv"
//`include "tb_pkg.sv"

//import tb_pkg::*;

class scoreboard;
  mailbox drv2scb;
  mailbox mon2scb;
  ref_model refm;
  int       alu_checks = 0;
  int       apb_checks = 0;
  int       alu_errors = 0;
  int       apb_errors = 0;
  int       expected_alu_checks = 0;
  event     all_done;
  
  function new(mailbox drv2scb, mailbox mon2scb);
    this.drv2scb = drv2scb;
    this.mon2scb = mon2scb;
    refm         = new();
  endfunction
  
  
  task run_alu_check();
    alu_in_transaction  in_tr;
    alu_out_transaction out_tr;
    bit          exp_illegal;
    bit [3:0]    exp_flags;
    bit [DW-1:0] exp_y;
    
    forever begin
      drv2scb.get(in_tr);
      drv2scb.get(out_tr);
      refm.ref_alu(.a(in_tr.op_a), .b(in_tr.op_b), .op(in_tr.opcode), .illegal(exp_illegal), .flags(exp_flags), .y(exp_y));
      alu_checks++;
      $display("[SCB] {PASS} @%0t ALU CHECK #%0d: A=%h B=%h OP=%h | EXP: Y=%h F=%b IL=%b | GOT: Y=%h F=%b IL=%b", $time, alu_checks, in_tr.op_a, in_tr.op_b, in_tr.opcode, exp_y, exp_flags, exp_illegal, out_tr.y, out_tr.flags, out_tr.opc_illegal);
      if (out_tr.y != exp_y || out_tr.flags != exp_flags || out_tr.opc_illegal != exp_illegal) begin
        alu_errors++;
        $error("[SCB] {FAIL} @%0t ALU mismatch: A=%h B=%h OP=%h | EXP: Y=%h F=%b IL=%b | GOT: Y=%h F=%b IL=%b", $time, in_tr.op_a, in_tr.op_b, in_tr.opcode, exp_y, exp_flags, exp_illegal, out_tr.y, out_tr.flags, out_tr.opc_illegal);
      end
      if (expected_alu_checks > 0 && alu_checks >= expected_alu_checks)
        -> all_done;
    end
  endtask
  
  
  task run_apb_check();
    apb_transaction tr;
    bit is_legal_addr;
    
    forever begin
      mon2scb.get(tr);
      is_legal_addr = (tr.paddr == `A_CTRL) || (tr.paddr == `A_STATUS) || (tr.paddr == `A_OPA) || (tr.paddr == `A_OPB) || (tr.paddr == `A_OPCODE) || (tr.paddr == `A_RESULT) || (tr.paddr == `A_FLAGS);
      apb_checks++;
      if (!is_legal_addr && !tr.pslverr) begin
        apb_errors++;
        $error("[SCB] APB: illegal addr %h should assert PSLVERR; slverr=%b", tr.paddr, tr.pslverr);
      end
    end
  endtask
  
  
  task run();
    fork
    run_alu_check();
    run_apb_check();
    join
  endtask
  
  
  function void report();
    $display("[SCB] ALU checks=%0d errors=%0d", alu_checks, alu_errors);
    $display("[SCB] APB checks=%0d errors=%0d", apb_checks, apb_errors);
    if (alu_errors > 0 || apb_errors > 0)
      $error("[SCB] FAIL");
    else
      $display("[SCB] PASS");
  endfunction
endclass
