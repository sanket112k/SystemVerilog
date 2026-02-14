`include "tb.sv
module tb_top;
  wire [7:0] addr;
  design_example dut(addr);
  testbench test(addr);
endmodule

// Output: Addr = 10
