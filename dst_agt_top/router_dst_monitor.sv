class router_dst_monitor extends uvm_monitor;

	`uvm_component_utils(router_dst_monitor)

	virtual router_if.DST_MON_MP vif;

	router_dst_agent_config d_cfg;

	uvm_analysis_port #(router_dst_xtn) dst_monitor_port;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern function void connect_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

	extern task collect_data();
		
endclass

	function router_dst_monitor::new(string name, uvm_component parent);

		super.new(name,parent);
		
		dst_monitor_port = new("dst_monitor_port",this);

	endfunction

	function void router_dst_monitor::build_phase(uvm_phase phase);
	
		super.build_phase(phase);

		if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",d_cfg))
			`uvm_fatal(get_type_name(),"Error in dst_agent_config in class router_dst_monitor");


	endfunction

	function void router_dst_monitor::connect_phase(uvm_phase phase);
	
		super.connect_phase(phase);

		vif = d_cfg.vif;

	endfunction

	task router_dst_monitor::run_phase(uvm_phase phase);

		forever
			begin
				collect_data();
			end	
	
	endtask

	task router_dst_monitor::collect_data();

		router_dst_xtn rm;
		
		rm = router_dst_xtn::type_id::create("rm");

		while(vif.dst_mon_cb.read_enb !== 1)
			@(vif.dst_mon_cb);
	
		//$display("read_enb is %0d && header is %0d",vif.dst_mon_cb.read_enb,vif.dst_mon_cb.d_out);
		@(vif.dst_mon_cb);
		rm.header = vif.dst_mon_cb.d_out;
		rm.payload = new[rm.header[7:2]];
			
		@(vif.dst_mon_cb);

		foreach(rm.payload[i])
			begin

				rm.payload[i] = vif.dst_mon_cb.d_out;
				@(vif.dst_mon_cb);			
	
			end

		rm.parity = vif.dst_mon_cb.d_out;
		
		@(vif.dst_mon_cb);

		dst_monitor_port.write(rm);
		
		//`uvm_info("DST_MONITOR",$sformatf("Printing from DST_monitor \n%s",rm.sprint()),UVM_LOW)

	endtask
