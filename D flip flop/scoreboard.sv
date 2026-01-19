class scoreboard;
  
  mailbox #(transaction) mon2scb;
  int pass_count = 0;
  int fail_count = 0;
  
  function new(mailbox #(transaction) mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  task run();
    transaction actual_tr;
    bit expected_q;
    
    forever begin
      mon2scb.get(actual_tr);
      
      if(actual_tr.reset == 0) expected_q = 0;
      else expected_q = actual_tr.data;
      if (actual_tr.q == expected_q) begin
        $display("[SCOREBOARD] T=%0t: PASS! D=%0h, Reset=%0h, Q_actual=%0h, Q_expected=%0h", $time, actual_tr.data, actual_tr.reset, actual_tr.q, expected_q);
        pass_count++;
      end else begin
        $display("[SCOREBOARD] T=%0t: FAIL! D=%0h, Reset=%0h, Q_actual=%0h, Q_expected=%0h", $time, actual_tr.data, actual_tr.reset, actual_tr.q, expected_q);
        fail_count++;
      end
    end
  endtask
  
  function void report();
    $display("-------------------------------------");
    $display("Scoreboard Report:");
    $display("Total Transactions: %0d", pass_count + fail_count);
    $display("Passes: %0d", pass_count);
    $display("failure: %0d", fail_count);
  endfunction
endclass
