class transaction;
  rand bit d;
  rand bit reset;
  bit q;

  function void display(string tag);
    $display("[%0t] %s: d=%0b reset=%0b q=%0b", $time, tag, d, reset, q);
  endfunction
endclass
