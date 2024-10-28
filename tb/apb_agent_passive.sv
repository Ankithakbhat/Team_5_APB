class apb_agent_passive extends uvm_agent;

    `uvm_component_utils(apb_agent_passive)

    // component instance
    apb_mon_passive mon_p;


    // constructor

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // build phase

    function void build_phase(uvm_phase phase);
	    `uvm_info("AGENT_PASSIVE","Inside build phase of apb passive agent",UVM_HIGH);
         mon_p = alu_mon_passive::type_id::create("mon_p",this);
    endfunction : build_phase
     
endclass : alu_agent_passive
