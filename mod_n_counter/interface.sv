//`include "tb_pkg.sv"
import tb_pkg::*;

interface count_if(input logic clk);
  logic reset;
  logic [$clog2(N)-1 : 0] count;
  
  clocking cb @(posedge clk);
    default input #1step output #0;
    input count;
    output reset;
  endclocking
endinterface
