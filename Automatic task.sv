module task_fact();
  int result1,result2,var1,var2;
  event a,b;
  task factorial_static(int var1);
    #1;
    if(var1>=2) begin
      factorial_static(var1-1);
      result1=result1*var1;
    end
    else begin
      result1=1;
    end
    $display("%0t result1 = %0d", $time, result1);
  endtask
  task automatic factorial_automatic(int var2);
    #1;
    if(var2>=2) begin
      factorial_automatic(var2-1);
      result2=result2*var2;
    end
    else begin
      result2=1;
    end
    $display("%0t result2 = %0d", $time, result2);
  endtask

  initial begin
    $display("\t ----factorial using static & automatic task----");
    factorial_static(5);
    factorial_automatic(5);
    #1;
    $display("%0t factorial_static: %0d", $time, result1);
    #1;
    $display("%0t factorial_automatic: %0d", $time, result2);
  end
endmodule: task_fact

OUTPUT:
5 result1 = 1
5 result1 = 1
5 result1 = 1
5 result1 = 1
5 result1 = 1
10 result2 = 1
10 result2 = 2
10 result2 = 6
10 result2 = 24
10 result2 = 120
11 factorial_static: 1
12 factorial_automatic: 120
