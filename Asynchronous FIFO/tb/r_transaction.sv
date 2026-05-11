import tb_pkg::*;

class r_transaction;
  rand bit 				 rreset;
  rand bit 				 ren;
  bit [DATA_WIDTH-1 : 0] rdata;
  bit 					 empty;
  bit 					 rvalid;
  
  //rand int unsigned 	 delay_cycles;
  //longint				 rclk_time;		// $time stamp in read clock domain
  
  /*
  constraint reasonable_delay_c {
    delay_cycles dist {0 := 50, [1:3] := 30, [4:8] := 20};
  }
  */
  
  //deep copy
  function r_transaction clone();
    clone = new();
    clone.rreset 		= this.rreset;
    clone.ren 			= this.ren;
    clone.rdata 		= this.rdata;
    clone.empty 		= this.empty;
    clone.rvalid 		= this.rvalid;
    //clone.delay_cycles 	= this.delay_cycles;
    //clone.rclk_time 	= this.rclk_time;
  endfunction
  
  function void display(string name);
    $display("[%0t] %0s:        rreset=%0b ren=%0b rdata=%0h empty=%0b rvalid=%0b", $time, name, rreset, ren, rdata, empty, rvalid);
  endfunction
  
endclass
