class router_src_agent extends uvm_agent;

	`uvm_component_utils(router_src_agent)

	router_src_agent_config s_cfg;

	router_src_monitor monh;

	router_src_sequencer seqrh;

	router_src_driver drvh;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);
	
	extern function void connect_phase(uvm_phase phase);

endclass

	function router_src_agent::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void router_src_agent::build_phase(uvm_phase phase);

		super.build_phase(phase);

		if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",s_cfg))
			`uvm_fatal(get_type_name(),"Error in src_agent_config in class router_src_agent")

		monh = router_src_monitor::type_id::create("monh",this);

		if(s_cfg.is_active == UVM_ACTIVE)
			begin
				drvh = router_src_driver::type_id::create("drvh",this);

				seqrh = router_src_sequencer::type_id::create("seqrh",this);
			end

	endfunction

	function void router_src_agent::connect_phase(uvm_phase phase);
 	
		super.connect_phase(phase);

		if(s_cfg.is_active == UVM_ACTIVE)
			drvh.seq_item_port.connect(seqrh.seq_item_export);

	endfunction
