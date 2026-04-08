import tb_pkg::*;

class transaction;
  randc bit [ADDR_WIDTH-1 : 0] addr;
  rand bit cs;
  rand bit we;
  rand bit oe;
  rand bit [DATA_WIDTH-1 : 0] data;
  bit [DATA_WIDTH-1 : 0] rdata;
  
  constraint valid{
  cs == 1;	// always access memory
  
  // Only one operation at a time
  if (we) oe == 0;
  else oe == 1;
  }
  
  function void display(string name);
    $display("(%0t) [%s] addr=%0d cs=%0b we=%0b oe=%0b data=%0h rdata=%0h", $time, name, addr, cs, we, oe, data, rdata);
  endfunction
endclass
