// topmodule
module testbench;
  intf intff();
  test tst(intff);
  
  full_adder fa(
    .a(intff.a),
    .b(intff.b),
    .c(intff.c),
    .sum(intff.sum)
    .cout(intff.cout)
  );
  
  initial begin
    $dumpfile("testbench.vcd")
    $dumpvars;
  end
  
endmodule
