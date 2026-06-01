class scoreboard;

  mailbox #(transaction) mon2scb;
  transaction tr;
  event scb_done;
  event test_done;
  int pass, fail;
  int num_trans;

  function new(mailbox #(transaction) mon2scb, int num_trans, event scb_done);
    this.mon2scb   = mon2scb;
    this.num_trans = num_trans;
    this.scb_done  = scb_done;
  endfunction

  task run();
    bit exp_sum;
    bit exp_cout;
    
    forever begin
      mon2scb.get(tr);

      exp_sum  = tr.a ^ tr.b ^ tr.cin;
      exp_cout = (tr.a & tr.b) | (tr.b & tr.cin) | (tr.a & tr.cin);
      
      tr.display("SCB");
      
      if(tr.sum == exp_sum && tr.cout == exp_cout) begin
        pass++;
        $display("@t=%0t [SCB] {PASS = %0d}", $time, pass);
      end else begin
        fail++;
        $display("@t=%0t [SCB] {FAIL = %0d} exp_sum=%0b exp_cout=%0b", $time, fail, exp_sum, exp_cout);
      end
      
      $display("============================");
      
      -> scb_done;
      if(pass + fail == num_trans)
        -> test_done;
    end
  endtask
  
  function void report();
    $display("=========== REPORT ===========");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
    $display("==============================");
  endfunction
endclass
