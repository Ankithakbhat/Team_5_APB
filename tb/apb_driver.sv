`define DRV_if vif.DRV.drv_cb
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
    if(vif.presetn == 0) begin
      @(posedge pclk);
      `DRV_if.i_paddr <= 'bz;
      `DRV_if.i_pwrite <= 'bz;
      `DRV_if.i_psel <= 'bz;
      `DRV_if.i_penable <= 'bz;
      `DRV_if.i_pwdata <= 'bz;
      `DRV_if.i_pstrb <= 'bz;
    end
    else begin
      @(posedge pclk);
      if(req.i_pwrite == 1) begin
        write();
      end
      else begin
        read();
      end
    end
  endtask

  //-----write operation-------

  task write();
    @(posedge pclk);
    `DRV_if.i_psel <= 1;
    `DRV_if.i_paddr <= req.i_paddr;
    `DRV_if.i_pwdata <= req.i_pwdata;
    @(posedge pclk);
    `DRV_if.i_penable <= 1;
    @(posedge pclk);

    `DRV_if.i_penable <= 1;
    `DRV_if.i_psel <= 1;



endclass: apb_driver


