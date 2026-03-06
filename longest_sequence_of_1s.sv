/*
Find Longest Sequence of 1’s
Given a 32-bit input, output the length of longest consecutive 1's.
Example:
input  = 110111011111000
output = 5
*/
module longest_sequence_of_1s;
  reg [31:0] in = 32'b1101_1110_1011_1011_1111_1000_1110_0101;

  integer i, count = 0, max = 0;
  initial begin
    for (i = 0; i < 32; i++) begin
      if (count > max) max = count;
      if (in[i]) count++;
      else count = 0;
    end
    $display("longest_sequence_of_1s is %0d", max);
  end
endmodule

/*
OUTPUT:
longest_sequence_of_1s is 7
*/
