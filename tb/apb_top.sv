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

  apb_intrf(pclk, presetn);

  //-----instantiate design---------

  

