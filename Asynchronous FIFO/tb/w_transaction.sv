import tb_pkg::*;

class w_transaction;
  rand bit 					  wreset;
  rand bit 					  wen;
  rand bit [DATA_WIDTH-1 : 0] wdata;
  bit 						  full;
  
  rand int unsigned 		  delay_cycles;
  longint 					  wclk_time;	// $time stamp in write clock domain
  
  // Deep copy
  function w_transaction clone();
    clone = new();
    clone.wreset		= this.wreset;
    clone.wen 			= this.wen;
    clone.wdata 		= this.wdata;
    clone.full 			= this.full;
    clone.delay_cycles 	= this.delay_cycles;
    clone.wclk_time		= this.wclk_time;
  endfunction
  
  function void display(string name);
    $display("[%0t] %0s:        wreset=%0b wen=%0b wdata=%0h full=%0b", $time, name, wreset, wen, wdata, full);
  endfunction
  
endclass
