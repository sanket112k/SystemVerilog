/*
                         +-------------------+
                         |       TEST        |
                         |-------------------|
                         | configure test    |
                         | start generator   |
                         +---------+---------+
                                   |
                                   v
                         +-------------------+
                         |    GENERATOR      |
                         |-------------------|
                         | Random/Directed   |
                         | APB transactions  |
                         +---------+---------+
                                   |
                            mailbox/queue
                                   |
                                   v
                         +-------------------+
                         |      DRIVER       |
                         |-------------------|
                         | Drives APB bus    |
                         | psel/penable/...  |
                         +---------+---------+
                                   |
                                   v
                    =================================
                              APB INTERFACE
                    =================================
                                   |
                                   v
                         +-------------------+
                         |        DUT        |
                         |-------------------|
                         |   apb_alu_top     |
                         |                   |
                         | +---------------+ |
                         | |   apb_regs    | |
                         | +---------------+ |
                         | |   alu_core    | |
                         | +---------------+ |
                         +---------+---------+
                                   |
                    =================================
                              APB INTERFACE
                    =================================
                                   |
                 +-----------------+-----------------+
                 |                                   |
                 v                                   v
      +-------------------+              +-------------------+
      |      MONITOR      |              | REFERENCE MODEL   |
      |-------------------|              |-------------------|
      | Samples APB bus   |              | Predict expected  |
      | Collects outputs  |              | ALU result/flags  |
      +---------+---------+              +---------+---------+
                |                                  |
                +---------------+------------------+
                                |
                                v
                      +-------------------+
                      |    SCOREBOARD     |
                      |-------------------|
                      | Compare DUT vs RM |
                      | Check flags/error |
                      +-------------------+
*/

`timescale 1ns/1ps
`include "tb_pkg.sv"
`include "interface.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic presetn;
  logic pclk = 0;
  always #5 pclk = ~pclk;
  
  apb_if my_apb_if(.pclk(pclk), .presetn(presetn));
  
  apb_alu_top #(.DW (DW)) apb_alu(
    .pclk    (pclk),
    .presetn (presetn),
    .psel    (my_apb_if.psel),
    .penable (my_apb_if.penable),
    .pwrite  (my_apb_if.pwrite),
    .paddr   (my_apb_if.paddr),
    .pwdata  (my_apb_if.pwdata),
    .prdata  (my_apb_if.prdata),
    .pready  (my_apb_if.pready),
    .pslverr (my_apb_if.pslverr)
  );
  
  initial begin
    presetn = 0;
    repeat(5) @(posedge pclk);
    presetn = 1;
  end
  
  test t;
  initial begin
    t = new(my_apb_if);
    
    wait(presetn == 1);
    repeat(2) @(posedge pclk);
    
    //$display("=== APB_ALU SV TB: Directed (smoke) ===");
    //t.run_directed();
    //$display("=== APB_ALU SV TB: PASS (Directed) ===");
    $display("=== APB_ALU SV TB: Random ===");
    t.run_random();
    $display("=== APB_ALU SV TB: PASS ===");
    $finish;
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, tb_top);
  end
endmodule
