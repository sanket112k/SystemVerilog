class scoreboard;

  mailbox #(transaction) mon2scb;
  transaction tr;

  function new(mailbox #(transaction) mon2scb);
    this.mon2scb = mon2scb;
  endfunction

  task run();
    bit exp_sum;      // declare expected 
    bit exp_cout;

    forever begin
      mon2scb.get(tr);      // 1st get data
      exp_sum = tr.a ^ tr.b ^ tr.cin;
      exp_cout = (tr.a & tr.b) | (tr.b & tr.cin) | (tr.a & tr.cin);
      if(tr.sum == exp_sum && tr.cout == exp_cout)
        $display("PASS");
      else
        $display("FAIL");
    end
  endtask
endclass
