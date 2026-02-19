typedef union tagged {
  int i_data;
  byte b_data;
  logic [3:0] nibble;
} my_union_t;

module tagged_union_example;
  my_union_t u;
  initial begin
    u = tagged i_data 100;
    if (u matches tagged i_data) $display("Integer value = %0d", u.i_data);
    $display("my_union_t = %p", u);
    
    u = tagged b_data 8'hAA;
    if (u matches tagged i_data) $display("Integer = %0d", u.i_data);
    else if (u matches tagged b_data) $display("Byte = %0h", u.b_data);
    else if (u matches tagged nibble) $display("Nibble = %0h", u.nibble);
    $display("my_union_t = %p", u);
    
    u = tagged nibble 4'hF;
    if (u matches tagged nibble) $display("Nibble value = %0h", u.nibble);
    $display("my_union_t = %p", u);
  end
endmodule

/*
OUTPUT:
Integer value = 100
# my_union_t = '{tagged i_data:100}
# Byte = aa
# my_union_t = '{tagged b_data:-86}
# Nibble value = f
# my_union_t = '{tagged nibble:15}
*/
