module axi_stream_len_prepender #(
  	parameter ID = 0,
  	parameter MAX_PKT_LEN = 64,
  	parameter DEPTH_BITS = 8
)(
	input wire clk,
	input wire rst,

  	input wire ena,

  	input wire [63:0] in_tdata,
	input wire in_tvalid,
  	input wire in_tlast,
	output reg in_tready,

  	output reg [63:0] out_tdata,
	output reg out_tlast,
	output reg out_tvalid,
	input wire out_tready
);

localparam INT_MAX_PKT_LEN = (MAX_PKT_LEN < 3) ? 3 : (MAX_PKT_LEN > 65536) ? 65536 : MAX_PKT_LEN;
localparam INT_MAX_SAMPLES = INT_MAX_PKT_LEN - 2;
// Set memory to power of 2
localparam DEPTH = 2**DEPTH_BITS; // we need two extra words available per packet
localparam SZ_AXI_WIDTH = 64 + 1; // tdata + tlast
localparam SZ_DEPTH = $clog2(DEPTH);

wire in_captured = in_tvalid && in_tready;
wire out_captured = out_tvalid && out_tready;

reg [31:0] num_pkts_in;
reg wr_ena;
reg [SZ_AXI_WIDTH-1:0] wr_dat;
reg [15:0] wr_cnt;
reg [SZ_DEPTH:0] wr_pos;
reg [SZ_DEPTH:0] wr_start;
reg [SZ_DEPTH:0] rd_pos;
reg [SZ_AXI_WIDTH-1:0] r_data [DEPTH-1:0];
reg [SZ_DEPTH-1:0] in_pkts;
reg [SZ_DEPTH-1:0] out_pkts;
reg [16:0] max_pkt_len;

enum int unsigned { ST_IDLE = 1, ST_DATA = 2, ST_WR_LEN = 4, ST_WR_UPDATE = 8 } in_state;

// inferred ram block with pass through logic to match read-during-write behaviour
always@(posedge clk) begin
	if(wr_ena)
		r_data[wr_pos[SZ_DEPTH-1:0]] <= wr_dat;
end

// read side logic
always@(posedge clk) begin
	if(rst) begin
		out_pkts <= 0;
		rd_pos 	<= 0;
		out_tvalid <= 1'b0;
        out_tlast <= 1'b0;
        out_tdata <= 0;
	end else begin
		if(out_tvalid) begin
			if(out_tready) begin
				rd_pos 	<= (out_tlast) ? rd_pos : rd_pos + 1'b1;
				out_tlast <= (out_tlast) ? 1'b0 : r_data[rd_pos[SZ_DEPTH-1:0]][SZ_AXI_WIDTH-1];
				out_tdata <= (out_tlast) ? 0 : r_data[rd_pos[SZ_DEPTH-1:0]][63:0];
				out_pkts <= (out_tlast) ? out_pkts + 1'b1 : out_pkts;
				out_tvalid	<=  (out_tlast) ? 1'b0 : 1'b1;
			end else begin
				rd_pos 	<= rd_pos;
				out_tdata <= out_tdata;
				out_tlast <= out_tlast;
				out_tvalid	<= out_tvalid;
				out_pkts <= out_pkts;
			end
        end else begin
          	rd_pos 	<= (in_pkts - out_pkts != 0) ? rd_pos + 1'b1 : rd_pos;
			out_tlast <= (in_pkts - out_pkts != 0) ? r_data[rd_pos[SZ_DEPTH-1:0]][SZ_AXI_WIDTH-1] : 1'b0;
			out_tdata <= (in_pkts - out_pkts != 0) ? r_data[rd_pos[SZ_DEPTH-1:0]][63:0] : {64{1'b0}};
            out_tvalid <= (in_pkts - out_pkts != 0) ? 1'b1 : 1'b0;
			out_pkts <= out_pkts;
        end
	end
end

reg space_check;
reg [SZ_DEPTH:0] used;

always@(posedge clk) begin
	if(rst) begin
    	space_check <= 0;
		used <= 0;
	end else begin
		used <= (wr_start - rd_pos);
      space_check <= (DEPTH - used) > MAX_PKT_LEN ? 1'b1 : 1'b0;
	end
end

always@(posedge clk) begin
	if(rst) begin
		num_pkts_in <= 0;
		in_tready <= 1'b0;
		in_pkts <= 0;
		wr_ena <= 1'b0;
		wr_pos <= 0;
		wr_cnt <= 0;
		wr_start <= 0;
		in_state <= ST_IDLE;
	end else begin
		case(in_state)

		ST_IDLE: begin
			wr_pos <= wr_start + 2;
            wr_start <= wr_start;
          	in_pkts <= in_pkts;
			// Did we capture data?
			if(in_captured && ena) begin
			  num_pkts_in <= num_pkts_in + 1'b1;
              wr_cnt <= 2;
              if(max_pkt_len == 3)  begin
                wr_dat <= { 1'b1, in_tdata };
                in_tready <= 1'b0;
    	        in_state <= ST_WR_LEN;
				wr_ena <= 1'b1;
              end else begin
                wr_dat <= { 1'b0, in_tdata };
                in_tready <= 1'b1;
    	        in_state <= ST_DATA;
            	wr_ena <= 1'b1;
              end
			end else begin
              	wr_cnt <= 0;
				num_pkts_in <= num_pkts_in;
				in_tready <= (space_check) ? 1'b1 : 1'b0;
				in_state <= ST_IDLE;
				wr_ena <= 1'b0;
			end
		end

		ST_DATA: begin
			if(in_captured) begin

              if (in_tlast) begin
                in_tready 	<= 1'b0;
                in_state <= ST_WR_LEN;
                wr_start <= wr_start;
                wr_pos <= wr_pos + 1'b1;
                wr_ena <= 1'b1;
                wr_cnt <= wr_cnt + 1'b1;
                wr_dat <= {1'b1, in_tdata};
			  end else if (!ena || (wr_cnt > INT_MAX_SAMPLES)) begin
	        	// If enable goes low, finish up packet and send it
              	// can't drop packet, otherwise space_avail will no longer
              	// be valid
				in_tready 	<= 1'b0;
                in_state <= ST_IDLE;
                wr_start <= wr_start;
                wr_pos <= wr_start;
                wr_ena <= 1'b0;
                wr_cnt <= 0;
                wr_dat <= {1'b0, wr_dat[63:0]};
			  end else begin
				in_tready 	<= 1'b1;
				in_state <= ST_DATA;
                wr_start <= wr_start;
				wr_pos <= wr_pos + 1'b1;
				wr_ena <= 1'b1;
                wr_cnt <= wr_cnt + 1'b1;
                wr_dat <= {1'b0, in_tdata};
              end
			end else if (!ena) begin
				// Enable went low outside of a valid in word
				// finish up and re-write last data pos with tlast high
				in_tready 	<= 1'b0;
                in_state <= ST_IDLE;
                wr_start <= wr_start;
                wr_pos <= wr_start;
                wr_ena <= 1'b0;
                wr_cnt <= 0;
                wr_dat <= {1'b0, wr_dat[63:0]};
			end else begin
				// wait for data to continue
				// we store last word in case we have to go back and add
				// tlast to it
              	wr_dat <= wr_dat;
				in_tready <= 1'b1;
				in_state <= ST_DATA;
				wr_start <= wr_start;
				wr_pos <= wr_pos;
				wr_ena <= 1'b0;
				wr_cnt <= wr_cnt;
			end
			num_pkts_in <= num_pkts_in;
            in_pkts <= in_pkts;

		end

		ST_WR_LEN: begin
            in_pkts <= in_pkts;
			in_tready <= 1'b0;
			in_state <= ST_WR_UPDATE;
			wr_start <= wr_pos + 1'b1;
			wr_pos	<= wr_start;
			wr_ena 	<= 1'b1;
			wr_cnt	<= 0;
          	wr_dat	<= {1'b0, ID[7:0], 8'h0, num_pkts_in, wr_cnt[15:0]};
		end

        ST_WR_UPDATE: begin
            in_pkts <= in_pkts + 1'b1;
			in_tready <= 1'b0;
			in_state <= ST_IDLE;
			wr_start <= wr_start;
			wr_pos	<= wr_start;
			wr_ena 	<= 1'b0;
			wr_cnt	<= 0;
          	wr_dat	<= 0;
			num_pkts_in <= num_pkts_in;
		end

		default: begin
			num_pkts_in <= 0;
			in_tready <= 1'b0;
			in_pkts <= 0;
			wr_ena <= 1'b0;
			wr_pos <= 0;
			wr_cnt <= 0;
			wr_start <= 0;
			in_state <= ST_IDLE;
		end

		endcase

	end
end

endmodule