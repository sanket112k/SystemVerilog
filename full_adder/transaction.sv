class transaction;
  rand bit a;
  rand bit b;
  rand bit c;
  bit sum;
  bit cout;
  
  function void display(string name);
    $display("__________%s__________",name);
    $display("a=%0b, b=%0b, c=%0b,   sum=%0b, cout=%0b", a, b, c, sum, cout);
    $display("............................");
  endfunction
endclass
