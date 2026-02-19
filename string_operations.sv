module string_operations;

string str1 ="hello";
string str2 ="world";

initial begin
  $display("str1 = %s", str1);
  $display("str2 = %s", str2);

  $display("\nstr1 == str2, Equality operator");
  if(str1==str2) $display("str1 and str2 are equal");
  else $display("str1 and str2 are not equal");

  $display("\nstr1 != str2, Inequality operator");
  if(str1!= str2) $display("str1 and str2 are not equal");
  else $display("str1 and str2 are equal");

  $display("\nComparision operator ( > => < <= ), compares ascii value");
  if(str1 < str2)
  $display("Str1 < Str2");
  if(str1 <= str2)
  $display("Str1 <= Str2");
  if(str1 > str2)
  $display("Str1 > Str2");
  if(str1 >= str2)
  $display("Str1 >= Str2");

  $display("\n Concatenation of str1 and str2, {str1, str2}");
  $display("%s", {str1, str2});

  $display("\n// Replication of str1,{2{str1}}");
  $display("%s",{2{str1}});

  $display("\n// Displaying index letter of a string, str1[i]");
  for(int i =0 ;i <7 ; i++)
  $display("%s ",str1[i]);
end
endmodule

/*
OUTPUT:
str1 = hello
str2 = world

str1 == str2, Equality operator
str1 and str2 are not equal

str1 != str2, Inequality operator
str1 and str2 are not equal

Comparision operator ( > => < <= ), compares ascii value
Str1 < Str2
Str1 <= Str2

 Concatenation of str1 and str2, {str1, str2}
helloworld

// Replication of str1,{2{str1}}
hellohello

// Displaying index letter of a string, str1[i]
h 
e 
l 
l 
o 
*/
