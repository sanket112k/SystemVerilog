class transaction;
  rand bit resetn;
  rand bit w_en;
  rand bit r_en;
  rand bit [DATA_WIDTH-1 : 0] data_in;
  bit      [DATA_WIDTH-1 : 0] data_out;
  bit full;
  bit empty;
  
  //constraint a {resetn dist {1'b0 := 95, 1'b1 := 5}};
  
  function void display(string name);
    $display("[%0t] %0s:        resetn=%0b w_en=%0b r_en=%0b data_in=%0h data_out=%0h full=%0b empty=%0b", $time, name, resetn, w_en, r_en, data_in, data_out, full, empty);
  endfunction
endclass
