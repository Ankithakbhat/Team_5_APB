import uvm_pkg::*;
`include"uvm_macros.svh"
`include"apb_sequence_item.sv"

`uvm_analysis_imp_decl(_inp_mon)
`uvm_analysis_imp_decl(_out_mon)

class apb_coverage extends uvm_subscriber #(apb_seq_item);
    `uvm_component_utils(apb_coverage)

    // Input and output monitor analysis port declaration
    uvm_analysis_imp_inp_mon #(apb_seq_item, apb_coverage) inp_mon_imp;
    uvm_analysis_imp_out_mon #(apb_seq_item, apb_coverage) out_mon_imp;

    // Coverage variables
    apb_seq_item seq_item;
    real input_cov, output_cov;

    // Input coverage group
    covergroup input_cg;
        coverpoint seq_item.i_paddr {
            bins address_range[] = {[0:1023]}; // Define address range as needed
        }
        coverpoint seq_item.i_psel {
            bins selected = {1'b1};
            bins not_selected = {1'b0};
        }
        coverpoint seq_item.i_penable {
            bins enable = {1'b1};
            bins not_enable = {1'b0};
        }
        coverpoint seq_item.i_pwrite {
            bins write = {1'b1};
            bins read = {1'b0};
        }
        coverpoint seq_item.i_pwdata {
            bins data_values[] = {[0:255]}; // Adjust range if necessary
        }
        coverpoint seq_item.i_pstrb {
            bins byte_strobe[] = {[0:15]}; // Assuming a 4-bit strobe
        }
      /*  coverpoint seq_item.i_hw_sts {
            bins hw_sts_0 = {0};
           bins hw_sts_1 = {1};
        }*/
    endgroup : input_cg

    // Output coverage group
    covergroup output_cg;
        coverpoint seq_item.o_prdata {
            bins data_values[] = {[0:255]}; // Adjust data range if necessary
        }
        coverpoint seq_item.o_pslverr {
            bins error = {1'b1};
            bins no_error = {1'b0};
        }
        coverpoint seq_item.o_pready {
            bins ready = {1'b1};
            bins not_ready = {1'b0};
        }
       /* coverpoint seq_item.o_hw_ctl {
            bins hw_ctl_0 = {0};
            bins hw_ctl_1 = {1};
        }*/
    endgroup : output_cg

    // Constructor
    function new(string name = "apb_coverage", uvm_component parent = null);
        super.new(name, parent);
        inp_mon_imp = new("inp_mon_imp", this);
        out_mon_imp = new("out_mon_imp", this);
        input_cg = new();
        output_cg = new();
    endfunction: new

    // Write function for input monitor
    function void write_inp_mon(apb_seq_item inp_txn);
        seq_item = inp_txn;
        input_cg.sample();
    endfunction: write_inp_mon

    // Write function for output monitor
    function void write_out_mon(apb_seq_item op_txn);
        seq_item = op_txn;
        output_cg.sample();
    endfunction: write_out_mon

    // Override the abstract write method
    virtual function void write(apb_seq_item t);
        // Implement logic to handle incoming transactions (optional)
    endfunction: write

    // Extract phase
    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        input_cov = input_cg.get_coverage();
        output_cov = output_cg.get_coverage();
    endfunction: extract_phase

    // Report phase
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("Input Coverage is %f \nOutput Coverage is %f", input_cov, output_cov), UVM_MEDIUM)
    endfunction: report_phase

endclass: apb_coverage
