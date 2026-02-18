module data_type_enum;
  enum {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}days;

initial begin
  $display("\n// days = {\n MONDAY,\n TUESDAY,\n WEDNESDAY,\n THURSDAY,\n FRIDAY,\n SATURDAY,\n SUNDAY\n }");
  
  days = days.first;
  $display("");   

  for(int i=0;i<7;i++) begin
    $display("Days name = %0s  and its value is = %0d", days.name, days);
    days = days.next;
  end
  $display("");
 end
 endmodule

/*
OUTPUT:

// days = {
 MONDAY,
 TUESDAY,
 WEDNESDAY,
 THURSDAY,
 FRIDAY,
 SATURDAY,
 SUNDAY
 }

Days name = MONDAY  and its value is = 0
Days name = TUESDAY  and its value is = 1
Days name = WEDNESDAY  and its value is = 2
Days name = THURSDAY  and its value is = 3
Days name = FRIDAY  and its value is = 4
Days name = SATURDAY  and its value is = 5
Days name = SUNDAY  and its value is = 6

*/
