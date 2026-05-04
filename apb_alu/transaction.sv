class transaction;
  rand bit 			presetn;
  rand bit 			psel;
  rand bit 			penable;
  rand bit 			pwrite;
  rand bit [AW-1:0] paddr;
  rand bit [DW-1:0] pwdata;
       bit [DW-1:0] prdata;
       bit 			pready;
       bit 			pslverr;
  
  function void display(string name);
    $display();
  endfunction
endclass
