class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(router_virtual_sequence)

    router_virtual_sequencer v_seqrh;

    router_src_sequencer src_seqrh[];

    router_dst_sequencer dst_seqrh[];

    router_env_config m_cfg;

    	src_small_pkt_seq ss_seq;

    	src_medium_pkt_seq sm_seq;

    	src_big_pkt_seq sb_seq;

	dst_normal_seq dn_seq;

	dst_moretime_seq dm_seq;

	error_pkt_seq e_seq;

	bit [1:0] addr;

    extern function new(string name = "virtual_seq");

    extern task body();

endclass

    function router_virtual_sequence::new(string name = "virtual_seq");

            super.new(name);
    
    endfunction

    task router_virtual_sequence::body();

        if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
            `uvm_fatal(get_type_name(),"Error in env_config in class router_virtual_sequence");

	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal(get_type_name(),"get addr is not getting")
        
        src_seqrh = new[m_cfg.no_of_src_agents];

        dst_seqrh = new[m_cfg.no_of_dst_agents];
        assert($cast(v_seqrh,m_sequencer)) 
        else
            `uvm_error("BODY","error in $cast")

        foreach(src_seqrh[i])
            src_seqrh[i] = v_seqrh.src_seqrh[i];

        foreach(dst_seqrh[i])
            dst_seqrh[i] = v_seqrh.dst_seqrh[i];
                 
    endtask

/////////////////////////////
////small_vseq
/////////////////////////////

class small_vseq extends router_virtual_sequence;

	`uvm_object_utils(small_vseq)

	extern function new(string name = "s_vseq");

	extern task body();

endclass

	function small_vseq::new(string name = "s_vseq");

		super.new(name);

	endfunction

	task small_vseq::body();

		super.body();

		ss_seq = src_small_pkt_seq::type_id::create("ss_seq"); 
		dn_seq = dst_normal_seq::type_id::create("dn_seq");
		dm_seq = dst_moretime_seq::type_id::create("dm_seq");
				fork
					foreach(src_seqrh[i])
					ss_seq.start(src_seqrh[0]);
					dn_seq.start(dst_seqrh[addr]);
					//dm_seq.start(dst_seqrh[addr]);
				join

	endtask
		
/////////////////////////////
////medium_vseq
/////////////////////////////

class medium_vseq extends router_virtual_sequence;

	`uvm_object_utils(medium_vseq)

	extern function new(string name = "sm_vseq");

	extern task body();

endclass

	function medium_vseq::new(string name = "sm_vseq");

		super.new(name);

	endfunction

	task medium_vseq::body();

		super.body();

		sm_seq = src_medium_pkt_seq::type_id::create("sm_seq");
		dn_seq = dst_normal_seq::type_id::create("dn_seq"); 
		dm_seq = dst_moretime_seq::type_id::create("dm_seq");
		//if(m_cfg.has_src_agent)
			fork
				//foreach(src_seqrh[i])
				sm_seq.start(src_seqrh[0]);
				dn_seq.start(dst_seqrh[addr]);
				//dm_seq.start(dst_seqrh[addr]);
			join

	endtask

/////////////////////////////
////big_vseq
/////////////////////////////

class big_vseq extends router_virtual_sequence;

	`uvm_object_utils(big_vseq)

	extern function new(string name = "sb_vseq");

	extern task body();

endclass

	function big_vseq::new(string name = "sb_vseq");

		super.new(name);

	endfunction

	task big_vseq::body();

		super.body();

		sb_seq = src_big_pkt_seq::type_id::create("sb_seq");
		dn_seq = dst_normal_seq::type_id::create("dn_seq"); 
		dm_seq = dst_moretime_seq::type_id::create("dm_seq");
		//if(m_cfg.has_src_agent)
			fork
				//foreach(src_seqrh[i])
				sb_seq.start(src_seqrh[0]);
				dn_seq.start(dst_seqrh[addr]);
				//dm_seq.start(dst_seqrh[addr]);				
			join

	endtask

/////////////////////////////
////error_vseq
////////////////////////////

class error_vseq extends router_virtual_sequence;

	`uvm_object_utils(error_vseq)
		
	extern function new(string name = "error_vseq");

	extern task body();
	
endclass

	function error_vseq::new(string name = "error_vseq");

		super.new(name);

	endfunction

	task error_vseq::body();

		super.body();

		e_seq = error_pkt_seq::type_id::create("e_seq");
		dn_seq = dst_normal_seq::type_id::create("dn_seq");

		fork
			e_seq.start(src_seqrh[0]);
			dn_seq.start(dst_seqrh[addr]);
		join

	endtask


/////////////////////////////
////moretime_vseq
/////////////////////////////

class moretime_vseq extends router_virtual_sequence;

	`uvm_object_utils(moretime_vseq)

	extern function new(string name = "mt_vseq");

	extern task body();

endclass

	function moretime_vseq::new(string name = "mt_vseq");

		super.new(name);

	endfunction

	task moretime_vseq::body();

		super.body();

		ss_seq = src_small_pkt_seq::type_id::create("ss_seq"); 
		//dn_seq = dst_normal_seq::type_id::create("dn_seq");
		dm_seq = dst_moretime_seq::type_id::create("dm_seq");
				fork
					foreach(src_seqrh[i])
					ss_seq.start(src_seqrh[0]);
					//dn_seq.start(dst_seqrh[addr]);
					dm_seq.start(dst_seqrh[addr]);
				join

	endtask
		
