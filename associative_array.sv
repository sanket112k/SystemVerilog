module associative_array();
  int abc[*];
  string pqr[string];
  
  initial begin
    abc = '{1 : 20 , 25 : 22 , 38 : 66};
    pqr = '{"fruits" : "mango" , "vegetables" : "cucumber" , "season" : "monsoon"};
    
    $display("abc = %p",abc);
    $display("pqr = %p",pqr);
  end
endmodule

/*
OUTPUT:
abc = '{1:20, 25:22, 38:66 }
pqr = '{"fruits":"mango", "season":"monsoon", "vegetables":"cucumber" }
*/
