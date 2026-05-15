class transaction;
  rand bit 			psel;//
  rand bit 			penable;//
  rand bit 			pwrite;
  rand bit [AW-1:0] paddr;
  rand bit [DW-1:0] pwdata;
       bit [DW-1:0] prdata;
       bit 			pready;//
       bit 			pslverr;
  
  rand bit          scl_i;
       bit          scl_o;
       bit          scl_oen;
  rand bit          sda_i;
       bit          sda_o;
       bit          sda_oen;
  
  function void display(string name);
    $display();
  endfunction
endclass
