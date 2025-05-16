class router_dst_bseqs extends uvm_sequence #(router_dst_xtn);

    `uvm_object_utils(router_dst_bseqs)

    extern function new(string name = "dst_bseq");

endclass

	function router_dst_bseqs::new(string name = "dst_bseq");

        	super.new(name);
        
	endfunction

class dst_normal_seq extends router_dst_bseqs;

	`uvm_object_utils(dst_normal_seq)

	extern task body();
endclass

	task dst_normal_seq::body();

		//repeat(1)
			begin
				req = router_dst_xtn::type_id::create("req");

				start_item(req);

				assert(req.randomize() with{no_of_cycle inside{[1:28]};});

				finish_item(req);
			end

	endtask

class dst_moretime_seq extends router_dst_bseqs;

	`uvm_object_utils(dst_moretime_seq)

	extern task body();
endclass

	task dst_moretime_seq::body();


		req = router_dst_xtn::type_id::create("req");

		start_item(req);

		assert(req.randomize() with{no_of_cycle inside{[30:40]};});

		finish_item(req);

	endtask
	
