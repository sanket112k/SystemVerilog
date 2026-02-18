module data_type_time;
 time time_data;
 
initial begin
  $display("\nBefore initialization value of time = %0t",time_data);
  
  #5;
  time_data = $time;
  $display("\nAfter initialization value of time = %0t\n", time_data);
end
endmodule

/*
OUTPUT:

Before initialization value of time = 0

After initialization value of time = 5
*/
