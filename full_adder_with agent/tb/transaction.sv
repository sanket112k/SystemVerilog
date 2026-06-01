class transaction;
  rand bit a;
  rand bit b;
  rand bit cin;
       bit sum;
       bit cout;
  
  function void display(string name);
    $display("@t=%0t [%s] a=%b b=%b cin=%b sum=%b cout=%b", $time, name, a, b, cin, sum, cout);
  endfunction
endclass
