// Full adder
module full_adder(
  input a, b, c,
  output sum, cout
);
  
  wire c1, c2, c3;
  
  xor x1(sum, a, b, c);
  
  and a1(c1, a, b);
  and a2(c2, b, c);
  and a3(c3, c, a);
  
  or o1(cout, c1, c2. c3);
  
  end
endmodule
