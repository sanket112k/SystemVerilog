module mod_n_counter #(
  parameter N = 4
)(
  input  logic clk,
  input  logic reset,   // active high async reset
  output logic [$clog2(N)-1:0] count
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset || count == N-1)
      count <= 0;
    else
      count++;
  end
endmodule
