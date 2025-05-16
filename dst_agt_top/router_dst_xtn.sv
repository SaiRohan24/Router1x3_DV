class router_dst_xtn extends uvm_sequence_item;

        `uvm_object_utils(router_dst_xtn)
    
        //declear all parameters
	bit [7:0] header,payload[];
	bit [7:0] parity;
	rand bit [5:0]no_of_cycle; 

        extern function new(string name = "dst_xtn");
	
	extern function void do_print(uvm_printer printer);

endclass

	function router_dst_xtn::new(string name = "dst_xtn");

        	super.new(name);

	endfunction


	function void router_dst_xtn::do_print(uvm_printer printer);

		printer.print_field("Header",this.header,8,UVM_BIN);
		
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);

		printer.print_field("Parity",this.parity,8,UVM_DEC);

		printer.print_field("no_of_cycle",this.no_of_cycle,6,UVM_DEC);

	endfunction
