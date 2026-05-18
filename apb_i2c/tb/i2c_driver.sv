class i2c_driver;
  virtual i2c_if.drv_mp i2c_vif;
  mailbox #(i2c_transaction) gen2drv;
  event   drv_done;

  // Internal slave state machine
  typedef enum { IDLE, ADDR, DATA, ACK_WAIT } state_t;
  state_t state;

  function new(virtual i2c_if.drv_mp i2c_vif,
               mailbox #(i2c_transaction) gen2drv);
    this.i2c_vif = i2c_vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task run();
    i2c_transaction i2c_tr;
    int         bit_idx;
    logic [7:0] recv_byte;
    logic       scl_prev;
    logic       sda_prev;
    
    scl_prev = 1;
    sda_prev = 1;
    state    = IDLE;
    
    forever begin
      // Detect start condition (SDA falling while SCL high)
      if (state == IDLE && i2c_vif.sda === 0 && sda_prev === 1 && i2c_vif.scl === 1) begin
        gen2drv.get(i2c_tr);	// get next expected slave transaction
        state = ADDR;
        bit_idx = 0;
        recv_byte = 0;
      end
      
      if (i2c_vif.scl === 1 && scl_prev === 0) begin	// Sample on rising SCL edge
        case (state)
          
          ADDR: begin
            recv_byte = {recv_byte[6:0], i2c_vif.sda};
            bit_idx++;
            if (bit_idx == 8) begin
              // Check address + R/W
              if (recv_byte[7:1] != i2c_tr.slv_addr) begin
                $error("I2C address mismatch: expected 0x%0h, got 0x%0h",
                       i2c_tr.slv_addr, recv_byte[7:1]);
              end
              // Drive ACK (pull SDA low)
              i2c_vif.drv_cb.sda <= 1'b0;	//***********
              state = ACK_WAIT;
              bit_idx = 0;
            end
          end
          
          DATA: begin
            if (i2c_tr.rw == 0) begin   // master writes → slave receives
              recv_byte = {recv_byte[6:0], i2c_vif.sda};
              bit_idx++;
              if (bit_idx == 8) begin
                i2c_tr.data[bit_idx/8 - 1] = recv_byte;  // store
                i2c_vif.drv_cb.sda <= 1'b0;              // ACK
                state = ACK_WAIT;
                bit_idx = 0;
              end
            end else begin           // master reads → slave drives data
              if (bit_idx == 0) begin
                recv_byte = i2c_tr.data[0];  // first byte to send
              end
              i2c_vif.drv_cb.sda <= recv_byte[7];
              recv_byte = {recv_byte[6:0], 1'b0};
              bit_idx++;
              if (bit_idx == 8) begin
                // After sending 8 bits, master drives ACK
                state = ACK_WAIT;
                bit_idx = 0;
              end
            end
          end
          
          ACK_WAIT: begin
            // Release SDA after ACK cycle
            i2c_vif.drv_cb.sda <= 1'bz;
            if (bit_idx < i2c_tr.data.size()) begin
              state = DATA;
            end else begin
              state = IDLE;
              -> drv_done;
            end
            bit_idx++;
          end
          
        endcase
      end

      // Detect stop condition (SDA rising while SCL high)
      if (i2c_vif.sda === 1 && sda_prev === 0 && i2c_vif.scl === 1) begin
        state = IDLE;
      end

      scl_prev = i2c_vif.scl;
      sda_prev = i2c_vif.sda;
      @(posedge i2c_vif.scl);
    end
  endtask
endclass
