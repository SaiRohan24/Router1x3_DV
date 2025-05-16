class router_src_sequencer extends uvm_sequencer #(router_src_xtn);
	
	`uvm_component_utils(router_src_sequencer)

	extern function new(string name = "seqrh", uvm_component parent);

endclass

	function router_src_sequencer::new(string name = "seqrh", uvm_component parent);

		super.new(name,parent);

	endfunction
