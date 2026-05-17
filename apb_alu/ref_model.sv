class ref_model;
  localparam integer MSB = DW-1;
  
  function void ref_alu(
    input  bit [DW-1:0] a,
    input  bit [DW-1:0] b,
    input  bit [3:0]    op,
    output bit [DW-1:0] y,
    output bit [3:0]    flags,
    output bit          illegal
  );
  
    bit  [4:0] shamt = b[4:0];
    bit        cflag, vflag;
    bit [DW:0] sum_ext;
    bit [DW:0] sub_ext;
  
    y       = {DW{1'b0}};
    flags   = 4'b0000;
    illegal = 1'b0;
    cflag   = 1'b0;
    vflag   = 1'b0;

    sum_ext = {1'b0,a} + {1'b0,b};
    sub_ext = {1'b0,a} - {1'b0,b};

    case (op)
      `ALU_OP_ADD: begin
        y     = sum_ext[DW-1:0];
        cflag = sum_ext[DW];
        vflag = (~(a[MSB]^b[MSB])) & (y[MSB]^a[MSB]);
      end

      `ALU_OP_SUB: begin
        y     = sub_ext[DW-1:0];
        cflag = (a >= b);
        vflag = ((a[MSB]^b[MSB])) & (y[MSB]^a[MSB]);
      end

      `ALU_OP_AND: y = a & b;
      `ALU_OP_OR : y = a | b;
      `ALU_OP_XOR: y = a ^ b;

      `ALU_OP_SLL: y = a << shamt;
      `ALU_OP_SRL: y = a >> shamt;
      `ALU_OP_SRA: y = $signed(a) >>> shamt;

      `ALU_OP_SLT : y = ($signed(a) < $signed(b)) ? {{(DW-1){1'b0}},1'b1} : {DW{1'b0}};
      `ALU_OP_SLTU: y = (a < b) ? {{(DW-1){1'b0}},1'b1} : {DW{1'b0}};

      default: begin
        y       = {DW{1'b0}};
        illegal = 1'b1;
      end
    endcase

    flags[`ALU_FLAG_Z] = (y == {DW{1'b0}});
    flags[`ALU_FLAG_N] = y[MSB];
    flags[`ALU_FLAG_C] = cflag;
    flags[`ALU_FLAG_V] = vflag;
  endfunction
endclass
