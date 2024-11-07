class apb_write_read_1_test extends apb_test;

        //Factory Registration
        `uvm_component_utils(apb_write_read_1_test)

        //Sequence handle
        apb_write_read_1 seq1;

        //constructor
        function new(strinf name="apb_write_read_1_test",uvm_component parent=null);
                super.new(name,parent);
        endfunction: new

        //Build Phase
        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                //create sequence
                seq1=apb_write_read_1::type_id::create(seq1);
                `uvm_info("apb_write_read_1_test","Inside apb_write_read_1_test BUILD_PHASE",UVM_HIGH)
        endfunction: build_phase

        //Run Phase
        task run_phase(uvm_phase phase);
                super.run_phase(phase);

                phase.raise_objection(this);

                `uvm_info("SEQUENCE","\n----------------------------!!! WRITE AND READ VALUE 1 BEGINS !!!-------------------------------\n",UVM_LOW)
                seq1.start(env.agent_a.sequencer);
                `uvm_info("SEQUENCE","\n----------------------------!!! WRITE AND READ VALUE 1 ENDS !!!----------------------------------\n",UVM_LOW)
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this,50);
        endtask : run_phase

endclass

