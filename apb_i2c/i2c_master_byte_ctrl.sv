
`timescale 1ns/10ps

module i2c_master_byte_ctrl(
  input  logic        clk,
  input  logic        resetn,
  
  // ctrl register
  input  logic        ena,
  
  // clk prescale register
  input  logic [15:0] clk_cnt,	// 4x SCL
  
  // transmit register
  input  logic [7:0]  din,		// parallel byte in
  
  // receive regieter
  output logic [7:0]  dout,		// parallel byte out

  
  // command register
  input  logic        start,
  input  logic        stop,
  input  logic        read,
  input  logic        write,
  input  logic        ack_in,	// ACK, when a receiver, sent ACK (ACK = ‘0’) or NACK (ACK = ‘1’)
  
  
  // status register
  output logic        cmd_ack,	// byte done
  output logic        ack_out,
  output logic        i2c_busy,
  output logic        i2c_arb_lost,
  
  
  // i2c signals
  input  logic        scl_i,
  output logic        scl_o,
  output logic        scl_oen,
  input  logic        sda_i,
  output logic        sda_o,
  output logic        sda_oen
);
  
  enum bit [2:0] {
    IDLE,
    START,
    READ,
    WRITE,
    ACK,
    STOP
  } state;
  
  // signals for bit_controller
  logic [3:0] core_cmd;
  logic       core_txd;		// serial_out
  logic       core_rxd;		// serial_in
  logic       core_ack;		// bit done
  
  // signals for shift register
  logic [7:0] shiftreg;
  logic       shift;
  logic       load;
  
  // signals for state machine
  logic       go;
  logic [2:0] dcnt;
  logic       cnt_done;
  
  i2c_master_bit_ctrl bit_controller(
    .clk     (clk         );
    .resetn  (resetn      );
    .ena     (ena         );
    .clk_cnt (clk_cnt     );
    .cmd     (core_cmd    );
    .cmd_ack (core_ack    );	// bit done
    .busy    (i2c_busy    );
    .arb_lost(i2c_arb_lost);
    .din     (core_txd    );
    .dout    (core_rxd    );
    .scl_i   (scl_i       );
    .scl_o   (scl_o       );
    .scl_oen (scl_oen     );
    .sda_i   (sda_i       );
    .sda_o   (sda_o       );
    .sda_oen (sda_oen     );
  );
  
  assign go = (read | write | stop) & ~cmd_ack;
  assign dout = shiftreg;
  
  // generate shift register and generate counter
  always_ff @(posedge clk, negedge resetn) begin
    if (!resetn) 	begin   shiftreg <= 8'h0; 						 dcnt <= 3'h0; 		  end
    else if (load) 	begin   shiftreg <= din; 						 dcnt <= 3'h7; 		  end
    else if (shift) begin   shiftreg <= {shiftreg[6:0], core_rxd};   dcnt <= dcnt - 3'h1; end
  end
  
  assign cnt_done = (dcnt == 0);
  
  always_ff @(posedge clk, negedge resetn) begin
    if (!resetn || i2c_arb_lost) begin
      core_cmd <= `I2C_CMD_NOP;
      core_txd <= 1'b0;
      shift    <= 1'b0;
      load     <= 1'b0;
      cmd_ack  <= 1'b0;
      state    <= IDLE;
      ack_out  <= 1'b0;
    end
    else begin
      core_txd <= shift_reg[7];
      shift    <= 1'b0;
      load     <= 1'b0;
      cmd_ack  <= 1'b0;
      
      case (state)
        IDLE:
          if(go) begin
            if(start) 		begin   state <= START; 	core_cmd <= `I2C_CMD_START; end
            else if (read) 	begin   state <= READ; 		core_cmd <= `I2C_CMD_READ; 	end
            else if (write) begin   state <= WRITE; 	core_cmd <= `I2C_CMD_WRITE; end
            else 			begin   state <= STOP; 		core_cmd <= `I2C_CMD_STOP; 	end
            load <= 1'b1;
          end
        
        START:
          if (core_ack) begin	// bit done
            if (read) 		begin   state <= READ; 		core_cmd <= `I2C_CMD_READ;  end
            else 	  		begin   state <= WRITE;   	core_cmd <= `I2C_CMD_WRITE; end
            load <= 1'b1;
          end
        
        WRITE:
          if (core_ack) begin	// bit done
            if (cnt_done) 	begin   state <= ACK; 		core_cmd <= `I2C_CMD_READ; 	 end
            else 		  	begin   state <= WRITE;   	core_cmd <= `I2C_CMD_WRITE;  end	// shift <= 1'b1;
            shift <= 1'b1;
          end
        
        READ:
          if (core_ack) begin
            if (cnt_done) 	begin   state <= ACK; 		core_cmd <= `I2C_CMD_WRITE; end
            else 		  	begin   state <= READ; 		core_cmd <= `I2C_CMD_READ;  end
            shift    <= 1'b1;
            core_txd <= ack_in;
          end
        
        ACK: begin
          if (core_ack) begin
            if (stop) 		begin 	state <= STOP; 		core_cmd <= `I2C_CMD_STOP; 					 end
            else 			begin 	state <= IDLE; 		core_cmd <= `I2C_CMD_NOP;   cmd_ack <= 1'b1; end	// byte done
            
            // assign ack_out output to bit_controller_rxd (contains last received bit)
            ack_out  <= core_rxd;	// status_ack
            core_txd <= 1'b1;
          end
          else
            core_txd <= ack_in;
        end
        
        STOP:
          if (core_ack) 	begin 	state <= IDLE; 		core_cmd <= `I2C_CMD_NOP;   cmd_ack <= 1'b1; end	// byte done
      endcase
    end
  end
endmodule
