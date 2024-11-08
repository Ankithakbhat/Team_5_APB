class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)

   apb_env env;

   function new(string name = "apb_test", uvm_component parent = null);
   	super.new(name,parent);
   endfunction: new


  virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = apb_env::type_id::create("env",this);
  endfunction: build_phase


  virtual function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
	uvm_top.print_topology();
  endfunction: end_of_elaboration_phase


  function void report_phase(uvm_phase phase);
	uvm_report_server svr;
	super.report_phase(phase);
	svr = uvm_report_server::get_server();
        if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
			`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
			`uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
			`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
		end
		else begin
			`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
			`uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
			`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
		end
		`uvm_info("ALU_TEST","Inside alu_test REPORT_PHASE",UVM_HIGH)
  endfunction: report_phase

endclass:apb_test 
