class scoreboard;
  transaction tr;
  mailbox #(transaction) mon2scb;
  
  function new(mailbox #(transaction) mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  task run()
    forever begin
      
    end
  endtask
endclass
