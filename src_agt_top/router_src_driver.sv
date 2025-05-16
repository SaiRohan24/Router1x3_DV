class router_src_driver extends uvm_driver #(router_src_xtn);

	`uvm_component_utils(router_src_driver)

	virtual router_if.SRC_DRV_MP vif;

	router_src_agent_config m_cfg;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern function void connect_phase(uvm_phase phase);
	
	extern task run_phase(uvm_phase phase);

	extern task driver_to_dut(router_src_xtn rd);

	extern task reset_dut();

endclass

	//driver new constructor
	function router_src_driver::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	//source driver build_phase
	function void router_src_driver::build_phase(uvm_phase phase);

		super.build_phase(phase);

		if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
			`uvm_fatal(get_type_name(),"Error in src config in router_src_driver class");

	endfunction

	//source driver connect_phase 
	function void router_src_driver::connect_phase(uvm_phase phase);

		super.connect_phase(phase);

		vif = m_cfg.vif;

	endfunction

	//source driver run_phase
	task router_src_driver::run_phase(uvm_phase phase);
		reset_dut();
		forever

			begin
				seq_item_port.get_next_item(req);
				
				driver_to_dut(req);
				
				seq_item_port.item_done();
			end

	endtask

	task router_src_driver::reset_dut();
	
		@(vif.src_drv_cb);
			vif.src_drv_cb.resetn <= 1'b0;
			vif.src_drv_cb.pkt_valid <= 1'b0;
		repeat(2)
			@(vif.src_drv_cb);
		
		vif.src_drv_cb.resetn <= 1'b1;

	endtask

	//source driver to dut task
	task router_src_driver::driver_to_dut(router_src_xtn rd);

				//@(vif.src_drv_cb);
			//`uvm_info("SRC_DRIVER",$sformatf("Printing from Src_Driver \n%s",rd.sprint()),UVM_LOW)

			while(vif.src_drv_cb.busy !== 0)
				begin
				@(vif.src_drv_cb);
				//$display("src_busy in header");
				end
				
			
			vif.src_drv_cb.pkt_valid <= 1'b1;
			vif.src_drv_cb.d_in <= rd.header;
			
			@(vif.src_drv_cb)
	
			foreach(rd.payload[i])
				begin
					while(vif.src_drv_cb.busy !== 0)
						begin
						@(vif.src_drv_cb);
						//$display("src_busy in payload");
						end
						
					
					vif.src_drv_cb.d_in <= rd.payload[i];
					@(vif.src_drv_cb);
				end
			while(vif.src_drv_cb.busy !== 0)
				begin
				@(vif.src_drv_cb);
				//$display("src_busy in parity");
				end
	
			vif.src_drv_cb.pkt_valid <= 1'b0;
			vif.src_drv_cb.d_in <= rd.parity;
			
			@(vif.src_drv_cb);
			
			//`uvm_info("SRC_DRIVER",$sformatf("Printing from Src_Driver \n%s",rd.sprint()),UVM_LOW)
		
	
	endtask
