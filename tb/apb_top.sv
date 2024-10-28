import uvm_pkg::*;
`include "uvm_macros.svh"
`include "apb_pkg.sv"

module top();
  logic pclk;
  logic presetn;
  
  always #5 pclk = !pclk;
  initial begin
    pclk = 0;
    presetn = 0;
    #10;
    presetn = 1;
  end

  apb_intrf inf(pclk, presetn);

  //-----instantiate design---------

  apb_slave (32,5) dut(
   .pclk(inf.pclk),    
   .presetn(inf.presetn), 
   .i_paddr(inf.i_paddr),   
   .i_pwrite(inf.i_pwrite), 
   .i_psel(inf.i_psel),   
   .i_penable(inf.i_penable),
   .i_pwdata(inf.i_pwdata), 
   .i_pstrb(inf.i_pstrb),  
   .o_prdata(inf.o_prdata), 
   .o_pslverr(inf.o_pslverr),
   .o_pready(inf.o_pready), 

   .o_hw_ctl(inf.o_hw_ctl), 
   .i_hw_sts(inf.i_hw_sts) 
  );

  initial begin
    uvm_config_db #(virtual apb_intrf)::set(null,"*","vif",inf);
  end

  intial begin
    run_test();
  end


