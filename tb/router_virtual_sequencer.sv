class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

    `uvm_component_utils(router_virtual_sequencer)

    router_src_sequencer src_seqrh[];

    router_dst_sequencer dst_seqrh[];

    router_env_config m_cfg;

    extern function new(string name, uvm_component parent);

    extern function void build_phase(uvm_phase phase);
endclass

    function router_virtual_sequencer::new(string name, uvm_component parent);

        super.new(name,parent);
    
    endfunction

    function void router_virtual_sequencer::build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
            `uvm_fatal(get_type_name(),"Error in router_env_config in class router_virtual_sequencer");

        src_seqrh = new[m_cfg.no_of_src_agents];

        dst_seqrh = new[m_cfg.no_of_dst_agents];

    endfunction    
