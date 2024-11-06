//`include "apb_sequencer.sv"

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
    if(!(uvm_config_db #(virtual apb_intrf)::get(this, "*", "vif", vif)))
    `uvm_fatal("driver","unable to get interface")
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
      @(posedge vif.pclk);
      `DRV_if.i_paddr <= 'bz;
      `DRV_if.i_pwrite <= 'bz;
      `DRV_if.i_psel <= 'b0;
      `DRV_if.i_penable <= 'b0;
      `DRV_if.i_pwdata <= 'b0;
      `DRV_if.i_pstrb <= 'b0;
      `uvm_info("driver","Reset condition",UVM_LOW)
    end
    else begin
      @(posedge vif.pclk);
      `DRV_if.i_psel <= 'b1;
      `DRV_if.i_pwrite <= req.i_pwrite;
      `DRV_if.i_paddr <= req.i_paddr;
      `DRV_if.i_pwdata <= req.i_pwdata;
      @(posedge vif.pclk);
      `DRV_if.i_penable <= 'b1;
      @(posedge vif.pclk);
      `DRV_if.i_penable <= 'b0;
      `DRV_if.i_psel <= 'b0;
      `uvm_info(get_type_name(),$sformatf("\nDriving APB transaction:\n psel=%0d, pwrite=%0d, penable=%0d, paddr=%0h, pwdata=%0h",vif.DRV.drv_cb.i_psel, vif.DRV.drv_cb.i_pwrite, vif.DRV.drv_cb.i_penable,vif.DRV.drv_cb.i_paddr, vif.DRV.drv_cb.i_pwdata),UVM_LOW);
    end
  endtask

endclass: apb_driver


