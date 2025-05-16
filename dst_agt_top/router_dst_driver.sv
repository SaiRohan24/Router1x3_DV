class router_dst_driver extends uvm_driver #(router_dst_xtn);

	`uvm_component_utils(router_dst_driver)

	virtual router_if.DST_DRV_MP vif;

	router_dst_agent_config m_cfg;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern function void connect_phase(uvm_phase phase);
	
	extern task run_phase(uvm_phase phase);

	extern task driver_to_dut(router_dst_xtn rd);

endclass

	//driver new constructor
	function router_dst_driver::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	//destination driver build_phase
	function void router_dst_driver::build_phase(uvm_phase phase);

		super.build_phase(phase);

		if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
			`uvm_fatal(get_type_name(),"Error in dst config in router_dst_driver class");

	endfunction

	//destination driver connect_phase 
	function void router_dst_driver::connect_phase(uvm_phase phase);

		super.connect_phase(phase);

		vif = m_cfg.vif;

	endfunction

	//destination driver run_phase
	task router_dst_driver::run_phase(uvm_phase phase);

		super.run_phase(phase);

		forever

			begin
				seq_item_port.get_next_item(req);

				driver_to_dut(req);

				seq_item_port.item_done();
			end

	endtask

	//destination driver to dut task
	task router_dst_driver::driver_to_dut(router_dst_xtn rd);

		vif.dst_drv_cb.read_enb <= 1'b0;


		//$display("vld_out is %0d",vif.dst_drv_cb.vld_out);

		while(vif.dst_drv_cb.vld_out !== 1)
			begin
			@(vif.dst_drv_cb);
			//$display("dst_drv vld_out");
			end

		repeat(rd.no_of_cycle)
			@(vif.dst_drv_cb);
		$display("no_of_cycles is %0d",rd.no_of_cycle);
		
		vif.dst_drv_cb.read_enb <= 1'b1;
			@(vif.dst_drv_cb);
			//$display("drive time",$time);
		
		while(vif.dst_drv_cb.vld_out !== 0)
			begin
			@(vif.dst_drv_cb);
			//$display("dst_drv vld_out is 0");
			end

	//	@(vif.dst_drv_cb);
			vif.dst_drv_cb.read_enb <= 1'b0;
		//@(vif.dst_drv_cb);



	endtask 
