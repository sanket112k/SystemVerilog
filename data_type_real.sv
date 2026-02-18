module data_type_real;
  real real_data;
  
  initial begin
    $display("Value before initialization = %f", real_data);
    real_data = 4.567;
    $display("Value after initialization = %f", real_data);
  end
endmodule

/*
OUTPUT:
Value before initialization = 0.000000
Value after initialization = 4.567000
*/
