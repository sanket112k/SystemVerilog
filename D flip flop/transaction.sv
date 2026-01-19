class transaction;
  rand bit data;
  rand bit reset;
  bit q;
  
  function void calc_expeted(bit current_q);
    if (reset == 0) q = 0;
    else q = data;
  endfunction
  
  function void display(string name = "");
    $display("[%0t] %s: data=%0b, reset=%0b, q_expected=%0b", $time, name, data, reset, q);
  endfunction
endclass
