interface dff_if(input logic clk);

  logic reset;
  logic d;
  logic q;

  clocking cb @(posedge clk);
    output d, reset;
    input q;
  endclocking

endinterface
