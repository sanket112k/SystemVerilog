class w_transaction;
  rand bit 					  wreset;
  rand bit 					  wen;
  rand bit [DATA_WIDTH-1 : 0] wdata;
  bit 						  full;
  
  function void display(string name);
    $display("[%0t] %0s:        wreset=%0b wen=%0b wdata=%0h full=%0b", $time, name, wreset, wen, wdata, full);
  endfunction
  
endclass
