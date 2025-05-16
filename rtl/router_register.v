	module router_register(clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,
								ld_state,laf_state,full_state,lfd_state,parity_done,
								low_pkt_valid,error,d_out,d_in);

	input clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,
								ld_state,laf_state,full_state,lfd_state;
	input [7:0]d_in;
	output reg parity_done, low_pkt_valid,error;
	output reg [7:0]d_out;
	reg [7:0]header,full_state_byte,internal_parity,packet_parity;
	
	//d_out logic
	always@(posedge clk)
		begin
			if(!resetn)
				d_out<=8'b0;
			else if(lfd_state)
				d_out<=header;
			else if(ld_state && !fifo_full)
				d_out<=d_in;
			else if(laf_state)
				d_out<=full_state_byte;
			else
				d_out<=d_out;				
		end
		
	//header logic
	always@(posedge clk)
		begin
			if(!resetn)
				header<=8'b0;
			else if(detect_add && pkt_valid && d_in[1:0]!=2'b11)
				header<=d_in;
			else
				header<=header;
		end
	
	//full_state logic
	always@(posedge clk)
		begin
			if(!resetn)
				full_state_byte<=8'b0;
			else if(ld_state && fifo_full)
				full_state_byte<=d_in;
			else
				full_state_byte<=full_state_byte;
		end
	//internal parity
	always@(posedge clk)
		begin
			if(!resetn)
				internal_parity<=8'b0;
			else if(detect_add)
				internal_parity<=8'b0;
			else if(lfd_state)
				internal_parity<=internal_parity^header;
			else if(pkt_valid && ld_state && !full_state)
				internal_parity<=internal_parity^d_in;
			else
				internal_parity<=internal_parity;
		end
	
	//packet_parity
	always@(posedge clk)
		begin
			if(!resetn)
				packet_parity<=8'b0;
			else if(ld_state && !pkt_valid)
				packet_parity<=d_in;
			else
				packet_parity<=packet_parity;
		end
	
	//error logic
	always@(posedge clk)
		begin
			if(!resetn)
				error<=1'b0;
			else
				begin
					if(parity_done)
						error<=(internal_parity!=packet_parity)?1'b1:1'b0;
				end	
		end
	
	//parity_done logic
	always@(posedge clk)
		begin
			if(!resetn)
				parity_done<=1'b0;
			else if(ld_state && !full_state && !pkt_valid)
				parity_done<=1'b1;
			else if(laf_state && low_pkt_valid && !parity_done)
				parity_done<=1'b1;
			else
				begin
					if(detect_add)
						parity_done<=1'b0;
				end
		end
		
	//low_pkt_valid logic
	always@(posedge clk)
		begin
			if(!resetn)
				low_pkt_valid<=1'b0;
			else
				begin
					if(rst_int_reg)
						low_pkt_valid<=1'b0;
					if(ld_state && !pkt_valid)
						low_pkt_valid<=1'b1;
				end
		end
endmodule