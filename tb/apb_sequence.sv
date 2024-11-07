//import uvm_pkg::*;
`include "apb_sequence_item.sv"
//`include "defines.svh"
class apb_sequence extends uvm_sequence #(apb_seq_item);
	
	//Factory Registration
	`uvm_object_utils(apb_sequence)

	//Create handle for sequence item
	apb_sequence req;

	//Constructor
	function new(string name="apb_sequence");
		super.new(name);
	endfunction

	//Task
	virtual task body();
		req=apb_seq_item::type_id::create("req");
		wait_for_grant();
		req.randomize();
		send_request(req);
		wait_for_item_done();
	endtask

	
endclass

class apb_write_error extends apb_sequence;

	//Factory Registration
	`uvm_object_utils(apb_write_error)
	//Constructor
	function new(string name="apb_write_error");
		super.new(name);
	endfunction

	//Task
	virtual task body();
		req = apb_seq_item ::type_id::create("req");
		wait_for_grant();
		req.randomize()with{i_pwrite == 1 ;i_paddr==`AW'h0C;};
		send_request(req);
		wait_for_item_done();
	endtask
endclass

class apb_read_error extends apb_sequence;

	//Factory Registration
	`uvm_object_utils(apb_read_error)
	//Constructor
	function new(string name="apb_read_error");
		super.new(name);
	endfunction

	//Task
	virtual task body();
		req = apb_seq_item ::type_id::create("req");
		wait_for_grant();
		req.randomize()with{i_pwrite == 0 ;i_paddr==`AW'h4;};
		send_request(req);
		wait_for_item_done();
	endtask
endclass

class apb_write extends apb_sequence;


	//Factory Registration
	`uvm_object_utils(apb_write)
	//Constructor
	function new(string name="apb_write");
		super.new(name);
	endfunction

	//Task
	virtual task body();
		req = apb_seq_item ::type_id::create("req");
		wait_for_grant();
		req.randomize()with{i_pwrite == 1 ;i_pwdata==`DW'hABCD; i_paddr== {`AW'h0,`AW'h4,`AW'h8};};
		send_request(req);
		wait_for_item_done();
	endtask
endclass

class apb_read extends apb_sequence;


	//Factory Registration
	`uvm_object_utils(apb_read)
	//Constructor
	function new(string name="apb_read");
		super.new(name);
	endfunction

	//Task
	virtual task body();
		req = apb_seq_item ::type_id::create("req");
		wait_for_grant();
		req.randomize()with{i_pwrite == 0 ;i_paddr=={`AW'h0,`AW'h8,`AW'hC};};
		send_request(req);
		wait_for_item_done();
	endtask
endclass

class apb_write_read extends apb_sequence;

	`uvm_object_utils(apb_write_read)
	function new(string name="apb_write_read");
		super.new(name);
	endfunction
	virtual task body();
		`uvm_do_with(req,{i_pwrite==0;
		    	      i_paddr=={`AW'h0,`AW'h8};})
	endtask
endclass

class apb_write_read_0 extends apb_sequence;


	//Factory Registration
	`uvm_object_utils(apb_write_read_0)
	//Constructor
	function new(string name="apb_write_read_0");
		super.new(name);
	endfunction
	//Read handle
	apb_write_read read;
	virtual task body();

	`uvm_do_with(req,{i_pwrite==0;
		     i_pwdata==`DW'h0;
		     i_paddr== {`AW'h0,`AW'h8};})
	`uvm_do(read);
	endtask
	
endclass

class apb_write_read_1 extends apb_sequence;


	//Factory Registration
	`uvm_object_utils(apb_write_read_1)
	//Constructor
	function new(string name="apb_write_read_1");
		super.new(name);
	endfunction
	//Read handle
	apb_write_read read;
	
	virtual task body();
	`uvm_do_with(req,{i_pwrite==0;
		     i_pwdata==`DW'hFFFF_FFFF;
		     i_paddr=={`AW'h0,`AW'h8};})
	`uvm_do(read)
	endtask
endclass




class apb_alternate_read_write extends apb_sequence;

	//Factory Registration
	`uvm_object_utils(apb_alternate_read_write)
	//Constructor
	function new(string name="apb_read_write");
		super.new(name);
	endfunction
	apb_write_read read;
	
	virtual task body();
	repeat(`num_txn)
		begin
		`uvm_do_with(req,{i_pwrite==1;i_pwdata==`DW'hAAAA_AAAA;i_paddr=={`AW'h0,`AW'h8};})
		end
	repeat(`num_txn)
		begin
		`uvm_do(read)
		end
	endtask
endclass


