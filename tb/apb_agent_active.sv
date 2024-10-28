class apb_agent_active extends uvm_agent;
    `uvm_component_utils("apb_agent_active")

    //component instances
    apb_driver drv;
    apb_sequencer sequencer;
    apb_mon_active mon_a;

    //constructor
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    //build phase
    function void build_phase(uvm_phase phase);
        `uvm_info("AGENT_ACTIVE","Inside Build_phase of apb active agent",UVM_HIGH);

        drv= apb_driver :: type_id :: create("drv",this);
        sequencer= apb_sequencer :: type_id :: create("sequencer",this);
        mon_a = apb_mon_active :: type_id :: create ("mon_a",this);

    endfunction : build_phase

    //connect phase
    function void connect_phase(uvm_phase phase);
        `uvm_info("AGENT_ACTIVE","Inside Connect phase of apb active agent",UVM_HIGH);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase

endclass : apb_agent_active 
