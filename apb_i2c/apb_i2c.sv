`include "i2c_master_defines.svh"
`include "i2c_master_byte_ctrl.sv"

module apb_i2c #(
  parameter integer DW = 32,
  parameter integer AW = 8
)(
  input  logic 		    pclk,
  input  logic 		    presetn,
  
  // APB
  input  logic 		    psel,
  input  logic 		    penable,
  input  logic 		    pwrite,
  input  logic [AW-1:0] paddr,
  input  logic [DW-1:0] pwdata,
  output logic [DW-1:0] prdata,
  output logic 		    pready,
  output logic		    pslverr,
  
  // i2c signals
  input  logic          scl_i,
  output logic          scl_o,
  output logic          scl_oen,
  input  logic          sda_i,
  output logic          sda_o,
  output logic          sda_oen
);
  
  // i2c registers
  logic [15:0] r_pre;
  logic  [7:0] r_ctrl;
  logic  [7:0] r_tx;
  logic  [7:0] r_rx;
  logic  [7:0] r_cmd;
  logic  [7:0] r_status;
  
  logic start  = r_cmd[7];
  logic stop   = r_cmd[6];
  logic read   = r_cmd[5];
  logic write  = r_cmd[4];
  logic ack_in = r_cmd[3];
  
  logic i2c_ena = r_ctrl[7];
  logic ien     = r_ctrl[6];
  
  logic cmd_ack;
  logic ack_out;
  logic i2c_busy;
  logic i2c_arb_lost;
  
  logic rxack;
  logic arb_lost;
  logic tip;
  
  
  localparam [7:0] PRESCALE = 8'h00;
  localparam [7:0] CTRL     = 8'h04;
  localparam [7:0] TX       = 8'h08;
  localparam [7:0] RX       = 8'h0C;
  localparam [7:0] CMD      = 8'h10;
  localparam [7:0] STATUS   = 8'h14;
  
  i2c_master_byte_ctrl byte_controller(
    .clk		  (pclk		   ),
    .resetn		  (presetn 	   ),
    // ctrl signal
    .ena		  (i2c_ena	   ),
    // clk preset value
    .clk_cnt	  (r_pre	   ),
    // transmit and recieve values
    .din		  (r_tx		   ),
    .dout		  (r_rx		   ),
    // command signals
    .start		  (start	   ),
    .stop		  (stop		   ),
    .read		  (read		   ),
    .write		  (write	   ),
    .ack_in		  (ack_in	   ),
    // status signals
    .cmd_ack	  (cmd_ack	   ),
    .ack_out	  (ack_out	   ),
    .i2c_busy	  (i2c_busy	   ),
    .i2c_arb_lost (i2c_arb_lost),
    // i2c signals
    .scl_i		  (scl_i	   ),
    .scl_o		  (scl_o	   ),
    .scl_oen	  (scl_oen	   ),
    .sda_i		  (sda_i	   ),
    .sda_o		  (sda_o	   ),
    .sda_oen	  (sda_oen	   )
  );
  
  always_ff @(posedge pclk, negedge presetn) begin
    if (!presetn) begin
      r_pre  <= '0;
      r_ctrl <= '0;
      r_tx   <= '0;
      r_cmd  <= '0;
    end else if (cmd_ack || i2c_arb_lost)
      r_cmd[7:4] <= '0;
    else if (psel && penable && pwrite) begin
      case (paddr)
        PRESCALE: r_pre  <= pwdata[15:0];
        CTRL    : r_ctrl <= pwdata[7:0];
        TX      : r_tx   <= pwdata[7:0];
        CMD     : if(i2c_ena) r_cmd  <= pwdata[7:0];
      endcase
    end
  end
  
  always_comb begin
    pslverr = '0;
    case (paddr)
      PRESCALE: prdata = '0;
      CTRL    : prdata = '0;
      TX      : prdata = '0;
      RX      : prdata = {24'h0, r_rx};
      CMD     : prdata = '0;
      STATUS  : prdata = {24'h0, r_status};
      default : pslverr = 1'b1;
    endcase
  end
  
  always_ff @(posedge pclk, negedge presetn) begin
    if (!presetn) begin
      rxack    <= 1'b0;
      arb_lost <= 1'b0;
      tip      <= 1'b0;
    end else begin
      rxack    <= ack_out;
      arb_lost <= i2c_arb_lost | (arb_lost & ~start);
      tip      <= read | write;
    end
  end
  
  assign r_status[7]   = rxack;
  assign r_status[6]   = i2c_busy;
  assign r_status[5]   = arb_lost;
  assign r_status[1]   = tip;
  
  assign pready = 1'b1;
  
endmodule
