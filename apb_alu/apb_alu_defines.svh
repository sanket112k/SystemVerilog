`ifndef APB_ALU_DEFINES_SVH
`define APB_ALU_DEFINES_SVH

// APB register
`define A_CTRL     8'h00
`define A_STATUS   8'h04
`define A_OPA      8'h08
`define A_OPB      8'h0C
`define A_OPCODE   8'h10
`define A_RESULT   8'h14
`define A_FLAGS    8'h18

// STATUS
`define STATUS_BUSY   0
`define STATUS_DONE   1
`define STATUS_ERR    2

// CTRL start bit
`define CTRL_START  0
// W1C clear done: write 1 to STATUS bit 1
`define W1C_DONE    32'h02

// ALU Opcodes
`define ALU_OP_ADD    4'h0
`define ALU_OP_SUB    4'h1
`define ALU_OP_AND    4'h2
`define ALU_OP_OR     4'h3
`define ALU_OP_XOR    4'h4
`define ALU_OP_SLL    4'h5
`define ALU_OP_SRL    4'h6
`define ALU_OP_SRA    4'h7
`define ALU_OP_SLT    4'h8
`define ALU_OP_SLTU   4'h9

// Flags bit positions
`define ALU_FLAG_Z    0
`define ALU_FLAG_N    1
`define ALU_FLAG_C    2
`define ALU_FLAG_V    3

`endif
