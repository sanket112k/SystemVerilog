module testbench(
  input bit [7:0] addr
);
  initial $display("\t Addr = %0d", addr);
endmodule

// Output: Addr = 0;
