module dynamic_array;
  int abc[];
  initial begin
    abc = new[7];
    abc = '{11,12,13,14,15,16,17};
    $display("value of abc = %p", abc);
    foreach(abc[i]) begin
      $display("value of abc[%0d]=%0d",i,abc[i]);
    end
  end
endmodule

/*
OUTPUT:
value of abc = '{11, 12, 13, 14, 15, 16, 17}
value of abc[0]=11
value of abc[1]=12
value of abc[2]=13
value of abc[3]=14
value of abc[4]=15
value of abc[5]=16
value of abc[6]=17
*/
