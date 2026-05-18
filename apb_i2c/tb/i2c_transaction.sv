class i2c_transaction;
  rand bit [6:0]  slv_addr;
  rand bit        rw;        // 0 = write, 1 = read
  rand bit [7:0]  data[];
       bit        ack;       // from master: ACK received
  
  constraint data_len { data.size() inside {[1:8]}; }
  /*
  function string convert2string();
    string s = $sformatf("I2C %s addr=0x%0h data[%0d]= ",
                         rw ? "READ" : "WRITE", alv_addr, data.size());
    foreach (data[i]) s = {s, $sformatf("0x%0h ", data[i])};
    return s;
  endfunction
  */
endclass
