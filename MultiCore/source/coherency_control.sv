`include "cache_control_if.vh"
// memory types
`include "cpu_types_pkg.vh"

module coherency_control
(
	input logic CLK,
	input logic nRST,
	input snoopchecking0,
	input snoopchecking1,
	cache_control_if ccif,
	output logic [1:0] snoopingTag
);
import cpu_types_pkg::*;

typedef enum{IDLE, SNOOP0, SNOOP1, WB_C0_0, WB_C0_1, WB_C1_0, WB_C1_1} state_type;

state_type state;
state_type n_state;

//set the snoopaddr
word_t snoopaddr0;
word_t n_snoopaddr0;
word_t snoopaddr1;
word_t n_snoopaddr1;
  
logic ccinv0;
logic n_ccinv0;
logic ccinv1;
logic n_ccinv1;

assign ccif.ccsnoopaddr[0] = snoopaddr0;
assign ccif.ccsnoopaddr[1] = snoopaddr1;

//assign ccif.ccinv[0] = ccif.ccwrite[1];
//assign ccif.ccinv[1] = ccif.ccwrite[0];
assign ccif.ccinv[0] = ccinv0;
assign ccif.ccinv[1] = ccinv1;
always_ff @ (posedge CLK, negedge nRST) 
begin
	if(!nRST)
	begin
		state <= IDLE;	
		snoopaddr0 <= 0;
		snoopaddr1 <= 0;
		ccinv0 <= 0;	
		ccinv1 <= 0;
	end	
	else 
	begin
		state <= n_state;
		snoopaddr0 <= n_snoopaddr0;
		snoopaddr1 <= n_snoopaddr1;
		ccinv0 <= n_ccinv0;
		ccinv1 <= n_ccinv1;
	end
end

always_comb
begin

	ccif.ccwait[0] = 0;
	ccif.ccwait[1] = 0;
	n_snoopaddr0 = snoopaddr0;
	n_snoopaddr1 = snoopaddr1;
	snoopingTag = 2'b10;
	n_state = state;
	ccif.cccofreetomove = 0;
	n_ccinv0 = ccinv0;
	n_ccinv1 = ccinv1;

	 unique casez (state)

		IDLE:
		begin
			ccif.cccofreetomove = 1;

			n_ccinv0 = ccif.ccwrite[1];
			n_ccinv1 = ccif.ccwrite[0];

			if(ccif.cctrans[0])
			begin
				n_state = SNOOP1;
				n_snoopaddr1 = ccif.daddr[0];
				ccif.ccwait[1] = 1; //block CPU for other cache for snoopy
			end
			else if (ccif.cctrans[1])
			begin
				n_state = SNOOP0;
				n_snoopaddr0 = ccif.daddr[1];
				ccif.ccwait[0] = 1;
			end
			else 
			begin
				n_state = IDLE;	
			end
		end

		SNOOP0:
		begin

			ccif.ccwait[0] = 1; //let the original wait
			snoopingTag = 2'b00;

			if (ccif.ccwrite[0]&&snoopchecking0)
			begin
				n_state = WB_C0_0;
			end
			else if (snoopchecking0)
			begin
				n_state = IDLE;
			end
			else 
			begin
				n_state = SNOOP0;
			end
		
		end

		SNOOP1:
		begin
			ccif.ccwait[1] = 1; 
			snoopingTag = 2'b01;

			if (ccif.ccwrite[1]&&snoopchecking1)
			begin
				n_state = WB_C1_0;
			end
			else if (snoopchecking1)
			begin
				n_state = IDLE;
			end
			else 
			begin
				n_state = SNOOP1;
			end
			//n_state = SNOOP1;
		end

		

		WB_C0_0:
		begin
			
			snoopingTag = 2'b00;
			ccif.ccwait[0] = 1;

			if(ccif.dwait[0])
			begin
				n_state = WB_C0_0;
			end
			else 
			begin
				n_state = WB_C0_1;
			end
		end

		WB_C0_1:
		begin
			snoopingTag = 2'b00;
			ccif.ccwait[0] = 1;

			if(ccif.dwait[0])
			begin
				n_state = WB_C0_1;
			end
			else 
			begin
				n_state = IDLE;
			end
		end

		WB_C1_0:
		begin
			snoopingTag = 2'b01;
			ccif.ccwait[1] = 1;

			if(ccif.dwait[1])
			begin
				n_state = WB_C1_0;
			end
			else 
			begin
				n_state = WB_C1_1;
			end
		end

		WB_C1_1:
		begin
			snoopingTag = 2'b01;
			ccif.ccwait[1] = 1;

			if(ccif.dwait[1])
			begin
				n_state = WB_C1_1;
			end
			else 
			begin
				n_state = IDLE;
			end
		end

	endcase
end

endmodule