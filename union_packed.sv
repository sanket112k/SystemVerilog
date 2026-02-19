typedef union packed {
  bit [7:0] B;
  logic [7:0] C;
}ABC_u;

module unionpacked;
  ABC_u abc;

  initial begin
    abc.B = 'hab;
    $display("abc.B = %0h", abc.B);
    abc.C = 'hcd;
    $display("abc.C = %0h", abc.C);
    $display("size is: %0d", $bits(ABC_u));
  end
endmodule

/*
OUTPUT:
abc.B = ab
abc.C = ab
abc.B = cd
abc.C = cd
size is: 8
*/
