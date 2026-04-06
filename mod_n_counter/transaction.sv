import tb_pkg::*;

class transaction;
  rand bit reset;
  bit [$clog2(N)-1 : 0] count;
  
  constraint r_var {
    reset dist{1 := 20, 0 := 80};
  }
  
  function void display(string tag);
    $display("[%0t] %s: reset=%0b count=%0b", $time, tag, reset, count);
  endfunction
endclass
