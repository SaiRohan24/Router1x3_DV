class router_src_monitor extends uvm_monitor;

	`uvm_component_utils(router_src_monitor)

	virtual router_if.SRC_MON_MP vif;

	router_src_agent_config s_cfg;

	uvm_analysis_port #(router_src_xtn) src_monitor_port;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern function void connect_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

	extern task collect_data();
		
endclass

	function router_src_monitor::new(string name, uvm_component parent);

		super.new(name,parent);
		
		src_monitor_port = new("src_monitor_port",this);

	endfunction

	function void router_src_monitor::build_phase(uvm_phase phase);
	
		super.build_phase(phase);

		if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",s_cfg))
			`uvm_fatal(get_type_name(),"Error in src_agent_config in class router_src_monitor");


	endfunction

	function void router_src_monitor::connect_phase(uvm_phase phase);
	
		super.connect_phase(phase);

		vif = s_cfg.vif;

	endfunction

	task router_src_monitor::run_phase(uvm_phase phase);

		forever
			begin
				collect_data();
			end	
	
	endtask

	task router_src_monitor::collect_data();

		router_src_xtn rm;
	
		rm = router_src_xtn::type_id::create("rm");

		while(vif.src_mon_cb.pkt_valid !== 1)
		begin
			//$display("src_mon while for pkt_vld");
			@(vif.src_mon_cb);
		end
		
		while(vif.src_mon_cb.busy !== 0)
		begin
			//$display("src_mon while for busy");
			@(vif.src_mon_cb);
		end
		
		rm.header = vif.src_mon_cb.d_in;
		rm.payload = new[rm.header[7:2]];
		
		@(vif.src_mon_cb);

		foreach(rm.payload[i])
			begin
				while(vif.src_mon_cb.busy !== 0)
				begin
					//$display("src_mon while for busy in payload");
					@(vif.src_mon_cb);
				end
				
				rm.payload[i] = vif.src_mon_cb.d_in;
				@(vif.src_mon_cb);
			end	
		
		while(vif.src_mon_cb.pkt_valid !== 0)
			begin
			@(vif.src_mon_cb);
			//$display("src_mon pkt_vld in parity");
			end
					
		rm.parity = vif.src_mon_cb.d_in;

		repeat(2)
			@(vif.src_mon_cb);

		rm.error = vif.src_mon_cb.error;

		//`uvm_info("SRC_MONITOR",$sformatf("Printing from Src_monitor \n%s",rm.sprint()),UVM_LOW)

		src_monitor_port.write(rm);

		
	endtask
