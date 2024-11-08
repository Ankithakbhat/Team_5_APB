

`define DRV_if vif.DRV.drv_cb

class apb_driver extends uvm_driver#(apb_seq_item);

  //------ Register with the UVM factory ---------
  `uvm_component_utils(apb_driver)

  //------- Class constructor ---------------
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  //---- Virtual interface declaration -------
  virtual apb_intrf vif;

  //------ Get interface handle from top --------//
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!(uvm_config_db #(virtual apb_intrf)::get(this, "*", "vif", vif)))
      `uvm_fatal("APB_DRIVER", "Unable to get interface handle from uvm_config_db")
  endfunction: build_phase

  //------ Main Run Phase ---------------------//
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask: run_phase


    
    task drive();
  if (vif.presetn == 0) begin
    @(posedge vif.pclk);
    `DRV_if.i_paddr <= 'bz;
    `DRV_if.i_pwrite <= 'bz;
    `DRV_if.i_psel <= 'b0;
    `DRV_if.i_penable <= 'b0;
    `DRV_if.i_pwdata <= 'b0;
    `uvm_info("APB_DRIVER", "Reset condition applied", UVM_LOW);
  end else begin
    @(posedge vif.pclk);
    `DRV_if.i_psel <= 'b1;
    `DRV_if.i_penable <= 'b0;
    `DRV_if.i_pwrite <= req.i_pwrite;
    `DRV_if.i_paddr <= req.i_paddr;
    `DRV_if.i_pwdata <= req.i_pwdata;
    `DRV_if.i_pstrb <= req.i_pstrb;
    `uvm_info(get_type_name(),
      $sformatf("\n----------------------------------\nstart Driving APB Transaction:\n psel=%0d, pwrite=%0d, penable=%0d, paddr=%0h, pwdata=%0h",
                `DRV_if.i_psel, `DRV_if.i_pwrite, `DRV_if.i_penable, `DRV_if.i_paddr, `DRV_if.i_pwdata),
      UVM_LOW);

    @(posedge vif.pclk);
    `DRV_if.i_penable <= 'b1;
    `uvm_info(get_type_name(),
      $sformatf("Enable Phase:\n psel=%0d, pwrite=%0d, penable=%0d, paddr=%0h, pwdata=%0h",
                `DRV_if.i_psel, `DRV_if.i_pwrite, `DRV_if.i_penable, `DRV_if.i_paddr, `DRV_if.i_pwdata),
      UVM_LOW);

    
    wait (vif.o_pready == 1'b1); 
    @(posedge vif.pclk);           

  
    `DRV_if.i_penable <= 'b0;
    `DRV_if.i_psel <= 'b0;
    `uvm_info(get_type_name(),
      $sformatf("End Driving APB Transaction:\n psel=%0d, pwrite=%0d, penable=%0d, paddr=%0h, pwdata=%h",
                `DRV_if.i_psel, `DRV_if.i_pwrite, `DRV_if.i_penable, `DRV_if.i_paddr, `DRV_if.i_pwdata),
      UVM_LOW);
    @(posedge vif.pclk);
  end
endtask: drive


endclass: apb_driver
