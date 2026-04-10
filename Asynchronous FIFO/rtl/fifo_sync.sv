// 2 flip-flop syncronizer
module fifo_sync #(
  parameter ADDR_WIDTH = 4
)(
  input  logic                  xclk,
  input  logic                  xreset,
  input  logic [ADDR_WIDTH : 0] ptr_in,		// extra bit to detect wrap around
  output logic [ADDR_WIDTH : 0] ptr_out
);
  logic [ADDR_WIDTH : 0] ptr_mid;
  
  always_ff @(posedge xclk) begin
    if (xreset) begin
      ptr_mid <= 0;
      ptr_out <= 0;
    end
    else begin
      ptr_mid <= ptr_in;
      ptr_out <= ptr_mid;
    end
  end
endmodule
