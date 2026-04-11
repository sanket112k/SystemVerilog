// FIFO memory buffer
module fifo_mem #(
  parameter DEPTH = 8,
  parameter DATA_WIDTH = 16,
  localparam ADDR_WIDTH = $clog2(DEPTH)
)(
  input  logic                    wclk,
  input  logic                    wen,
  input  logic [ADDR_WIDTH-1 : 0] waddr,
  input  logic [DATA_WIDTH-1 : 0] wdata,
  
  input  logic                    rclk,
  input  logic                    ren,
  input  logic [ADDR_WIDTH-1 : 0] raddr,
  output logic [DATA_WIDTH-1 : 0] rdata
);
  logic [DATA_WIDTH-1 : 0] mem [0 : DEPTH-1];
  
  always_ff @(posedge wclk)
    if (wen) mem[waddr] <= wdata;
  
  always_ff @(posedge rclk)
    if (ren) rdata <= mem[raddr];
endmodule
