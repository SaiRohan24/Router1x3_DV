module router_fifo(clk,resetn,soft_reset,write_enb,read_enb,d_in,lfd_state,empty,d_out,full);

	input clk,resetn,soft_reset,read_enb,write_enb,lfd_state;
	input [7:0]d_in;
	output empty,full;
	output reg [7:0]d_out;
	
	reg temp;
	reg [4:0]write_enb_ptr,read_enb_ptr;
	reg [6:0]count;
	reg [8:0] mem [15:0];
	integer i,j;
	
	assign full = (write_enb_ptr[4]!=read_enb_ptr[4])&&(write_enb_ptr[3:0]==read_enb_ptr[3:0]);
	assign empty = (write_enb_ptr==read_enb_ptr);
	
	//assign lfd_state to temp
	always@(posedge clk)
		begin
			if(!resetn)
				begin
				temp<=0;
				end
			else
				begin
				temp<=lfd_state;
				end
		end
		
	//write_enbite logic
	always@(posedge clk)
		begin
			if(!resetn)
				begin
					for(i=0;i<16;i=i+1)
						begin
							mem[i]<=0;
							write_enb_ptr<=0;
						end
				end
			else if(soft_reset)
				begin
					for(j=0;j<16;j=j+1)
						begin
							mem[j]<=0;
							write_enb_ptr<=0;
						end
				end
			else if(write_enb && !full)
				begin 
					{mem[write_enb_ptr[3:0]][8],mem[write_enb_ptr[3:0]][7:0]}<={temp,d_in};
					write_enb_ptr<=write_enb_ptr+1'b1;
				end
			else
				write_enb_ptr<=write_enb_ptr;
		end

	//read logic
	always@(posedge clk)
		begin
				if(!resetn)
					begin
						d_out<=8'b0;
						read_enb_ptr<=0;
					end
				else if(soft_reset)
					begin
						d_out<=8'bz;
					end
				else if(read_enb && !empty)
					begin
						d_out<=mem[read_enb_ptr[3:0]][7:0];
						read_enb_ptr<=read_enb_ptr+1'b1;
					end
				else
					d_out<=8'bz;
		end
		
	//counter logic
	always@(posedge clk)
		begin
			if(!resetn)
				count<=0;
			else if(soft_reset)
				count<=0;
			else if(read_enb && !empty)
				begin
					if(mem[read_enb_ptr[3:0]][8]==1)
						count<=mem[read_enb_ptr[3:0]][7:2]+1'b1;
					else
						count<=count-1'b1;
				end
			else
				count<=count;
		end 
endmodule
