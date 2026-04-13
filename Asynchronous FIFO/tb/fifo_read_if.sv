interface fifo_read_if(input logic rclk);
  import tb_pkg::*;
  
  logic 				   rreset;
  logic 				   ren;
  logic [DATA_WIDTH-1 : 0] rdata;
  logic 				   empty;
  logic 				   rvalid;
  
  clocking r_drv_cb @(posedge rclk);
    default input #1step output #0;
    output rreset, ren;
    input empty, rdata, rvalid;
  endclocking
  
  clocking r_mon_cb @(posedge rclk);
    default input #0;
    input rreset, ren;
    input empty, rdata, rvalid;
  endclocking
  
  modport r_drv_mp (clocking r_drv_cb, import task wait_clock(int n));
  modport r_mon_mp (clocking r_mon_cb);
  modport dut_mp   (input rreset, ren, output empty, rdata, rvalid);
    
  task automatic wait_clock(int n);
    repeat(n) @(posedge rclk);
  endtask
    
endinterface
