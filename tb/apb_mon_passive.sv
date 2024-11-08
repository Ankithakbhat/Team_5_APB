`include "uvm_macros.svh"
import uvm_pkg::*;
`include "apb_sequence_item.sv"
class apb_passive_monitor extends uvm_monitor;
   `uvm_component_utils(apb_passive_monitor)

   // Variables
   virtual apb_intrf vif;  // Virtual interface for passive monitoring

   uvm_analysis_port#(apb_seq_item) item_collected_port;  // Analysis port to pass collected items
   apb_seq_item trans;  // Transaction item for APB signals

   // Constructor
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   // Function: build_phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      item_collected_port = new("item_collected_port", this);
      if (!uvm_config_db#(virtual apb_intrf)::get(this, "*", "vif", vif))
         `uvm_fatal(get_name(), "Cannot get virtual interface");
   endfunction

   // Task: run_phase
   task run_phase(uvm_phase phase);
      `uvm_info("APB_PASSIVE_MONITOR", "Inside run phase of APB Passive Monitor", UVM_LOW)

      forever begin
         @(posedge vif.pclk);  // Monitor on every clock cycle

         // Capture when `psel` is high (i.e., an APB transaction is happening)
         if (vif.psel) begin
            trans = apb_seq_item::type_id::create("trans");

            // Capture **APB output signals** from the APB Slave
            trans.o_prdata   = vif.o_prdata;   // Capturing read data
            trans.o_pslverr  = vif.o_pslverr;  // Capturing slave error
            trans.o_pready   = vif.o_pready;   // Capturing ready signal

            // Capture **hardware interface signal**
           // trans.o_hw_ctl   = vif.o_hw_ctl;   // Capturing hardware control signal from APB registers

            // Write the transaction to the analysis port
            item_collected_port.write(trans);

            // Log and print captured transaction
            `uvm_info("APB_PASSIVE_MONITOR", $sformatf("Sampled output transaction with HW interface: %s", trans.convert2string()), UVM_MEDIUM)
            trans.print();
         end
      end
   endtask

endclass

