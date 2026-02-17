`timescale 1ns/1ns

module delay_example;
  int a, b, c;
  task blocking1;
    #2 a = 1;
    b = #5 1;
    #1 c = 1;
  endtask
  
  task nonblocking1;
    #2 a <= 2;
    b <= #5 2;
    #1 c <= 2;
  endtask
  
  task blocking2;
    a = #2 3;
    b = #5 3;
    c = #1 3;
  endtask
  
  task nonblocking2;
    a <= #2 4;
    b <= #5 4;
    c <= #1 4;
  endtask
  
  initial begin
    $monitor("Time=%0t | a=%0d b=%0d c=%0d", $time, a, b, c);
    blocking1;
    #10 $display("-------------blocking1-----------------");
    nonblocking1;
    #10 $display("-------------nonblocking1--------------");
    blocking2;
    #10 $display("-------------blocking2-----------------");
    nonblocking2;
    #10 $display("-------------nonblocking2--------------");
    #10 $finish;
  end
endmodule


OUTPUT:
# Time=0 | a=0 b=0 c=0
# Time=2 | a=1 b=0 c=0
# Time=7 | a=1 b=1 c=0
# Time=8 | a=1 b=1 c=1
# -------------blocking1-----------------
# Time=20 | a=2 b=1 c=1
# Time=21 | a=2 b=1 c=2
# Time=25 | a=2 b=2 c=2
# -------------nonblocking1--------------
# Time=33 | a=3 b=2 c=2
# Time=38 | a=3 b=3 c=2
# Time=39 | a=3 b=3 c=3
# -------------blocking2-----------------
# Time=50 | a=3 b=3 c=4
# Time=51 | a=4 b=3 c=4
# Time=54 | a=4 b=4 c=4
# -------------nonblocking2--------------
