class router_dst_agent extends uvm_agent;

	`uvm_component_utils(router_dst_agent)

	router_dst_agent_config d_cfg;

	router_dst_monitor monh;

	router_dst_sequencer seqrh;

	router_dst_driver drvh;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);
	
	extern function void connect_phase(uvm_phase phase);

endclass

	function router_dst_agent::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void router_dst_agent::build_phase(uvm_phase phase);

		super.build_phase(phase);

		if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",d_cfg))
			`uvm_fatal(get_type_name(),"Error in dst_agent_config in class router_dst_agent")

		monh = router_dst_monitor::type_id::create("monh",this);

		if(d_cfg.is_active == UVM_ACTIVE)
			begin
				drvh = router_dst_driver::type_id::create("drvh",this);

				seqrh = router_dst_sequencer::type_id::create("seqrh",this);
			end

	endfunction

	function void router_dst_agent::connect_phase(uvm_phase phase);
 	
		super.connect_phase(phase);

		if(d_cfg.is_active == UVM_ACTIVE)
			drvh.seq_item_port.connect(seqrh.seq_item_export);

	endfunction
