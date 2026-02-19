module associative_method();
  int abc[string];
  string variable;
  string val1;

  initial begin
    abc = '{ "vadodara" : 10 , "ahmedabad" : 25 , "surendranagar" : 38 , "rajkot" : 55 , "surat":48};

    $display("abc = %p",abc);

    $display("abc.num() - gives number of elements inside array => %0d", abc.num());
    $display("abc.size() - returns size of array => %0d", abc.size());
    
    $display("abc.exists(index) - returns whether the particular index exists inside array or not");
    if(abc.exists ("vadodara")) begin
      $display("index vadodara exists in array");
    end
    else begin
      $display("index vadodara not exists in array");
    end

    $display("abc.first(index) - returns the first index value in array");
    if(abc.first(variable)) begin
      $display("abc[%s]=%0d",variable,abc[variable]);
    end

    $display("abc.last(index) - returns the last index value in array");
    if(abc.last(variable)) begin
      $display("abc[%s]=%0d",variable,abc[variable]);
    end

    $display("abc.next(index) - gives next index value which is greater than current index"); 
    if(abc.next(val1)) begin
      $display("abc[%s]=%0d",val1,abc[val1]);
    end

    $display("abc.delete(index) - deletes the index and it's corresponding value in array");
    abc.delete("surendranagar");
    $display("%p",abc);
  end
endmodule

/*
OUTPUT:
abc = '{"ahmedabad":25, "rajkot":55, "surat":48, "surendranagar":38, "vadodara":10 }
abc.num() - gives number of elements inside array => 5
abc.size() - returns size of array => 5
abc.exists(index) - returns whether the particular index exists inside array or not
index vadodara exists in array
abc.first(index) - returns the first index value in array
abc[ahmedabad]=25
abc.last(index) - returns the last index value in array
abc[vadodara]=10
abc.next(index) - gives next index value which is greater than current index
abc[ahmedabad]=25
abc.delete(index) - deletes the index and it's corresponding value in array
'{"ahmedabad":25, "rajkot":55, "surat":48, "vadodara":10 }
*/
