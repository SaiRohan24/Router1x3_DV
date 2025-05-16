
class router_env_config extends uvm_object;

	`uvm_object_utils(router_env_config)

	int no_of_src_agents;
	int no_of_dst_agents;
	router_src_agent_config src_cfg[];
	router_dst_agent_config dst_cfg[];

	bit has_scorebaord = 1;
	bit has_dst_agent = 1;
	bit has_src_agent = 1;
	bit has_virtual_seqr = 1; 

	function new(string name = "env_cfg");

		super.new(name);

	endfunction

endclass : router_env_config
