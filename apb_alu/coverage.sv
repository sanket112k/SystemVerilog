//`include "tb_pkg.sv"

class coverage;
  mailbox drv2cov;
  int sample_count = 0;
  
  bit [3:0]    opcode_cp;
  bit [DW-1:0] op_a_cp;
  bit [DW-1:0] op_b_cp;
  bit [3:0]    flags_cp;
  bit [4:0]    shamt_cp;
  
  covergroup cg_alu_in;
    op_a   : coverpoint op_a_cp;
    op_b   : coverpoint op_b_cp;
    opcode : coverpoint opcode_cp {
      bins legal[] = {[0:9]};
      bins illegal = {[10:15]};
    }
  endgroup
  
  covergroup cg_flags;
    z : coverpoint flags_cp[0];
    n : coverpoint flags_cp[1];
    c : coverpoint flags_cp[2];
    v : coverpoint flags_cp[3];
  endgroup
  
  covergroup cg_overflow;
    overflow_add : coverpoint (opcode_cp == 0 && flags_cp[3]);
    overflow_sub : coverpoint (opcode_cp == 1 && flags_cp[3]);
  endgroup
  
  covergroup cg_shift;
    shamt0  : coverpoint shamt_cp { bins zero = {0}; }
    shamt31 : coverpoint shamt_cp { bins max  = {31}; }
  endgroup
  
  function new(mailbox drv2cov);
    this.drv2cov = drv2cov;
    cg_alu_in   = new();
    cg_flags    = new();
    cg_overflow = new();
    cg_shift    = new();
  endfunction
  
  task run();
    alu_in_transaction in_tr;
    alu_out_transaction out_tr;
    forever begin
      drv2cov.get(in_tr);
      drv2cov.get(out_tr);
      
      opcode_cp = in_tr.opcode;
      op_a_cp   = in_tr.op_a;
      op_b_cp   = in_tr.op_b;
      flags_cp  = out_tr.flags;
      shamt_cp  = in_tr.op_b[4:0];
      /*
      $display("[COV] Sampling opcode=%0h", in_tr.opcode);
      $display("[COV] Sampling op_a  =%0h", in_tr.op_a);
      $display("[COV] Sampling op_b  =%0h", in_tr.op_b);
      $display("[COV] Sampling flags =%0h", out_tr.flags);
      $display("[COV] Sampling shamt =%0h", in_tr.op_b);
      */
      sample_count++;
      cg_alu_in.sample();
      cg_flags.sample();
      cg_overflow.sample();
      cg_shift.sample();
    end
  endtask
  
  function void report();
    $display("[COV] Samples=%0d", sample_count);
    $display("[COV] ALU in:    coverage = %0f%%", cg_alu_in.get_inst_coverage());
    $display("[COV] Flags:     coverage = %0f%%", cg_flags.get_inst_coverage());
    $display("[COV] Overflow:  coverage = %0f%%", cg_overflow.get_inst_coverage());
    $display("[COV] Shift:     coverage = %0f%%", cg_shift.get_inst_coverage());
  endfunction
endclass
