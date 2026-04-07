module single_port_sync_ram #(
  parameter DEPTH = 256,
  parameter DATA_WIDTH = 32,
  localparam ADDR_WIDTH = $clog2(DEPTH)
)(
  input logic clk,
  input logic [ADDR_WIDTH-1 : 0] addr,
  input logic cs,
  input logic we,
  input logic oe,
  inout wire [DATA_WIDTH-1 : 0] data
);
  logic [DATA_WIDTH-1 : 0] mem [DEPTH];
  logic [ADDR_WIDTH-1 : 0] addr_reg;
  always_ff @(posedge clk) begin
    if(cs) begin
      if(we)
        mem[addr] <= data;
      else
        addr_reg <= addr;
    end
  end
  assign data = (cs & oe & !we) ? mem[addr_reg] : 'bz;
endmodule
