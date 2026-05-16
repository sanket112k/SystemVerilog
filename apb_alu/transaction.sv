class apb_transaction;
  bit 		   pwrite;
  bit [AW-1:0] paddr;
  bit [DW-1:0] pwdata;
  bit [DW-1:0] prdata;
  bit 		   pslverr;
  
  function void copy(trasaction tr);
    paddr   = tr.paddr  ;
    pwrite  = tr.pwrite ;
    pwdata  = tr.pwdata ;
    prdata  = tr.prdata ;
    pslverr = tr.pslverr;
  endfunction
  
endclass

class alu_in_transaction;
  bit [DW-1:0] op_a  ;
  bit [DW-1:0] op_b  ;
  bit [3:0]    opcode;
  
  function new(bit [DW-1:0] op_a, bit [DW-1:0] op_b, bit [3:0]    opcode);
    this.op_a   = op_a  ;
    this.op_b   = op_b  ;
    this.opcode = opcode;
  endfunction
  
  function void copy(alu_in_transaction tr);
    op_a   = tr.op_a  ;
    op_b   = tr.op_b  ;
    opcode = tr.opcode;
  endfunction
endclass

class alu_out_transaction;
  bit [DW-1:0] result;
  bit [3:0]    flags;
  bit          opc_illegal;
  
  function new();
    result      = 0;
    flags       = 0;
    err_illegal = 0;
  endfunction
  
  function void copy(alu_out_transaction tr);
    result      = tr.result     ;
    flags       = tr.flags      ;
    err_illegal = tr.err_illegal;
  endfunction
endclass
