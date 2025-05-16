module top;

	import uvm_pkg::*;

	import router_pkg::*;

	bit clk;

	always
		#5 clk=~clk;
	
	//create instances for source and destinations 
	router_if src_if0(clk);

	router_if dst_if0(clk);
	router_if dst_if1(clk);
	router_if dst_if2(clk);
	
	//create instance for top
	router_top DUV(.clk(clk),.resetn(src_if0.resetn),.read_enb_0(dst_if0.read_enb),.read_enb_1(dst_if1.read_enb),
			.read_enb_2(dst_if2.read_enb),.d_in(src_if0.d_in),.pkt_valid(src_if0.pkt_valid),
			.d_out_0(dst_if0.d_out),.d_out_1(dst_if1.d_out),.d_out_2(dst_if2.d_out),.vld_out_0(dst_if0.vld_out),
			.vld_out_1(dst_if1.vld_out),.vld_out_2(dst_if2.vld_out),.error(src_if0.error),.busy(src_if0.busy));

	initial
	
		begin
		
			//write waveform syntax
			`ifdef VCS
         		$fsdbDumpvars(0,top);
        		`endif
			
			//set virtual interface in config db   
			uvm_config_db #(virtual router_if)::set(null,"*","src_if0",src_if0);
			uvm_config_db #(virtual router_if)::set(null,"*","dst_if0",dst_if0);
			uvm_config_db #(virtual router_if)::set(null,"*","dst_if1",dst_if1);
			uvm_config_db #(virtual router_if)::set(null,"*","dst_if2",dst_if2);

			//create test class handle and run test
			run_test();
		end

	property pkt_busy;
		@(posedge clk) $rose(src_if0.pkt_valid) |=> src_if0.busy;
	endproperty

	property busy_dout;
		@(posedge clk) src_if0.busy |=> ($stable(src_if0.d_in));
	endproperty

	property pkt_vld;
		@(posedge clk) $rose(src_if0.pkt_valid) |=> ##[0:2](dst_if0.vld_out || dst_if1.vld_out || dst_if2.vld_out);
	endproperty

	property pkt_read_0;
		@(posedge clk)(dst_if0.vld_out) |-> ##[1:29](dst_if0.read_enb);
	endproperty

	property pkt_read_1;
		@(posedge clk) (dst_if1.vld_out) |-> ##[1:29](dst_if1.read_enb);
	endproperty

	property pkt_read_2;
		@(posedge clk) (dst_if2.vld_out) |-> ##[1:29](dst_if2.read_enb);
	endproperty


	property vld_read;
		@(posedge clk) ($fell(dst_if0.vld_out) || $fell(dst_if1.vld_out) || $fell(dst_if2.vld_out)) |=> (!dst_if0.read_enb || !dst_if1.read_enb ||!dst_if2.read_enb);
	endproperty

	busy_pkt:	assert property (pkt_busy);
	dout_busy:	assert property (busy_dout);
	vld_pkt:	assert property (pkt_vld);
	read_pkt_0:	assert property (pkt_read_0);
	read_pkt_1:	assert property (pkt_read_1);
	read_pkt_2:	assert property (pkt_read_2);
	read_vld:	assert property (vld_read);

	cp1:	cover property (pkt_busy);
	cp2:	cover property (busy_dout);
	cp3:	cover property (pkt_vld);
	cp4:	cover property (pkt_read_0);
	cp5:	cover property (pkt_read_1);
	cp6:	cover property (pkt_read_2);
	cp7:	cover property (vld_read);

endmodule : top
