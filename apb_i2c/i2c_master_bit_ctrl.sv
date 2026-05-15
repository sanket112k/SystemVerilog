//
/////////////////////////////////////
// Bit controller section
/////////////////////////////////////
//
// Translate simple commands into SCL/SDA transitions
// Each command has 5 states, A/B/C/D/idle
//
// start:		SCL	~~~~~~~~~~\____
//				SDA	~~~~~~~~\______
//		 		x | A | B | C | D | i
//
// repstart:	SCL	____/~~~~\___
//				SDA	__/~~~\______
//		 		x | A | B | C | D | i
//
// stop:		SCL	____/~~~~~~~~
//				SDA	==\____/~~~~~
//		 		x | A | B | C | D | i
//
// write:		SCL	____/~~~~\____
//				SDA	==X=========X=
//		 		x | A | B | C | D | i
//
// read:		SCL	____/~~~~\____
//				SDA	XXXX=====XXXX
//		 		x | A | B | C | D | i
//

// Timing:     Normal mode      Fast mode
///////////////////////////////////////////////////////////////////////
// Fscl        100KHz           400KHz
// Th_scl      4.0us            0.6us   High period of SCL
// Tl_scl      4.7us            1.3us   Low period of SCL
// Tsu:sta     4.7us            0.6us   setup time for a repeated start condition
// Tsu:sto     4.0us            0.6us   setup time for a stop conditon
// Tbuf        4.7us            1.3us   Bus free time between a stop and start condition
///////////////////////////////////////////////////////////////////////

`include "i2c_master_defines.svh"

module i2c_master_bit_ctrl(
  input  logic        clk,
  input  logic        resetn,	// async active low reset
  input  logic        ena,		// core enable signal
  
  input  logic [15:0] clk_cnt,	// clock prescale value
  
  input  logic [3:0]  cmd,		// command (from byte controller)
  output logic        cmd_ack,	// command complete acknowledge
  output logic        busy,		// i2c bus busy
  output logic        arb_lost,	// i2c bus arbitration lost
  
  input  logic        din,		// serial write
  output logic        dout,		// serial read
  
  input  logic        scl_i,	
  output logic        scl_o,	
  output logic        scl_oen,	
  input  logic        sda_i,	
  output logic        sda_o,	
  output logic        sda_oen	 
);
  
  logic [1:0]  cSCL, cSDA;	// capture SCL and SDA
  logic [2:0]  fSCL, fSDA;	// SCL and SDA filter inputs
  logic        sSCL, sSDA;	// filtered and synchronized SCL and SDA inputs
  logic        dSCL, dSDA;	// delayed versions of sSCL and sSDA
  
  logic        dscl_oen;	// delayed scl_oen
  logic        sda_chk;		// check SDA output (multi-master arbitration)
  logic        clk_en;		// clk generation signals
  logic        slave_wait;	// slave inserts wait states
  logic [15:0] cnt;			// clk divider counter (synthesis)
  logic [13:0] filter_cnt;	// clk divider for filter
  
  enum bit [4:0] {
    IDLE,
    START_A, START_B, START_C, START_D, START_E,
    STOP_A,  STOP_B,  STOP_C,  STOP_D,
    READ_A,  READ_B,  READ_C,  READ_D,
    WRITE_A, WRITE_B, WRITE_C, WRITE_D
  } state;
  
  
  // whenever the slave is not ready it can delay the cycle by pulling SCL low
  // delay scl_oen
  always_ff @(posedge clk)
    dscl_oen <= scl_oen;
  
  // slave_wait is asserted when master wants to drive SCL high, but the slave pulls it low
  // slave_wait remains asserted until the slave releases SCL
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) slave_wait <= 1'b0;
    else		 slave_wait <= (scl_oen & ~dscl_oen & ~sSCL) | (slave_wait & ~sSCL);
  end
  
  // master drives SCL high, but another master pulls it low
  // master start counting down its low cycle now (clock synchronization)
  logic scl_sync = dSCL & ~sSCL & scl_oen;
  
  
  // generate clk enable signal
  always_ff @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      cnt    <= 16'h0;
      clk_en <= 1'b1;
    end else if (cnt == 16'h0 || !ena || scl_sync) begin
      cnt    <= clk_cnt;			// get clk prescale value
      clk_en <= 1'b1;
    end else if (slave_wait) begin
      cnt    <= cnt;				// no change
      clk_en <= 1'b0;
    end else begin
      cnt    <= cnt - 16'h1;		// decrement
      clk_en <= 1'b0;
    end
  end
  
  // generate bus status controller
  
  // capture SDA and SCL
  // reduce metastability risk
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      cSCL <= 2'b00;
      cSDA <= 2'b00;
    end else begin
      cSCL <= {cSCL[0], scl_i};		// {past_scl, present_scl} every clk
      cSDA <= {cSDA[0], sda_i};		// {past_sda, present_sda}
    end
  end
  
  // filter SCL and SDA signals; (attempt to) remove glitches
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn || !ena)
      filter_cnt <= 14'h0;
    else if (filter_cnt == 0)
      filter_cnt <= clk_cnt >> 2;		// 16x i2c bus frequency
    else
      filter_cnt <= filter_cnt - 14'h1;
  end
  
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      fSCL <= 3'b111;
      fSDA <= 3'b111;
    end
    else if (filter_cnt == 0) begin
      fSCL <= {fSCL[1:0], cSCL[1]};		// {past_scl[1:0], past_scl} every (filter_cnt == 0)
      fSDA <= {fSDA[1:0], cSDA[1]};
    end
  end
  
  // generate filtered SCL and SDA signals
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      sSCL <= 1'b1;
      sSDA <= 1'b1;
      
      dSCL <= 1'b1;
      dSDA <= 1'b1;
    end else begin
      sSCL <= &fSCL[2:1] | &fSCL[1:0] | (fSCL[2] & fSCL[0]);	// any 2 bit are 1's
      sSDA <= &fSDA[2:1] | &fSDA[1:0] | (fSDA[2] & fSDA[0]);
      
      dSCL <= sSCL;		// delayed sSCL
      dSDA <= sSDA;
    end
  end
  
  // detect start condition => detect falling edge on SDA while SCL is high
  // detect stop condition => detect rising edge on SDA while SCL is high
  logic start_condition;
  logic stop_condition;
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      start_condition <= 1'b0;
      stop_condition  <= 1'b0;
    end else begin
      start_condition <= ~sSDA &  dSDA & sSCL;
      stop_condition  <=  sSDA & ~dSDA & sSCL;
    end
  end
  
  // generate i2c bus busy signal
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) busy <= 1'b0;
    else		 busy <= (start_condition | busy) & ~stop_condition;
  end
  
  // generate arbitration lost signal
  // aribitration lost when:
  // 1) master drives SDA high, but the i2c bus is low
  // 2) stop detected while not requested
  reg cmd_stop;
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn)
      cmd_stop <= 1'b0;
    else if (clk_en)
      cmd_stop <= (cmd == `I2C_CMD_STOP);
  end
  
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn)
      arb_lost <= 1'b0;
    else
      arb_lost <= (sda_chk & ~sSDA & sda_oen) | (state != IDLE & stop_condition & ~cmd_stop);
  end
  
  // generate dout signal (store SDA on rising edge of SCL)
  always_ff @(posedge clk)
    if (sSCL & ~dSCL) dout <=sSDA;
  
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn || arb_lost) begin
      state   <= IDLE;
      cmd_ack <= 1'b0;
      scl_oen <= 1'b1;
      sda_oen <= 1'b1;
      sda_chk <= 1'b0;
    end
    else begin
      cmd_ack <= 1'b0; // default no command acknowledge + assert cmd_ack only 1clk cycle
      if (clk_en)
        case (state)
          IDLE: begin
            case (cmd)
              `I2C_CMD_START: state <= START_A;
              `I2C_CMD_STOP:  state <= STOP_A;
              `I2C_CMD_WRITE: state <= WRITE_A;
              `I2C_CMD_READ:  state <= READ_A;
              default:        state <= IDLE;
            endcase
            scl_oen <= scl_oen;		// keep SCL in same state
            sda_oen <= sda_oen;		// keep SDA in same state
            sda_chk <= 1'b0;		// don't check SDA output
          end
          
          
          // start:		SCL	~~~~~~~~~~\____
          //			SDA	~~~~~~~~\______
          //		 	x | A | B | C | D | i
          START_A: begin
            state   <= START_B;
            scl_oen <= scl_oen;		// keep same
            sda_oen <= 1'b1;		// set SDA high
            sda_chk <= 1'b0;		// don't check
          end
          START_B: begin
            state   <= START_C;
            scl_oen <= 1'b1;		// set SCL high
            sda_oen <= 1'b1;		// keep SDA high
            sda_chk <= 1'b0;		// don't ckeck
          end
          START_C: begin
            state   <= START_D;
            scl_oen <= 1'b1;
            sda_oen <= 1'b0;
            sda_chk <= 1'b0;
          end
          START_D: begin
            state   <= START_E;
            scl_oen <= 1'b1;
            sda_oen <= 1'b0;
            sda_chk <= 1'b0;
          end
          START_E: begin
            state   <= IDLE;
            cmd_ack <= 1'b1;
            scl_oen <= 1'b1;
            sda_oen <= 1'b0;
            sda_chk <= 1'b0;
          end
          
          // stop:		SCL	______/~~~~~~~~
          //			SDA	==\______/~~~~~
          //		 	x | A | B | C | D | i
          STOP_A: begin
            state   <= STOP_B;
            scl_oen <= 1'b0;
            sda_oen <= 1'b0;
            sda_chk <= 1'b0;
          end
          STOP_B: begin
            state   <= STOP_C;
            scl_oen <= 1'b1;
            sda_oen <= 1'b0;
            sda_chk <= 1'b0;
          end
          STOP_C: begin
            state   <= STOP_D;
            scl_oen <= 1'b1;
            sda_oen <= 1'b0;
            sda_chk <= 1'b0;
          end
          STOP_D: begin
            state   <= IDLE;
            cmd_ack <= 1'b1;
            scl_oen <= 1'b1;
            sda_oen <= 1'b1;
            sda_chk <= 1'b0;
          end
          
          
          // read:		SCL	____/~~~~\____
          //			SDA	XXXX=====XXXX
          //		 	x | A | B | C | D | i
          READ_A: begin
            state   <= READ_B;
            scl_oen <= 1'b0;
            sda_oen <= 1'b1;
            sda_chk <= 1'b0;
          end
          READ_B: begin
            state   <= READ_C;
            scl_oen <= 1'b1;
            sda_oen <= 1'b1;
            sda_chk <= 1'b0;
          end
          READ_C: begin
            state   <= READ_D;
            scl_oen <= 1'b1;
            sda_oen <= 1'b1;
            sda_chk <= 1'b0;
          end
          READ_D: begin
            state   <= IDLE;
            cmd_ack <= 1'b1;
            scl_oen <= 1'b0;
            sda_oen <= 1'b1;
            sda_chk <= 1'b0;
          end
          
          // write:		SCL	____/~~~~\____
          //			SDA	==X=========X=
          //		 	x | A | B | C | D | i
          WRITE_A: begin
            state   <= WRITE_B;
            scl_oen <= 1'b0;
            sda_oen <= din;
            sda_chk <= 1'b0;
          end
          WRITE_B: begin
            state   <= WRITE_C;
            scl_oen <= 1'b1;
            sda_oen <= din;
            sda_chk <= 1'b0;
          end
          WRITE_C: begin
            state   <= WRITE_D;
            scl_oen <= 1'b1;
            sda_oen <= din;
            sda_chk <= 1'b1;
          end
          WRITE_D: begin
            state   <= IDLE;
            cmd_ack <= 1'b1;
            scl_oen <= 1'b0;
            sda_oen <= din;
            sda_chk <= 1'b0;
          end
        endcase
    end
  end
  
  // assign scl and sda output (always gnd)
  assign scl_o = 1'b0;
  assign sda_o = 1'b0;
  
endmodule
