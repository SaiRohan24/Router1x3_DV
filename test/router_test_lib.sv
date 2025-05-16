class router_test_base extends uvm_test;

	`uvm_component_utils(router_test_base)

	router_env_config env_cfg;
	router_src_agent_config src_cfg[];
	router_dst_agent_config dst_cfg[];
	router_tb envh;

	int no_of_src = 1;
	int no_of_dst = 3;

	extern function new(string name,uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern function void start_of_simulation_phase(uvm_phase phase);

endclass : router_test_base

	function router_test_base::new(string name,uvm_component parent);
	
		super.new(name,parent);

	endfunction

	function void router_test_base::build_phase(uvm_phase phase);

		//Declear size for src_cfg	
		src_cfg = new[no_of_src];
		
		//create object for src_cfg[i] and get the virtual interface and assign is_active to UVM_ACTIVE
		foreach(src_cfg[i])
			begin
				src_cfg[i] = router_src_agent_config::type_id::create($sformatf("src_cfg[%0d]",i));
				
				if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("src_if%0d",i),src_cfg[i].vif))
					`uvm_fatal(get_type_name(),"src_config_db error")
				
				src_cfg[i].is_active = UVM_ACTIVE;
			end

		//Declear size for dst_cfg	
		dst_cfg = new[no_of_dst];

		//create object for dst_cfg[i] and get the virtual interface and assign is_active to UVM_ACTIVE
		foreach(dst_cfg[i])
			begin
				dst_cfg[i] = router_dst_agent_config::type_id::create($sformatf("dst_cfg[%0d]",i));
				
				if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("dst_if%0d",i),dst_cfg[i].vif))
					`uvm_fatal(get_type_name(),"dst_config_db error")
				
				dst_cfg[i].is_active = UVM_ACTIVE;
			end

		//create object to env_cfg
		env_cfg = router_env_config::type_id::create("env_cfg");

		//assign the values which decleared in test into env_cfg
		env_cfg.src_cfg = src_cfg;

		env_cfg.dst_cfg = dst_cfg;

		env_cfg.no_of_src_agents = no_of_src;
		
		env_cfg.no_of_dst_agents = no_of_dst;
		
		//set the env_cfg into confg_db
		uvm_config_db #(router_env_config)::set(this,"*","router_env_config",env_cfg);

		envh = router_tb::type_id::create("envh",this);

	endfunction

	function void router_test_base::start_of_simulation_phase(uvm_phase phase);

		uvm_top.print_topology();
		//$finish;
		
	endfunction


///////////////////////
///small_pkt_test_0
///////////////////////

class small_pkt_test_0 extends router_test_base;

	`uvm_component_utils(small_pkt_test_0)

	small_vseq s_seq;	

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function small_pkt_test_0::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void small_pkt_test_0::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task small_pkt_test_0::run_phase(uvm_phase phase);

		
		s_seq = small_vseq::type_id::create("s_seq");

		addr = 0;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
		
		repeat(1)		

			begin
				s_seq.start(envh.v_seqrh);

			end

		#100;

		phase.drop_objection(this);

	endtask

///////////////////////
///medium_pkt_test_0
///////////////////////

class medium_pkt_test_0 extends router_test_base;

	`uvm_component_utils(medium_pkt_test_0)

	medium_vseq s_seq;

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function medium_pkt_test_0::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void medium_pkt_test_0::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task medium_pkt_test_0::run_phase(uvm_phase phase);

		
		s_seq = medium_vseq::type_id::create("s_seq");

		addr = 0;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

			phase.raise_objection(this);
		repeat(1)
			begin

				s_seq.start(envh.v_seqrh);
		
			end
	
			#200;
		phase.drop_objection(this);
	
	endtask

///////////////////////
///big_pkt_test_0
///////////////////////

class big_pkt_test_0 extends router_test_base;

	`uvm_component_utils(big_pkt_test_0)

	big_vseq s_seq;

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function big_pkt_test_0::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void big_pkt_test_0::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task big_pkt_test_0::run_phase(uvm_phase phase);

		
		s_seq = big_vseq::type_id::create("s_seq");

		addr = 0;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
		
		repeat(1)
		
			begin
				s_seq.start(envh.v_seqrh);

			end

		#100;

		phase.drop_objection(this);

	endtask

///////////////////////
///small_pkt_test_1
///////////////////////

class small_pkt_test_1 extends router_test_base;

	`uvm_component_utils(small_pkt_test_1)

	small_vseq s_seq;	

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function small_pkt_test_1::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void small_pkt_test_1::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task small_pkt_test_1::run_phase(uvm_phase phase);

		
		s_seq = small_vseq::type_id::create("s_seq");

		addr = 1;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
		
		repeat(1)		

			begin
				s_seq.start(envh.v_seqrh);

			end

		#100;

		phase.drop_objection(this);

	endtask

///////////////////////
///medium_pkt_test_1
///////////////////////

class medium_pkt_test_1 extends router_test_base;

	`uvm_component_utils(medium_pkt_test_1)

	medium_vseq s_seq;

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function medium_pkt_test_1::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void medium_pkt_test_1::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task medium_pkt_test_1::run_phase(uvm_phase phase);

		
		s_seq = medium_vseq::type_id::create("s_seq");

		addr = 1;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

			phase.raise_objection(this);
		repeat(1)
			begin

				s_seq.start(envh.v_seqrh);
		
			end
	
			#200;
		phase.drop_objection(this);
	
	endtask

///////////////////////
///big_pkt_test_1
///////////////////////

class big_pkt_test_1 extends router_test_base;

	`uvm_component_utils(big_pkt_test_1)

	big_vseq s_seq;

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function big_pkt_test_1::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void big_pkt_test_1::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task big_pkt_test_1::run_phase(uvm_phase phase);

		
		s_seq = big_vseq::type_id::create("s_seq");

		addr = 1;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
		
		repeat(1)
		
			begin
				s_seq.start(envh.v_seqrh);

			end

		#100;

		phase.drop_objection(this);

	endtask

///////////////////////
///small_pkt_test_2
///////////////////////

class small_pkt_test_2 extends router_test_base;

	`uvm_component_utils(small_pkt_test_2)

	small_vseq s_seq;	

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function small_pkt_test_2::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void small_pkt_test_2::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task small_pkt_test_2::run_phase(uvm_phase phase);

		
		s_seq = small_vseq::type_id::create("s_seq");

		addr = 2;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
		
		repeat(1)		

			begin
				s_seq.start(envh.v_seqrh);

			end

		#100;

		phase.drop_objection(this);

	endtask

///////////////////////
///medium_pkt_test_2
///////////////////////

class medium_pkt_test_2 extends router_test_base;

	`uvm_component_utils(medium_pkt_test_2)

	medium_vseq s_seq;

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function medium_pkt_test_2::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void medium_pkt_test_2::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task medium_pkt_test_2::run_phase(uvm_phase phase);

		
		s_seq = medium_vseq::type_id::create("s_seq");

		addr = 2;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

			phase.raise_objection(this);
		repeat(1)
			begin

				s_seq.start(envh.v_seqrh);
		
			end
	
			#200;
		phase.drop_objection(this);
	
	endtask

///////////////////////
///big_pkt_test_2
///////////////////////

class big_pkt_test_2 extends router_test_base;

	`uvm_component_utils(big_pkt_test_2)

	big_vseq s_seq;

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function big_pkt_test_2::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction
	
	function void big_pkt_test_2::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task big_pkt_test_2::run_phase(uvm_phase phase);

		
		s_seq = big_vseq::type_id::create("s_seq");

		addr = 2;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
		
		repeat(1)
		
			begin
				s_seq.start(envh.v_seqrh);

			end

		#100;

		phase.drop_objection(this);

	endtask

class error_test extends router_test_base;

	`uvm_component_utils(error_test)

	error_vseq ev_seq;

	bit[1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);
	
	extern task run_phase(uvm_phase phase);

endclass

	function error_test::new(string name, uvm_component parent);
		
		super.new(name,parent);

	endfunction

	function void error_test::build_phase(uvm_phase phase);
		
		super.build_phase(phase);

	endfunction

	task error_test::run_phase(uvm_phase phase);

		ev_seq = error_vseq::type_id::create("ev_seq");

		addr = 0;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
		
		phase.raise_objection(this);

		ev_seq.start(envh.v_seqrh);

		#100;

		phase.drop_objection(this);

	endtask


///////////////////////
///moretime_pkt_test
///////////////////////

class moretime_pkt_test extends router_test_base;

	`uvm_component_utils(moretime_pkt_test)

	moretime_vseq m_seq;	

	bit [1:0] addr;

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

endclass


	function moretime_pkt_test::new(string name, uvm_component parent);

		super.new(name,parent);

	endfunction

	function void moretime_pkt_test::build_phase(uvm_phase phase);

		super.build_phase(phase);

	endfunction

	task moretime_pkt_test::run_phase(uvm_phase phase);

		
		m_seq = moretime_vseq::type_id::create("m_seq");

		addr = 1;

		uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

		phase.raise_objection(this);
		
		repeat(1)		

			begin
				m_seq.start(envh.v_seqrh);

			end

		#100;

		phase.drop_objection(this);

	endtask	
