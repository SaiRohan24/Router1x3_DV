class router_tb extends uvm_env;

	`uvm_component_utils(router_tb);

	router_src_agent_top src_top;

	router_dst_agent_top dst_top;

	router_scoreboard sb;

	router_env_config m_cfg;

	router_virtual_sequencer v_seqrh;

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern function void connect_phase(uvm_phase phase);

endclass

	function router_tb::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void router_tb::build_phase(uvm_phase phase);

		super.build_phase(phase);

		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
			`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	
		src_top = router_src_agent_top::type_id::create("src_top",this);

		dst_top = router_dst_agent_top::type_id::create("dst_top",this);

		if(m_cfg.has_scorebaord)
			sb = router_scoreboard::type_id::create("sb",this);

		if(m_cfg.has_virtual_seqr)
			v_seqrh = router_virtual_sequencer::type_id::create("v_seqrh",this);

	
	endfunction

	function void router_tb::connect_phase(uvm_phase phase);

		super.connect_phase(phase);

		for(int i=0; i<m_cfg.no_of_src_agents; i++)
			v_seqrh.src_seqrh[i] = src_top.agnth[i].seqrh;

		for(int i=0; i<m_cfg.no_of_dst_agents; i++)
			v_seqrh.dst_seqrh[i] = dst_top.agnth[i].seqrh;
		
		for(int i=0; i<m_cfg.no_of_src_agents; i++)
			src_top.agnth[i].monh.src_monitor_port.connect(sb.fifo_s[i].analysis_export);
		for(int i=0; i<m_cfg.no_of_dst_agents; i++)
			dst_top.agnth[i].monh.dst_monitor_port.connect(sb.fifo_d[i].analysis_export); 		
	
	endfunction
