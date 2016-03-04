`include "memory_request_if.vh"

// memory types
`include "cpu_types_pkg.vh"
 import cpu_types_pkg::*;

module memory_request (
  	input logic CLK, nRST,
  	memory_request_if mrif
);

logic dmemRENreg;
logic dmemWENreg;
logic dmemRENnext;
logic dmemWENnext;

always_ff @(posedge CLK, negedge nRST) begin
	if (nRST == 0) begin
		// reset
		dmemRENreg <= 0;
		dmemWENreg <= 0;	
	end
	else
	begin
		dmemRENreg <= dmemRENnext;
		dmemWENreg <= dmemWENnext;
	end
end

always_comb
	begin
		if (mrif.dhit) begin
			dmemRENnext = 0;
			dmemWENnext = 0;
		end
		else if (mrif.ihit)
		begin
			dmemRENnext = mrif.MemToReg;
			dmemWENnext = mrif.MemWrite;
		end
		else 
		begin
			dmemRENnext = dmemRENreg;
			dmemWENnext = dmemWENreg;	
		end
	end


assign mrif.dmemREN = dmemRENreg;
assign mrif.dmemWEN = dmemWENreg;

/*
logic dmemRENreg;
logic dmemWENreg;

always_ff @(posedge CLK, negedge nRST) begin
	if (nRST == 0) begin
		// reset
		dmemRENreg <= 0;
		dmemWENreg <= 0;	
	end
	else 
	begin
		
		if (mrif.dhit == 1) begin
			dmemRENreg <= 0;
			dmemWENreg <= 0;
		end
		else begin
			dmemRENreg <= mrif.MemToReg;
			dmemWENreg <= mrif.MemWrite;
		end
	end
end

assign mrif.dmemREN = dmemRENreg;
assign mrif.dmemWEN = dmemWENreg;
*/
endmodule