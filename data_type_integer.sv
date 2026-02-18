module data_type_integer;
  integer integer_data;
  
  initial begin
    $display("Value before initialization = %0b", integer_data);
    integer_data = 32'bzz??_xxxx_1111_0000_0101_1010;
    $display("Value after initialization = %0b", integer_data);
  end
endmodule

/*
OUTPUT:
Value before initialization = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Value after initialization = zzzzzzzzzzzzxxxx1111000001011010
*/
