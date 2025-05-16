module router_top(clk,resetn,read_enb_0,read_enb_1,read_enb_2,d_in,pkt_valid,
		d_out_0,d_out_1,d_out_2,vld_out_0,vld_out_1,vld_out_2,
		error,busy);
						
	input clk,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
	input [7:0]d_in;
	output vld_out_0,vld_out_1,vld_out_2,error,busy;
	output [7:0]d_out_0,d_out_1,d_out_2;
		
	wire [2:0]write_enb;
	wire [7:0]d_out;
		
	router_register register(clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,
				lfd_state,parity_done,low_pkt_valid,error,d_out,d_in);
		
	router_syn syn(clk,resetn,d_in[1:0],write_enb_reg,detect_add,vld_out_0,vld_out_1,vld_out_2,read_enb_0,read_enb_1,read_enb_2,
			write_enb,fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,full_0,full_1,full_2);
		
	router_fsm fsm(clk,resetn,pkt_valid,d_in[1:0],fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,
			parity_done,low_pkt_valid,write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);
		
	router_fifo fifo_0(clk,resetn,soft_reset_0,write_enb[0],read_enb_0,d_out,lfd_state,empty_0,d_out_0,full_0);
		
	router_fifo fifo_1(clk,resetn,soft_reset_1,write_enb[1],read_enb_1,d_out,lfd_state,empty_1,d_out_1,full_1);
		
	router_fifo fifo_2(clk,resetn,soft_reset_2,write_enb[2],read_enb_2,d_out,lfd_state,empty_2,d_out_2,full_2);
endmodule
