class apb_read_error_test extends apb_test;

	//Factory Registration
	`uvm_component_utils(apb_read_error_test)

	//Sequence handle
	apb_read_error seq1;

	//constructor
	function new(strinf name="apb_read_error_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction: new

	//Build Phase
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//create sequence
		seq1=apb_read_error::type_id::create(seq1);
		`uvm_info("apb_read_error_test","Inside apb_read_error_test BUILD_PHASE",UVM_HIGH)
	endfunction: build_phase

	//Run Phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		phase.raise_objection(this);
		
		`uvm_info("SEQUENCE","\n----------------------------!!! READ BEGINS !!!-------------------------------\n",UVM_LOW)
		seq1.start(env.agent_a.sequencer);
		`uvm_info("SEQUENCE","\n----------------------------!!! READ ENDS !!!----------------------------------\n",UVM_LOW)
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this,50);
	endtask : run_phase
	
endclass
