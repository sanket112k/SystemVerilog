module union_type();
  union {
    int x;
    byte y;
  } data;

    initial begin
      data.x = 'hABCF10CD;
      $display("x = %0h", data.x );
      $display("y = %0h", data.y );

      data.y = 'h56;

      $display("x = %0h", data.x );
      $display("y = %0h", data.y );
      $displayh("data = %p", data);

      $display("size of unpacked union :", $bits(data));
    end
endmodule

/*
OUTPUT:
x = abcf10cd
y = cd
x = abcf1056
y = 56
data = '{x:abcf1056, y:56}
size of unpacked union :         32
*/
