interface apb_intrf(bit pclk, bit presetn);

   //------- APB Interface signals ------------
  logic [AW-1:0] i_paddr;  // Address 
  logic          i_pwrite;  // Write enable
  logic          i_psel;  // Select
  logic          i_penable;  // Enable
  logic [DW-1:0] i_pwdata;  // Write data
  logic [SW-1:0] i_pstrb;  // Write strobe
  logic [DW-1:0] o_prdata;  // Read data
  logic          o_pslverr;  // Slave error
  logic          o_pready;  // Ready

  // HW interface
  logic o_hw_ctl;   // Some control signal from APB registers to external HW...
  logic i_hw_sts ;    // Some status signal from external HW to APB registers...

  //------Driver clocking block--------------

  clocking drv_cb@(posedge pclk or negedge presetn);
    default input #0 output #0;
    input presetn;
    output i_paddr, i_pwrite, i_psel, i_penable, i_pwdata, i_pstrb;
  endclocking

  //-----Monitor clocking block---------------

  clocking mon_cb@(posedge pclk or negedge presetn);
     default input #0 output #0;
     input i_paddr, i_pwrite, i_psel, i_penable, i_pwdata, i_pstrb, o_prdata, o_pslverr, o_pready;
  endclocking

  //-----Modport Declaration--------------------

  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);
endinterface