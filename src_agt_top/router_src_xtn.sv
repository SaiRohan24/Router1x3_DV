class router_src_xtn extends uvm_sequence_item;

        `uvm_object_utils(router_src_xtn)
    
        //declear all properties
	rand bit [7:0]header;
	
	rand bit [7:0]payload[];

	bit [7:0] parity;

	bit error;

	constraint vld_addr{header [1:0] != 2'b11;}

	constraint vld_length {header [7:2] inside{[1:63]};}

	constraint payload_len{payload.size == header[7:2];}

	
        extern function new(string name = "src_xtn");

	extern function void post_randomize();

	extern function void do_print(uvm_printer printer);	

endclass

	function router_src_xtn::new(string name = "src_xtn");

        	super.new(name);

	endfunction

	function void router_src_xtn::post_randomize();

		parity = header;

		foreach(payload[i])
			parity = parity ^ payload[i];

	endfunction

	function void router_src_xtn::do_print(uvm_printer printer);

		printer.print_field("Header",this.header,8,UVM_BIN);
		
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);

		printer.print_field("Parity",this.parity,8,UVM_DEC);

		printer.print_field("Error",this.error,1,UVM_DEC);

	endfunction
