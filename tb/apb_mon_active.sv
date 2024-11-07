`include "uvm_macros.svh"
import uvm_pkg::*;
`include "apb_sequence_item.sv"
class apb_active_monitor extends uvm_monitor;
   `uvm_component_utils(apb_active_monitor)

   // Variables
   virtual apb_if vif;  // Virtual interface for active monitoring

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
      if (!uvm_config_db#(virtual apb_if)::get(this, "*", "vif", vif))
         `uvm_fatal(get_name(), "Cannot get virtual interface");
   endfunction

   // Task: run_phase
   task run_phase(uvm_phase phase);
      `uvm_info("APB_ACTIVE_MONITOR", "Inside run phase of APB Active Monitor", UVM_LOW)

      forever begin
         @(posedge vif.pclk);  // Monitor on every clock cycle

         // Capture APB transaction when `psel` is high (i.e., transaction active)
         if (vif.psel) begin
            trans = apb_seq_item::type_id::create("trans");

            // Capture **APB input signals** provided to the APB Slave
            trans.i_paddr    = vif.i_paddr;    // Address
            trans.i_pwrite   = vif.i_pwrite;   // Write enable
            trans.i_psel     = vif.i_psel;       // Select signal
            trans.i_penable  = vif.i_penable;    // Enable signal
            trans.i_pwdata   = vif.i_pwdata;   // Write data
            trans.i_pstrb    = vif.i_pstrb;    // Write strobe

            // Capture **hardware interface input signal**
          //  trans.i_hw_sts   = vif.i_hw_sts;   // Status signal from HW to APB registers

            // Write the transaction to the analysis port
            item_collected_port.write(trans);

            // Log and print captured transaction
            `uvm_info("APB_ACTIVE_MONITOR", $sformatf("Sampled input transaction with HW status: %s", trans.convert2string()), UVM_MEDIUM)
            trans.print();
         end
      end
   endtask

endclass

