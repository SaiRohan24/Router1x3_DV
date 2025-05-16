package router_pkg;

	import uvm_pkg::*;

	`include "uvm_macros.svh"
	`include "router_dst_xtn.sv"
	`include "router_dst_agent_config.sv"
	`include "router_src_agent_config.sv"
	`include "env_config.sv"
	`include "router_dst_driver.sv"
	`include "router_dst_monitor.sv"
	`include "router_dst_sequencer.sv"
	`include "router_dst_agent.sv"
	`include "router_dst_agent_top.sv"
	`include "router_dst_sequence.sv"

	`include "router_src_xtn.sv"
	`include "router_src_driver.sv"
	`include "router_src_monitor.sv"
	`include "router_src_sequencer.sv"
	`include "router_src_agent.sv"
	`include "router_src_agent_top.sv"
	`include "router_src_sequence.sv"
	
	`include "router_virtual_sequencer.sv"
	`include "router_virtual_seqs.sv"
	`include "router_scoreboard.sv"

	`include "router_tb.sv"

	`include "router_test_lib.sv"
endpackage