class router_dst_agent_top extends uvm_env;

	`uvm_component_utils(router_dst_agent_top)

	router_dst_agent agnth[];

	router_env_config m_cfg;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

endclass

	function router_dst_agent_top::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void router_dst_agent_top::build_phase(uvm_phase phase);

		super.build_phase(phase);

		//m_cfg = router_env_config::type_id::create("m_cfg");

		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
            `uvm_fatal(get_type_name(),"Error in env_config in class router_dst_agent_top");

		agnth = new[m_cfg.no_of_dst_agents];

		if(m_cfg.has_dst_agent)
			begin
				foreach(agnth[i])
					begin
						uvm_config_db #(router_dst_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"router_dst_agent_config",m_cfg.dst_cfg[i]);
					
						agnth[i] = router_dst_agent::type_id::create($sformatf("agnth[%0d]",i),this);
					end
			end

	endfunction	
