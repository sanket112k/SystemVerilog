module string_m;

string str ="hello";
string str1="world";

string temp;

initial begin
  $display("str = %s", str);
  $display("str1 = %s", str1); 

  $display("str.len() = %0d", str.len());

  temp=str;
  temp.putc(3, "t");
  $display("temp=str  temp.putc(3, ''t'') - Used to assign one character of string");
  $display("%s", temp);

  $display("str.getc(1) = %s", str.getc(1));
  $display("str.tolower() = %s", str.tolower());
  $display("str.toupper() = %s", str.toupper());
  $display("str.compare(str1) = %0d", str.compare(str1));
  $display("str.icompare(str1) %0d", str.icompare(str1));
  $display("str.substr(1,2) = %s", str.substr(1,2));
end
endmodule

/*
OUTPUT:
str = hello
str1 = world
str.len() = 5
temp=str  temp.putc(3, ''t'') - Used to assign one character of string
helto
str.getc(1) = e
str.tolower() = hello
str.toupper() = HELLO
str.compare(str1) = -15
str.icompare(str1) -15
str.substr(1,2) = el
*/
