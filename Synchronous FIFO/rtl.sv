module synchronous_fifo #(
  parameter DEPTH = 8,
  parameter DATA_WIDTH = 16,
  localparam ADDR_WIDTH = $clog2(DEPTH)
)(
  input  logic clk,
  input  logic resetn,
  input  logic w_en,
  input  logic r_en,
  input  logic [DATA_WIDTH-1 : 0] data_in,
  output logic [DATA_WIDTH-1 : 0] data_out,
  output logic full,
  output logic empty
);
  logic [DATA_WIDTH-1 : 0] mem [0 : DEPTH-1];
  logic [ADDR_WIDTH : 0] w_ptr;		// one extra MSB bit to detect wrap around
  logic [ADDR_WIDTH : 0] r_ptr;
  
  always_ff @(posedge clk) begin:write_logic
    if (!resetn)
      w_ptr <= 0;
    else if (w_en && !full) begin
      mem [w_ptr[ADDR_WIDTH-1 : 0]] <= data_in;
      w_ptr <= w_ptr + 1;
    end
  end
  
  always_ff @(posedge clk) begin:read_logic
    if (!resetn) begin
      r_ptr    <= 0;
      data_out <= 0;
    end
    else if (r_en && !empty) begin
      data_out <= mem[r_ptr[ADDR_WIDTH-1 : 0]];
      r_ptr <= r_ptr + 1;
    end
  end
  
  assign empty = (w_ptr == r_ptr);
  assign full  = (w_ptr[ADDR_WIDTH]     != r_ptr[ADDR_WIDTH]) &&
                 (w_ptr[ADDR_WIDTH-1:0] == r_ptr[ADDR_WIDTH-1:0]);
endmodule
