`timescale 1ns/1ns
module delay_example;
  int a, b, c;
  initial begin
    b = 10;
    $display ("time=%0t a=%0d b=%0d c=%0d", $time, a, b, c);
    a = #5 b;
    $display ("time=%0t a=%0d b=%0d c=%0d", $time, a, b, c);
    b = 5;
    $display ("time=%0t a=%0d b=%0d c=%0d", $time, a, b, c);
    #5 a = b;
    $display ("time=%0t a=%0d b=%0d c=%0d", $time, a, b, c);
    b = 20;
    $display ("time=%0t a=%0d b=%0d c=%0d", $time, a, b, c);
    #0 c = 30;
    $display ("time=%0t a=%0d b=%0d c=%0d", $time, a, b, c);
    $finish;
  end
endmodule

/*
OUTPUT:
# time=0 a=0 b=10 c=0
# time=5 a=10 b=10 c=0
# time=5 a=10 b=5 c=0
# time=10 a=5 b=5 c=0
# time=10 a=5 b=20 c=0
# time=10 a=5 b=20 c=30
*/
