`include "tb_pkg.sv"
`include "interface.sv"
`include "test.sv"

module tb_top;
  import tb_pkg::*;
  
  logic clk = 0;
  always #5 clk = ~clk;
  
  fifo_if vif(clk);
  
  synchronous_fifo #(
    .DEPTH     (DEPTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) sfifo(
    .clk     (clk),
    .resetn  (vif.resetn),
    .w_en    (vif.w_en),
    .r_en    (vif.r_en),
    .data_in (vif.data_in),
    .data_out(vif.data_out),
    .full    (vif.full),
    .empty   (vif.empty)
  );
  
  test t;
  
  initial begin
    t = new(vif);
    t.run();
  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars;
  end
endmodule

/*
[0] GEN:        resetn=0 w_en=0 r_en=1 data_in=e046565 data_out=0 full=0 empty=0
[0] GEN:        resetn=0 w_en=1 r_en=1 data_in=e34649ed data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=4209c006 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=ec3aa5fb data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=2332e42e data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=628fdbf5 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=835625b5 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=3182cc4c data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=39ffaf6 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=f8cb6e12 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=5b2677fe data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=715e83ec data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=5500898f data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=f6b7e3b6 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=fce4ffed data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=5567ad73 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=e9b3e8e data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=837fc821 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=a1b67c0b data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=560dd136 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=e943d4e data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=4c3f4a10 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=983d0a84 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=549569e0 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=71d47407 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=9bb0d47f data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=46c30cd3 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=d358e62e data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=f6bed393 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=b0cb4693 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=8575b00b data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=322f435d data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=cad781fa data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=0 data_in=ecf40f4a data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=a0ae35ae data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=fa06b2db data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=324bd7c data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=ac919d24 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=a7796144 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=a5fefb9 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=e1e7554 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=2351f3c6 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=c67a7999 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=689b7df5 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=f09871f3 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=c0e2eaed data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=f9ad9bfb data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=9c6512d0 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=7c8d95ac data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=ca8ea956 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=8e019f5 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=d56343b4 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=4da696e9 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=a33f8de2 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=715ea0d5 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=3fc47150 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=351ebdea data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=34e46588 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=4fd89d22 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=54037b80 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=e1d0741f data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=bf45b6d4 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=b570ed9e data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=f733d52b data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=dfeedefa data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=0 r_en=1 data_in=c2ac6a48 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=1 data_in=b8ad5842 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=1 data_in=aa04a422 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=1 data_in=5aec0dae data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=1 data_in=4fc40c70 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=1 data_in=125a2fa4 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=1 data_in=f790b585 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=1 data_in=cf0fc9a9 data_out=0 full=0 empty=0
[0] GEN:        resetn=1 w_en=1 r_en=1 data_in=571f607 data_out=0 full=0 empty=0
==========================================
[0] DRV:        resetn=0 w_en=0 r_en=1 data_in=e046565 data_out=0 full=0 empty=0
[5] DRV:        resetn=0 w_en=1 r_en=1 data_in=e34649ed data_out=0 full=0 empty=0
[15] DRV:        resetn=1 w_en=1 r_en=0 data_in=4209c006 data_out=0 full=0 empty=0
[15] MON:        resetn=0 w_en=0 r_en=1 data_in=e046565 data_out=0 full=0 empty=1
[15] SCB: {PASS} resetn=0 w_en=0 r_en=1 data_in=e046565 data_out=0 full=0 empty=1
--------------------------------------------
[25] DRV:        resetn=1 w_en=1 r_en=0 data_in=ec3aa5fb data_out=0 full=0 empty=0
[25] MON:        resetn=0 w_en=1 r_en=1 data_in=e34649ed data_out=0 full=0 empty=1
[25] SCB: {PASS} resetn=0 w_en=1 r_en=1 data_in=e34649ed data_out=0 full=0 empty=1
--------------------------------------------
[35] DRV:        resetn=1 w_en=1 r_en=0 data_in=2332e42e data_out=0 full=0 empty=0
[35] MON:        resetn=1 w_en=1 r_en=0 data_in=4209c006 data_out=0 full=0 empty=0
[35] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=4209c006 data_out=0 full=0 empty=0
--------------------------------------------
[45] DRV:        resetn=1 w_en=1 r_en=0 data_in=628fdbf5 data_out=0 full=0 empty=0
[45] MON:        resetn=1 w_en=1 r_en=0 data_in=ec3aa5fb data_out=0 full=0 empty=0
[45] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=ec3aa5fb data_out=0 full=0 empty=0
--------------------------------------------
[55] DRV:        resetn=1 w_en=1 r_en=0 data_in=835625b5 data_out=0 full=0 empty=0
[55] MON:        resetn=1 w_en=1 r_en=0 data_in=2332e42e data_out=0 full=0 empty=0
[55] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=2332e42e data_out=0 full=0 empty=0
--------------------------------------------
[65] DRV:        resetn=1 w_en=1 r_en=0 data_in=3182cc4c data_out=0 full=0 empty=0
[65] MON:        resetn=1 w_en=1 r_en=0 data_in=628fdbf5 data_out=0 full=0 empty=0
[65] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=628fdbf5 data_out=0 full=0 empty=0
--------------------------------------------
[75] DRV:        resetn=1 w_en=1 r_en=0 data_in=39ffaf6 data_out=0 full=0 empty=0
[75] MON:        resetn=1 w_en=1 r_en=0 data_in=835625b5 data_out=0 full=0 empty=0
[75] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=835625b5 data_out=0 full=0 empty=0
--------------------------------------------
[85] DRV:        resetn=1 w_en=1 r_en=0 data_in=f8cb6e12 data_out=0 full=0 empty=0
[85] MON:        resetn=1 w_en=1 r_en=0 data_in=3182cc4c data_out=0 full=0 empty=0
[85] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=3182cc4c data_out=0 full=0 empty=0
--------------------------------------------
[95] DRV:        resetn=1 w_en=1 r_en=0 data_in=5b2677fe data_out=0 full=0 empty=0
[95] MON:        resetn=1 w_en=1 r_en=0 data_in=39ffaf6 data_out=0 full=0 empty=0
[95] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=39ffaf6 data_out=0 full=0 empty=0
--------------------------------------------
[105] DRV:        resetn=1 w_en=1 r_en=0 data_in=715e83ec data_out=0 full=0 empty=0
[105] MON:        resetn=1 w_en=1 r_en=0 data_in=f8cb6e12 data_out=0 full=0 empty=0
[105] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=f8cb6e12 data_out=0 full=0 empty=0
--------------------------------------------
[115] DRV:        resetn=1 w_en=1 r_en=0 data_in=5500898f data_out=0 full=0 empty=0
[115] MON:        resetn=1 w_en=1 r_en=0 data_in=5b2677fe data_out=0 full=0 empty=0
[115] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=5b2677fe data_out=0 full=0 empty=0
--------------------------------------------
[125] DRV:        resetn=1 w_en=1 r_en=0 data_in=f6b7e3b6 data_out=0 full=0 empty=0
[125] MON:        resetn=1 w_en=1 r_en=0 data_in=715e83ec data_out=0 full=0 empty=0
[125] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=715e83ec data_out=0 full=0 empty=0
--------------------------------------------
[135] DRV:        resetn=1 w_en=1 r_en=0 data_in=fce4ffed data_out=0 full=0 empty=0
[135] MON:        resetn=1 w_en=1 r_en=0 data_in=5500898f data_out=0 full=0 empty=0
[135] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=5500898f data_out=0 full=0 empty=0
--------------------------------------------
[145] DRV:        resetn=1 w_en=1 r_en=0 data_in=5567ad73 data_out=0 full=0 empty=0
[145] MON:        resetn=1 w_en=1 r_en=0 data_in=f6b7e3b6 data_out=0 full=0 empty=0
[145] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=f6b7e3b6 data_out=0 full=0 empty=0
--------------------------------------------
[155] DRV:        resetn=1 w_en=1 r_en=0 data_in=e9b3e8e data_out=0 full=0 empty=0
[155] MON:        resetn=1 w_en=1 r_en=0 data_in=fce4ffed data_out=0 full=0 empty=0
[155] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=fce4ffed data_out=0 full=0 empty=0
--------------------------------------------
[165] DRV:        resetn=1 w_en=1 r_en=0 data_in=837fc821 data_out=0 full=0 empty=0
[165] MON:        resetn=1 w_en=1 r_en=0 data_in=5567ad73 data_out=0 full=0 empty=0
[165] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=5567ad73 data_out=0 full=0 empty=0
--------------------------------------------
[175] DRV:        resetn=1 w_en=1 r_en=0 data_in=a1b67c0b data_out=0 full=0 empty=0
[175] MON:        resetn=1 w_en=1 r_en=0 data_in=e9b3e8e data_out=0 full=0 empty=0
[175] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=e9b3e8e data_out=0 full=0 empty=0
--------------------------------------------
[185] DRV:        resetn=1 w_en=1 r_en=0 data_in=560dd136 data_out=0 full=0 empty=0
[185] MON:        resetn=1 w_en=1 r_en=0 data_in=837fc821 data_out=0 full=0 empty=0
[185] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=837fc821 data_out=0 full=0 empty=0
--------------------------------------------
[195] DRV:        resetn=1 w_en=1 r_en=0 data_in=e943d4e data_out=0 full=0 empty=0
[195] MON:        resetn=1 w_en=1 r_en=0 data_in=a1b67c0b data_out=0 full=0 empty=0
[195] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=a1b67c0b data_out=0 full=0 empty=0
--------------------------------------------
[205] DRV:        resetn=1 w_en=1 r_en=0 data_in=4c3f4a10 data_out=0 full=0 empty=0
[205] MON:        resetn=1 w_en=1 r_en=0 data_in=560dd136 data_out=0 full=0 empty=0
[205] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=560dd136 data_out=0 full=0 empty=0
--------------------------------------------
[215] DRV:        resetn=1 w_en=1 r_en=0 data_in=983d0a84 data_out=0 full=0 empty=0
[215] MON:        resetn=1 w_en=1 r_en=0 data_in=e943d4e data_out=0 full=0 empty=0
[215] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=e943d4e data_out=0 full=0 empty=0
--------------------------------------------
[225] DRV:        resetn=1 w_en=1 r_en=0 data_in=549569e0 data_out=0 full=0 empty=0
[225] MON:        resetn=1 w_en=1 r_en=0 data_in=4c3f4a10 data_out=0 full=0 empty=0
[225] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=4c3f4a10 data_out=0 full=0 empty=0
--------------------------------------------
[235] DRV:        resetn=1 w_en=1 r_en=0 data_in=71d47407 data_out=0 full=0 empty=0
[235] MON:        resetn=1 w_en=1 r_en=0 data_in=983d0a84 data_out=0 full=0 empty=0
[235] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=983d0a84 data_out=0 full=0 empty=0
--------------------------------------------
[245] DRV:        resetn=1 w_en=1 r_en=0 data_in=9bb0d47f data_out=0 full=0 empty=0
[245] MON:        resetn=1 w_en=1 r_en=0 data_in=549569e0 data_out=0 full=0 empty=0
[245] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=549569e0 data_out=0 full=0 empty=0
--------------------------------------------
[255] DRV:        resetn=1 w_en=1 r_en=0 data_in=46c30cd3 data_out=0 full=0 empty=0
[255] MON:        resetn=1 w_en=1 r_en=0 data_in=71d47407 data_out=0 full=0 empty=0
[255] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=71d47407 data_out=0 full=0 empty=0
--------------------------------------------
[265] DRV:        resetn=1 w_en=1 r_en=0 data_in=d358e62e data_out=0 full=0 empty=0
[265] MON:        resetn=1 w_en=1 r_en=0 data_in=9bb0d47f data_out=0 full=0 empty=0
[265] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=9bb0d47f data_out=0 full=0 empty=0
--------------------------------------------
[275] DRV:        resetn=1 w_en=1 r_en=0 data_in=f6bed393 data_out=0 full=0 empty=0
[275] MON:        resetn=1 w_en=1 r_en=0 data_in=46c30cd3 data_out=0 full=0 empty=0
[275] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=46c30cd3 data_out=0 full=0 empty=0
--------------------------------------------
[285] DRV:        resetn=1 w_en=1 r_en=0 data_in=b0cb4693 data_out=0 full=0 empty=0
[285] MON:        resetn=1 w_en=1 r_en=0 data_in=d358e62e data_out=0 full=0 empty=0
[285] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=d358e62e data_out=0 full=0 empty=0
--------------------------------------------
[295] DRV:        resetn=1 w_en=1 r_en=0 data_in=8575b00b data_out=0 full=0 empty=0
[295] MON:        resetn=1 w_en=1 r_en=0 data_in=f6bed393 data_out=0 full=0 empty=0
[295] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=f6bed393 data_out=0 full=0 empty=0
--------------------------------------------
[305] DRV:        resetn=1 w_en=1 r_en=0 data_in=322f435d data_out=0 full=0 empty=0
[305] MON:        resetn=1 w_en=1 r_en=0 data_in=b0cb4693 data_out=0 full=0 empty=0
[305] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=b0cb4693 data_out=0 full=0 empty=0
--------------------------------------------
[315] DRV:        resetn=1 w_en=1 r_en=0 data_in=cad781fa data_out=0 full=0 empty=0
[315] MON:        resetn=1 w_en=1 r_en=0 data_in=8575b00b data_out=0 full=0 empty=0
[315] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=8575b00b data_out=0 full=0 empty=0
--------------------------------------------
[325] DRV:        resetn=1 w_en=1 r_en=0 data_in=ecf40f4a data_out=0 full=0 empty=0
[325] MON:        resetn=1 w_en=1 r_en=0 data_in=322f435d data_out=0 full=0 empty=0
[325] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=322f435d data_out=0 full=0 empty=0
--------------------------------------------
[335] DRV:        resetn=1 w_en=0 r_en=1 data_in=a0ae35ae data_out=0 full=0 empty=0
[335] MON:        resetn=1 w_en=1 r_en=0 data_in=cad781fa data_out=0 full=0 empty=0
[335] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=cad781fa data_out=0 full=0 empty=0
--------------------------------------------
[345] DRV:        resetn=1 w_en=0 r_en=1 data_in=fa06b2db data_out=0 full=0 empty=0
[345] MON:        resetn=1 w_en=1 r_en=0 data_in=ecf40f4a data_out=0 full=1 empty=0
[345] SCB: {PASS} resetn=1 w_en=1 r_en=0 data_in=ecf40f4a data_out=0 full=1 empty=0
--------------------------------------------
[355] DRV:        resetn=1 w_en=0 r_en=1 data_in=324bd7c data_out=0 full=0 empty=0
[355] MON:        resetn=1 w_en=0 r_en=1 data_in=a0ae35ae data_out=4209c006 full=0 empty=0
[355] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=a0ae35ae data_out=4209c006 full=0 empty=0
--------------------------------------------
[365] DRV:        resetn=1 w_en=0 r_en=1 data_in=ac919d24 data_out=0 full=0 empty=0
[365] MON:        resetn=1 w_en=0 r_en=1 data_in=fa06b2db data_out=ec3aa5fb full=0 empty=0
[365] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=fa06b2db data_out=ec3aa5fb full=0 empty=0
--------------------------------------------
[375] DRV:        resetn=1 w_en=0 r_en=1 data_in=a7796144 data_out=0 full=0 empty=0
[375] MON:        resetn=1 w_en=0 r_en=1 data_in=324bd7c data_out=2332e42e full=0 empty=0
[375] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=324bd7c data_out=2332e42e full=0 empty=0
--------------------------------------------
[385] DRV:        resetn=1 w_en=0 r_en=1 data_in=a5fefb9 data_out=0 full=0 empty=0
[385] MON:        resetn=1 w_en=0 r_en=1 data_in=ac919d24 data_out=628fdbf5 full=0 empty=0
[385] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=ac919d24 data_out=628fdbf5 full=0 empty=0
--------------------------------------------
[395] DRV:        resetn=1 w_en=0 r_en=1 data_in=e1e7554 data_out=0 full=0 empty=0
[395] MON:        resetn=1 w_en=0 r_en=1 data_in=a7796144 data_out=835625b5 full=0 empty=0
[395] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=a7796144 data_out=835625b5 full=0 empty=0
--------------------------------------------
[405] DRV:        resetn=1 w_en=0 r_en=1 data_in=2351f3c6 data_out=0 full=0 empty=0
[405] MON:        resetn=1 w_en=0 r_en=1 data_in=a5fefb9 data_out=3182cc4c full=0 empty=0
[405] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=a5fefb9 data_out=3182cc4c full=0 empty=0
--------------------------------------------
[415] DRV:        resetn=1 w_en=0 r_en=1 data_in=c67a7999 data_out=0 full=0 empty=0
[415] MON:        resetn=1 w_en=0 r_en=1 data_in=e1e7554 data_out=39ffaf6 full=0 empty=0
[415] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=e1e7554 data_out=39ffaf6 full=0 empty=0
--------------------------------------------
[425] DRV:        resetn=1 w_en=0 r_en=1 data_in=689b7df5 data_out=0 full=0 empty=0
[425] MON:        resetn=1 w_en=0 r_en=1 data_in=2351f3c6 data_out=f8cb6e12 full=0 empty=0
[425] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=2351f3c6 data_out=f8cb6e12 full=0 empty=0
--------------------------------------------
[435] DRV:        resetn=1 w_en=0 r_en=1 data_in=f09871f3 data_out=0 full=0 empty=0
[435] MON:        resetn=1 w_en=0 r_en=1 data_in=c67a7999 data_out=5b2677fe full=0 empty=0
[435] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=c67a7999 data_out=5b2677fe full=0 empty=0
--------------------------------------------
[445] DRV:        resetn=1 w_en=0 r_en=1 data_in=c0e2eaed data_out=0 full=0 empty=0
[445] MON:        resetn=1 w_en=0 r_en=1 data_in=689b7df5 data_out=715e83ec full=0 empty=0
[445] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=689b7df5 data_out=715e83ec full=0 empty=0
--------------------------------------------
[455] DRV:        resetn=1 w_en=0 r_en=1 data_in=f9ad9bfb data_out=0 full=0 empty=0
[455] MON:        resetn=1 w_en=0 r_en=1 data_in=f09871f3 data_out=5500898f full=0 empty=0
[455] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=f09871f3 data_out=5500898f full=0 empty=0
--------------------------------------------
[465] DRV:        resetn=1 w_en=0 r_en=1 data_in=9c6512d0 data_out=0 full=0 empty=0
[465] MON:        resetn=1 w_en=0 r_en=1 data_in=c0e2eaed data_out=f6b7e3b6 full=0 empty=0
[465] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=c0e2eaed data_out=f6b7e3b6 full=0 empty=0
--------------------------------------------
[475] DRV:        resetn=1 w_en=0 r_en=1 data_in=7c8d95ac data_out=0 full=0 empty=0
[475] MON:        resetn=1 w_en=0 r_en=1 data_in=f9ad9bfb data_out=fce4ffed full=0 empty=0
[475] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=f9ad9bfb data_out=fce4ffed full=0 empty=0
--------------------------------------------
[485] DRV:        resetn=1 w_en=0 r_en=1 data_in=ca8ea956 data_out=0 full=0 empty=0
[485] MON:        resetn=1 w_en=0 r_en=1 data_in=9c6512d0 data_out=5567ad73 full=0 empty=0
[485] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=9c6512d0 data_out=5567ad73 full=0 empty=0
--------------------------------------------
[495] DRV:        resetn=1 w_en=0 r_en=1 data_in=8e019f5 data_out=0 full=0 empty=0
[495] MON:        resetn=1 w_en=0 r_en=1 data_in=7c8d95ac data_out=e9b3e8e full=0 empty=0
[495] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=7c8d95ac data_out=e9b3e8e full=0 empty=0
--------------------------------------------
[505] DRV:        resetn=1 w_en=0 r_en=1 data_in=d56343b4 data_out=0 full=0 empty=0
[505] MON:        resetn=1 w_en=0 r_en=1 data_in=ca8ea956 data_out=837fc821 full=0 empty=0
[505] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=ca8ea956 data_out=837fc821 full=0 empty=0
--------------------------------------------
[515] DRV:        resetn=1 w_en=0 r_en=1 data_in=4da696e9 data_out=0 full=0 empty=0
[515] MON:        resetn=1 w_en=0 r_en=1 data_in=8e019f5 data_out=a1b67c0b full=0 empty=0
[515] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=8e019f5 data_out=a1b67c0b full=0 empty=0
--------------------------------------------
[525] DRV:        resetn=1 w_en=0 r_en=1 data_in=a33f8de2 data_out=0 full=0 empty=0
[525] MON:        resetn=1 w_en=0 r_en=1 data_in=d56343b4 data_out=560dd136 full=0 empty=0
[525] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=d56343b4 data_out=560dd136 full=0 empty=0
--------------------------------------------
[535] DRV:        resetn=1 w_en=0 r_en=1 data_in=715ea0d5 data_out=0 full=0 empty=0
[535] MON:        resetn=1 w_en=0 r_en=1 data_in=4da696e9 data_out=e943d4e full=0 empty=0
[535] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=4da696e9 data_out=e943d4e full=0 empty=0
--------------------------------------------
[545] DRV:        resetn=1 w_en=0 r_en=1 data_in=3fc47150 data_out=0 full=0 empty=0
[545] MON:        resetn=1 w_en=0 r_en=1 data_in=a33f8de2 data_out=4c3f4a10 full=0 empty=0
[545] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=a33f8de2 data_out=4c3f4a10 full=0 empty=0
--------------------------------------------
[555] DRV:        resetn=1 w_en=0 r_en=1 data_in=351ebdea data_out=0 full=0 empty=0
[555] MON:        resetn=1 w_en=0 r_en=1 data_in=715ea0d5 data_out=983d0a84 full=0 empty=0
[555] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=715ea0d5 data_out=983d0a84 full=0 empty=0
--------------------------------------------
[565] DRV:        resetn=1 w_en=0 r_en=1 data_in=34e46588 data_out=0 full=0 empty=0
[565] MON:        resetn=1 w_en=0 r_en=1 data_in=3fc47150 data_out=549569e0 full=0 empty=0
[565] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=3fc47150 data_out=549569e0 full=0 empty=0
--------------------------------------------
[575] DRV:        resetn=1 w_en=0 r_en=1 data_in=4fd89d22 data_out=0 full=0 empty=0
[575] MON:        resetn=1 w_en=0 r_en=1 data_in=351ebdea data_out=71d47407 full=0 empty=0
[575] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=351ebdea data_out=71d47407 full=0 empty=0
--------------------------------------------
[585] DRV:        resetn=1 w_en=0 r_en=1 data_in=54037b80 data_out=0 full=0 empty=0
[585] MON:        resetn=1 w_en=0 r_en=1 data_in=34e46588 data_out=9bb0d47f full=0 empty=0
[585] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=34e46588 data_out=9bb0d47f full=0 empty=0
--------------------------------------------
[595] DRV:        resetn=1 w_en=0 r_en=1 data_in=e1d0741f data_out=0 full=0 empty=0
[595] MON:        resetn=1 w_en=0 r_en=1 data_in=4fd89d22 data_out=46c30cd3 full=0 empty=0
[595] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=4fd89d22 data_out=46c30cd3 full=0 empty=0
--------------------------------------------
[605] DRV:        resetn=1 w_en=0 r_en=1 data_in=bf45b6d4 data_out=0 full=0 empty=0
[605] MON:        resetn=1 w_en=0 r_en=1 data_in=54037b80 data_out=d358e62e full=0 empty=0
[605] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=54037b80 data_out=d358e62e full=0 empty=0
--------------------------------------------
[615] DRV:        resetn=1 w_en=0 r_en=1 data_in=b570ed9e data_out=0 full=0 empty=0
[615] MON:        resetn=1 w_en=0 r_en=1 data_in=e1d0741f data_out=f6bed393 full=0 empty=0
[615] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=e1d0741f data_out=f6bed393 full=0 empty=0
--------------------------------------------
[625] DRV:        resetn=1 w_en=0 r_en=1 data_in=f733d52b data_out=0 full=0 empty=0
[625] MON:        resetn=1 w_en=0 r_en=1 data_in=bf45b6d4 data_out=b0cb4693 full=0 empty=0
[625] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=bf45b6d4 data_out=b0cb4693 full=0 empty=0
--------------------------------------------
[635] DRV:        resetn=1 w_en=0 r_en=1 data_in=dfeedefa data_out=0 full=0 empty=0
[635] MON:        resetn=1 w_en=0 r_en=1 data_in=b570ed9e data_out=8575b00b full=0 empty=0
[635] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=b570ed9e data_out=8575b00b full=0 empty=0
--------------------------------------------
[645] DRV:        resetn=1 w_en=0 r_en=1 data_in=c2ac6a48 data_out=0 full=0 empty=0
[645] MON:        resetn=1 w_en=0 r_en=1 data_in=f733d52b data_out=322f435d full=0 empty=0
[645] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=f733d52b data_out=322f435d full=0 empty=0
--------------------------------------------
[655] DRV:        resetn=1 w_en=1 r_en=1 data_in=b8ad5842 data_out=0 full=0 empty=0
[655] MON:        resetn=1 w_en=0 r_en=1 data_in=dfeedefa data_out=cad781fa full=0 empty=0
[655] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=dfeedefa data_out=cad781fa full=0 empty=0
--------------------------------------------
[665] DRV:        resetn=1 w_en=1 r_en=1 data_in=aa04a422 data_out=0 full=0 empty=0
[665] MON:        resetn=1 w_en=0 r_en=1 data_in=c2ac6a48 data_out=ecf40f4a full=0 empty=1
[665] SCB: {PASS} resetn=1 w_en=0 r_en=1 data_in=c2ac6a48 data_out=ecf40f4a full=0 empty=1
--------------------------------------------
[675] DRV:        resetn=1 w_en=1 r_en=1 data_in=5aec0dae data_out=0 full=0 empty=0
[675] MON:        resetn=1 w_en=1 r_en=1 data_in=b8ad5842 data_out=ecf40f4a full=0 empty=0
[675] SCB: {PASS} resetn=1 w_en=1 r_en=1 data_in=b8ad5842 data_out=ecf40f4a full=0 empty=0
--------------------------------------------
[685] DRV:        resetn=1 w_en=1 r_en=1 data_in=4fc40c70 data_out=0 full=0 empty=0
[685] MON:        resetn=1 w_en=1 r_en=1 data_in=aa04a422 data_out=b8ad5842 full=0 empty=0
[685] SCB: {PASS} resetn=1 w_en=1 r_en=1 data_in=aa04a422 data_out=b8ad5842 full=0 empty=0
--------------------------------------------
[695] DRV:        resetn=1 w_en=1 r_en=1 data_in=125a2fa4 data_out=0 full=0 empty=0
[695] MON:        resetn=1 w_en=1 r_en=1 data_in=5aec0dae data_out=aa04a422 full=0 empty=0
[695] SCB: {PASS} resetn=1 w_en=1 r_en=1 data_in=5aec0dae data_out=aa04a422 full=0 empty=0
--------------------------------------------
[705] DRV:        resetn=1 w_en=1 r_en=1 data_in=f790b585 data_out=0 full=0 empty=0
[705] MON:        resetn=1 w_en=1 r_en=1 data_in=4fc40c70 data_out=5aec0dae full=0 empty=0
[705] SCB: {PASS} resetn=1 w_en=1 r_en=1 data_in=4fc40c70 data_out=5aec0dae full=0 empty=0
--------------------------------------------
[715] DRV:        resetn=1 w_en=1 r_en=1 data_in=cf0fc9a9 data_out=0 full=0 empty=0
[715] MON:        resetn=1 w_en=1 r_en=1 data_in=125a2fa4 data_out=4fc40c70 full=0 empty=0
[715] SCB: {PASS} resetn=1 w_en=1 r_en=1 data_in=125a2fa4 data_out=4fc40c70 full=0 empty=0
--------------------------------------------
[725] DRV:        resetn=1 w_en=1 r_en=1 data_in=571f607 data_out=0 full=0 empty=0
[725] MON:        resetn=1 w_en=1 r_en=1 data_in=f790b585 data_out=125a2fa4 full=0 empty=0
[725] SCB: {PASS} resetn=1 w_en=1 r_en=1 data_in=f790b585 data_out=125a2fa4 full=0 empty=0
--------------------------------------------
[735] MON:        resetn=1 w_en=1 r_en=1 data_in=cf0fc9a9 data_out=f790b585 full=0 empty=0
[735] SCB: {PASS} resetn=1 w_en=1 r_en=1 data_in=cf0fc9a9 data_out=f790b585 full=0 empty=0
--------------------------------------------
[745] MON:        resetn=1 w_en=1 r_en=1 data_in=571f607 data_out=cf0fc9a9 full=0 empty=0
[745] SCB: {PASS} resetn=1 w_en=1 r_en=1 data_in=571f607 data_out=cf0fc9a9 full=0 empty=0
--------------------------------------------

==== REPORT ====
PASS = 74
FAIL = 0
$finish called from file "environment.sv", line 24.
$finish at simulation time                  745
*/
