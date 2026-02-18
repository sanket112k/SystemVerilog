module typedef_enum;
  typedef enum {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}week;
  week day;
    
  initial begin
    $display("//days = {\n MONDAY,\n TUESDAY,\n WEDNESDAY,\n THURSDAY,\n FRIDAY,\n SATURDAY,\n SUNDAY\n }");
    day = day.first();
    $display("first day name = %0s  and its value is = %0d", day.name(), day.num());

    day = day.last();
    $display("last day name = %0s  and its value is = %0d", day.name(), day.num());

    day = WEDNESDAY;
    day = day.next();
    $display("next day name after wednesday  = %0s  and its value is = %0d", day.name(), day.num());

    day = WEDNESDAY;
    day = day.prev();
    $display("previous day name befor wednesday  = %0s  and its value is = %0d", day.name(), day.num());
    $display("current day name = %0s  and its value is = %0d", day.name(), day);
    $display("total number of days in week type is = %0d\n", day.num());
  end
endmodule

/*
OUTPUT:
//days = {
 MONDAY,
 TUESDAY,
 WEDNESDAY,
 THURSDAY,
 FRIDAY,
 SATURDAY,
 SUNDAY
 }
first day name = MONDAY  and its value is = 7
last day name = SUNDAY  and its value is = 7
next day name after wednesday  = THURSDAY  and its value is = 7
previous day name befor wednesday  = TUESDAY  and its value is = 7
current day name = TUESDAY  and its value is = 1
total number of days in week type is = 7
*/
