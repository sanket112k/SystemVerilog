module casting_shortint();
 shortint shortint_data;
 int int_data;
 longint longint_data;

 initial begin
   shortint_data = 8'b10110011;
   $display("before casting shortint_data = %b",shortint_data);
   int_data = int'(shortint_data);
   $display("after casting shortint to int = %b",int_data);
   longint_data = longint'(shortint_data); 
   $display("after casting shortint to longint = %b\n",longint_data);
 end
endmodule
/*
OUTPUT:
before casting shortint_data = 0000000010110011
after casting shortint to int = 00000000000000000000000010110011
after casting shortint to longint = 0000000000000000000000000000000000000000000000000000000010110011
*/
