class router_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(router_scoreboard)

    //declear handles of TLM ports
	uvm_tlm_analysis_fifo #(router_src_xtn) fifo_s[];
	uvm_tlm_analysis_fifo #(router_dst_xtn) fifo_d[];
	router_env_config m_cfg;

	router_src_xtn s_xtn;
	router_dst_xtn d_xtn;

	int packet_compare,src_packet,dst_packet;

	covergroup src_fc;

		option.per_instance = 1;
		SRC_ADDR: coverpoint s_xtn.header[1:0]{
						bins a1 = {2'b00};
						bins a2 = {2'b01};
						bins a3 = {2'b10};
						}
		SRC_PAYLOAD: coverpoint s_xtn.header[7:2]{
						bins p1 = {[1:14]};
						bins p2 = {[15:30]};
						bins p3 = {[31:63]};
						}
		ERROR: coverpoint s_xtn.error;

		SRC_MIX: cross SRC_ADDR,SRC_PAYLOAD;  
	
	endgroup

	covergroup dst_fc;

		option.per_instance = 1;
		DST_ADDR: coverpoint d_xtn.header[1:0]{
						bins a_1 = {2'b00};
						bins a_2 = {2'b01};
						bins a_3 = {2'b10};
						}
		DST_PAYLOAD: coverpoint d_xtn.header[7:2]{
						bins p_1 = {[1:14]};
						bins p_2 = {[15:30]};
						bins p_3 = {[31:63]};
						}

		DST_MIX: cross DST_ADDR,DST_PAYLOAD;  
	
	endgroup

	extern function new(string name, uvm_component parent);

	extern function void build_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);

	extern function void report_phase(uvm_phase phase);

	extern task check_packet();

endclass

	function router_scoreboard::new(string name, uvm_component parent);

        	super.new(name,parent);

			src_fc = new();

			dst_fc = new();

    	endfunction

	function void router_scoreboard::build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
			`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

		fifo_s = new[m_cfg.no_of_src_agents];
		fifo_d = new[m_cfg.no_of_dst_agents];

		foreach(fifo_s[i])
			fifo_s[i] = new($sformatf("fifo_s%0d",i),this);


		foreach(fifo_d[i])
			fifo_d[i] = new($sformatf("fifo_d%0d",i),this);

	endfunction

    	task router_scoreboard::run_phase(uvm_phase phase);

		forever
	
			begin
				fork
	
		
					begin	
						//`uvm_info("Scoreboard","getting from SRC_MONITOR",UVM_LOW);
						//foreach(fifo_s[i])
						fifo_s[0].get(s_xtn);
						`uvm_info("SRC_MON_SB",$sformatf("Printing from SRC_MON \n%s",s_xtn.sprint()),UVM_LOW)
						src_fc.sample();
						src_packet++;
					end
	
		
					begin
						fork
							 begin
								fifo_d[0].get(d_xtn);
								`uvm_info("DST_MON_SB_0",$sformatf("Printing from DST_MON \n%s",d_xtn.sprint()),UVM_LOW)
								dst_fc.sample();
								dst_packet++;
							end
							
							begin
								fifo_d[1].get(d_xtn);
								`uvm_info("DST_MON_SB_1",$sformatf("Printing from DST_MON \n%s",d_xtn.sprint()),UVM_LOW)
								dst_fc.sample();
								dst_packet++;

							end

							begin
								fifo_d[2].get(d_xtn);
								`uvm_info("DST_MON_SB_2",$sformatf("Printing from DST_MON \n%s",d_xtn.sprint()),UVM_LOW)
								dst_fc.sample();
								dst_packet++;

							end
						join_any
						disable fork;
					end

				join
				
				check_packet();
			end

	endtask

	task router_scoreboard::check_packet();
		int temp;

		if(s_xtn.header != d_xtn.header)
			begin
				`uvm_error("ROUTER_SB","header mismatch")
				temp++;
			end
		
		if(s_xtn.payload != d_xtn.payload)

			begin
				`uvm_error("ROUTER_SB","payload mismatch")
				temp++;
			end
		
		if(s_xtn.parity != d_xtn.parity)
			begin
				`uvm_error("ROUTER_SB","parity mismatch")
				temp++;
			end
		
		if(temp == 0)
			packet_compare++;

	endtask

	function void router_scoreboard::report_phase(uvm_phase phase);

		`uvm_info(get_type_name(),$sformatf("No.of src_packet sent are %0d",src_packet),UVM_LOW)
		`uvm_info(get_type_name(),$sformatf("No.of dst_packet received are %0d",dst_packet),UVM_LOW)
		`uvm_info(get_type_name(),$sformatf("No.of compared are %0d",packet_compare),UVM_LOW)
	
	endfunction
