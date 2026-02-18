module integer_to_int;
  integer integer_data;
  int int_data;
  
  initial begin
    $display("Before initialization integer_data = %b  int_data = %b", integer_data, int_data);
    integer_data = 'bzz10x1zx01;
    $display("integer_data = %b", integer_data);
    int_data = int'(integer_data);
    $display("int_data = %b", int_data);
  end
endmodule
/*
OUTPUT:
Before initialization integer_data = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  int_data = 00000000000000000000000000000000
integer_data = zzzzzzzzzzzzzzzzzzzzzzzz10x1zx01
int_data = 00000000000000000000000010010001
*/
