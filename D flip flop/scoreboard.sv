class scoreboard;
  int expected_count;
  event done;

  mailbox #(transaction) mon2scb;
  int pass, fail;

  function new(mailbox #(transaction) mon2scb, int expected_count);
    this.mon2scb = mon2scb;
    this.expected_count = expected_count;
  endfunction

  task run();
    transaction tr;
    bit expected;

    forever begin
      mon2scb.get(tr);

      if (tr.reset)
        expected = 0;
      else
        expected = tr.d;

      if (tr.q === expected) begin
        pass++;
        $display("[PASS] d=%0b reset=%0b q=%0b",
                  tr.d, tr.reset, tr.q);
      end else begin
        fail++;
        $display("[FAIL] d=%0b reset=%0b q=%0b expected=%0b",
                  tr.d, tr.reset, tr.q, expected);
      end
      if ((pass + fail) == expected_count)
      ->done;   // signal completion
    end
  endtask

  function void report();
    $display("\n==== REPORT ====");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
  endfunction

endclass
