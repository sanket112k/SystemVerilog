module dff_async_reset(
  input logic clk,
  input logic reset,	//Active-low reset
  input logic data,
  output logic q
);
  always @(posedge clk or negedge reset) begin
    if(~reset) q <= 0;
  else q <= data;
end
endmodule
