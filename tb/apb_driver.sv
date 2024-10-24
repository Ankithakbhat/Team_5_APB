class apb_driver extends uvm_driver#(apb_seq_item);
  
  //------register with the uvm factory ---------
  `uvm_component_utils(apb_driver)

  //-------class constructor ---------------
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  //----virtual interface declaration-------
  virtual apb_intrf vif;

//------get interface handel from top -------------------//
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db #(virtual alu_inf)::get(this, "*", "vif", vif)))
    `uvm_fatal("driver","unable to get interface");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();      
      end
  endtask

  task drive();

  endtask

endclass: apb_driver


