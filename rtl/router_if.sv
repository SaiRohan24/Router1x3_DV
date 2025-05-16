interface router_if(input bit clock);

	logic [7:0] d_in,d_out;
	logic resetn,pkt_valid,error,busy,read_enb,vld_out;
	bit clk;

	assign clk = clock;
	
	//clocking port for source driver
	clocking src_drv_cb @(posedge clk);

		default input #1;// output #1;
		output d_in;
		output pkt_valid;
		output resetn;
		input busy;
		input error;

	endclocking

	//clocking port for source monitor
	clocking src_mon_cb @(posedge clk);
	
		default input #1;// output #1;
		input d_in;
		input pkt_valid;
		input error;
		input busy;
	
	endclocking

	//clocking port for destination monitor
	clocking dst_mon_cb @(posedge clk);

		default input #1;// output #1;
		input d_out;
		input pkt_valid;
		input vld_out;
		input read_enb;

	endclocking

	//clocking port for destination driver
	clocking dst_drv_cb @(posedge clk);

		default input #1;// output #1;
		input vld_out;
		output read_enb;

	endclocking

	//modport for source driver
	modport SRC_DRV_MP (clocking src_drv_cb);

	//modport for source monitor
	modport SRC_MON_MP (clocking src_mon_cb);

	//modport for destination driver
	modport DST_DRV_MP (clocking dst_drv_cb);

	//modport for destination monitor
	modport DST_MON_MP (clocking dst_mon_cb);


endinterface  

