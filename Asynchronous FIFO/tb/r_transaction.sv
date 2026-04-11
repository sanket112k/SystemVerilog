class r_transaction;
  rand bit 				 rreset;
  rand bit 				 ren;
  bit [DATA_WIDTH-1 : 0] rdata;
  bit 					 empty;
  bit 					 rvalid;
  
  function void display(string name);
    $display("[%0t] %0s:        rreset=%0b ren=%0b rdata=%0h empty=%0b rvalid=%0b", $time, name, rreset, ren, rdata, empty, rvalid);
  endfunction
  
endclass
