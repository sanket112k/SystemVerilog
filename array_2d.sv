module array_2d();
  bit [2:0][3:0] arr;
  initial begin
    arr = 12'hbed;
    $display("value of array arr = %p", arr);
    foreach(arr[i]) begin
      foreach(arr[i][j]) begin
        $display("value of arr[%0d][%0d] = %0d", i, j, arr[i][j]);
      end
    end
  end
endmodule

/*
OUTPUT:
value of array arr = '{11, 14, 13}
value of arr[2][3] = 1
value of arr[2][2] = 0
value of arr[2][1] = 1
value of arr[2][0] = 1
value of arr[1][3] = 1
value of arr[1][2] = 1
value of arr[1][1] = 1
value of arr[1][0] = 0
value of arr[0][3] = 1
value of arr[0][2] = 1
value of arr[0][1] = 0
value of arr[0][0] = 1
*/
