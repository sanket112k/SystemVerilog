interface fa_if(input logic clk);
  logic a;
  logic b;
  logic cin;
  logic sum;
  logic cout;
  
  clocking drv_cb @(posedge clk);
    default input #1step output #0;
    output a, b, cin;
    input  sum, cout;
  endclocking
  
  clocking mon_cb @(posedge clk);
    default input #1step output #0;
    input a, b, cin, sum, cout;
  endclocking
  
  modport drv_mp (clocking drv_cb, input clk);
  modport mon_mp (clocking mon_cb, input clk);
endinterface
