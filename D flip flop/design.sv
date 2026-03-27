module dff (
  input  logic clk,
  input  logic reset,   // active high async reset
  input  logic d,
  output logic q
);

  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      q <= 0;
    else
      q <= d;
  end

endmodule
