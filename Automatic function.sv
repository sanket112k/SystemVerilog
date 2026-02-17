module func_automatic();
  int result1,result2;
  
  function int factorial_static(int var1);
    if(var1>=2)
      result1=factorial_static(var1-1)*var1;
    else begin
      result1=1;
    end
    $display("%0t result1 = %0d", $time, result1);
    return result1;
  endfunction

  function automatic int factorial_automatic(int var1);
    if(var1>=2)
      result2=factorial_automatic(var1-1)*var1;
    else begin
      result2=1;
    end
    $display("%0t result2 = %0d", $time, result2);
    return result2;
  endfunction

  initial begin
    #1 result1=factorial_static(5);
    #1 result2=factorial_automatic(5);
    #1 $display("%0t factorial_static: %0d", $time, result1);
    #1 $display("%0t factorial_automatic: %0d", $time, result2);
  end
endmodule: func_automatic

OUTPUT:
1 result1 = 1
1 result1 = 1
1 result1 = 1
1 result1 = 1
1 result1 = 1
2 result2 = 1
2 result2 = 2
2 result2 = 6
2 result2 = 24
2 result2 = 120
3 factorial_static: 1
4 factorial_automatic: 120
