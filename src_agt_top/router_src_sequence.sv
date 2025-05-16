class router_src_bseqs extends uvm_sequence #(router_src_xtn);

    `uvm_object_utils(router_src_bseqs)

	bit [1:0] addr;

    extern function new(string name = "src_bseq");

endclass

    function router_src_bseqs::new(string name = "src_bseq");

        super.new(name);
        
    endfunction


/////////////////////////////
///small packet seq class
/////////////////////////////

class src_small_pkt_seq extends router_src_bseqs;

	`uvm_object_utils(src_small_pkt_seq)
	
	extern function new(string name = "small_seq");

	extern task body();

endclass

	function src_small_pkt_seq::new(string name = "small_seq");

		super.new(name);

	endfunction

	task src_small_pkt_seq::body();

		//repeat(1)

			begin
			
				req = router_src_xtn::type_id::create("req");

				if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
					`uvm_fatal(get_type_name(),"Error in bit[1:0] in class src_small_pkt_seq");

				start_item(req);
				
				assert(req.randomize() with {header[1:0]==addr;header[7:2] inside{[1:14]};});

				finish_item(req);
		
			end

	endtask

/////////////////////////////
///medium packet seq class
/////////////////////////////

class src_medium_pkt_seq extends router_src_bseqs;

	`uvm_object_utils(src_medium_pkt_seq)
	
	extern function new(string name = "medium_seq");

	extern task body();

endclass

	function src_medium_pkt_seq::new(string name = "medium_seq");

		super.new(name);

	endfunction

	task src_medium_pkt_seq::body();

	//	repeat(1)

			begin

				req = router_src_xtn::type_id::create("req");

				if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
					`uvm_fatal(get_type_name(),"Error in bit[1:0] in class src_medium_pkt_seq");

				start_item(req);

				assert(req.randomize() with {header[1:0]==addr;header[7:2] inside{[16:30]};});

				finish_item(req);

			end

	endtask

/////////////////////////////
///big packet seq class
/////////////////////////////

class src_big_pkt_seq extends router_src_bseqs;

	`uvm_object_utils(src_big_pkt_seq)
	
	extern function new(string name = "big_seq");

	extern task body();

endclass

	function src_big_pkt_seq::new(string name = "big_seq");

		super.new(name);

	endfunction

	task src_big_pkt_seq::body();

		repeat(1)

			begin

				req = router_src_xtn::type_id::create("req");

				if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
					`uvm_fatal(get_type_name(),"Error in bit[1:0] in class src_big_pkt_seq");

				start_item(req);

				assert(req.randomize() with {header[1:0]==addr;header[7:2] inside{[31:63]};});

				finish_item(req);

			end

	endtask

/////////////////////////////
///Error packet seq class
/////////////////////////////


class error_pkt_seq extends router_src_bseqs;

	`uvm_object_utils(error_pkt_seq)

	extern function new(string name = "error_seq");
	
	extern task body();

endclass

	function error_pkt_seq::new(string name = "error_seq");

		super.new(name);

	endfunction

	task error_pkt_seq::body();

	//	super.body();	
	
		req = router_src_xtn::type_id::create("req");

		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal(get_type_name(),"Error in bit[1:0] in class src_error")

		start_item(req);

		assert(req.randomize() with {header[1:0]==addr; header[7:2] inside{[1:13]};});

		req.parity = $urandom;

		finish_item(req);

	endtask
