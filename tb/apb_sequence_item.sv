import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines.svh"

class apb_seq_item extends uvm_sequence_item;
  rand bit [`AW-1:0] i_paddr;  // Address 
  rand bit          i_pwrite;  // Write enable
  bit               i_psel;  // Select
  bit               i_penable;  // Enable
  rand bit [`DW-1:0] i_pwdata;  // Write data
  rand bit [`SW-1:0] i_pstrb;  // Write strobe
  bit [`DW-1:0]     o_prdata;  // Read data
  bit               o_pslverr;  // Slave error
  bit               o_pready;  // Ready

  //-------register seq_item with tthe uvm factory----------

  `uvm_object_utils_begin(apb_seq_item)
    `uvm_field_int(i_paddr, UVM_ALL_ON)
    `uvm_field_int(i_pwrite, UVM_ALL_ON)
    `uvm_field_int(i_psel, UVM_ALL_ON)
    `uvm_field_int(i_penable, UVM_ALL_ON)
    `uvm_field_int(i_pwdata, UVM_ALL_ON)
    `uvm_field_int(i_pstrb, UVM_ALL_ON)
    `uvm_field_int(o_prdata, UVM_ALL_ON)
    `uvm_field_int(o_pslverr, UVM_ALL_ON)
    `uvm_field_int(o_pready, UVM_ALL_ON)
  `uvm_object_utils_end

  //--------class constructor-------------

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction : new

  //--------general constraints-----------

  constraint addr {i_paddr inside {[0:20]};}
  constraint write {i_pwrite inside {0,1};}
  constraint sel {i_psel inside {0,1};}
  constraint enable {i_penable inside {0,1};}
  constraint wdata {i_pwdata inside {[0:500]};}

  endclass