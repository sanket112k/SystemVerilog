//import tb_pkg::*;

class scoreboard;
  
  transaction tr;
  mailbox #(transaction) mon2scb;
  int pass, fail;
  event done;
  
  bit [DATA_WIDTH-1 : 0] model_mem [DEPTH];
  bit [ADDR_WIDTH : 0]   model_w_ptr;
  bit [ADDR_WIDTH : 0]   model_r_ptr;
  bit [DATA_WIDTH-1 : 0] exp_data_out;
  bit exp_full;
  bit exp_empty;
  
  function new(mailbox #(transaction) mon2scb);
    this. mon2scb = mon2scb;
  endfunction
  
  task run();
    forever begin
      mon2scb.get(tr);
      
      // Update the model
      if(!tr.resetn) begin
        model_w_ptr = 0;
        model_r_ptr = 0;
        exp_data_out = 0;
      end
      else begin
        if (tr.w_en && !exp_full) begin
          model_mem [model_w_ptr[ADDR_WIDTH-1 : 0]] = tr.data_in;
          model_w_ptr++;
        end
        if (tr.r_en && !exp_empty) begin
          exp_data_out = model_mem[model_r_ptr[ADDR_WIDTH-1 : 0]];
          model_r_ptr++;
        end
      end
      
      // Compute flags from updated pointers
      exp_empty = (model_w_ptr == model_r_ptr);
      exp_full  = (model_w_ptr[ADDR_WIDTH]     != model_r_ptr[ADDR_WIDTH]) &&
                  (model_w_ptr[ADDR_WIDTH-1:0] == model_r_ptr[ADDR_WIDTH-1:0]);
      
      // Compare
        if(tr.data_out === exp_data_out &&
           tr.full     === exp_full &&
           tr.empty    === exp_empty) begin
          $display("[%0t] SCB: {PASS} resetn=%0b w_en=%0b r_en=%0b data_in=%0h data_out=%0h full=%0b empty=%0b", $time, tr.resetn, tr.w_en, tr.r_en, tr.data_in, tr.data_out, tr.full, tr.empty);
          pass++;
        end
        else begin
          $display("[%0t] SCB: {FAIL} resetn=%0b w_en=%0b r_en=%0b data_in=%0h data_out=%0h full=%0b empty=%0b | exp_data_out=%0h exp_full=%0b exp_empty=%0b", $time, tr.resetn, tr.w_en, tr.r_en, tr.data_in, tr.data_out, tr.full, tr.empty, exp_data_out, exp_full, exp_empty);
          fail++;
        end
      
      $display("--------------------------------------------");
      if(pass+fail == (2*DEPTH + 10))
        -> done;
    end
  endtask
  
  function void report();
    $display("\n==== REPORT ====");
    $display("PASS = %0d", pass);
    $display("FAIL = %0d", fail);
  endfunction
endclass
