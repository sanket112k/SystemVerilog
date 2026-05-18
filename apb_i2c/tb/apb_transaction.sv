import tb_pkg::*;

class apb_transaction;
  rand bit 		    pwrite;
  rand bit [AW-1:0] paddr;
  rand bit [DW-1:0] pwdata;
       bit [DW-1:0] prdata;
       bit 		    pslverr;
  
  constraint valid_addr{
    addr inside {8'h00, 8'h04, 8'h08, 8'h0C, 8'h10, 8'h14};
  }
  
  /*
  function string convert2string();
    return $sformatf("%s addr=0x%0h data=0x%0h",
                     write ? "WRITE" : "READ", addr, data);
  endfunction
  */
endclass
