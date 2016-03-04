// cpu types
`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns
module dcache_tb;
import cpu_types_pkg::*;

parameter PERIOD = 10;
parameter CPUID = 0;
logic CLK = 0, nRST;
// clock
always #(PERIOD/2) CLK++;
// interface
cache_control_if ccif ();
datapath_cache_if dcif ();
// test program
test #(.PERIOD(PERIOD), .CPUID(CPUID)) PROG (CLK, nRST, ccif, dcif);
// DUT
//`ifndef MAPPED
dcache DUT(CLK, nRST, ccif, dcif);


endmodule




program test (
input logic CLK,
output logic nRST,
cache_control_if.dcachetb ccif,
datapath_cache_if.dcachetb dcif
);

parameter CPUID = 0;
parameter PERIOD = 10;
initial begin: TEST

ccif.dwait = 1'b0;
ccif.dload = 1'b0;




nRST = 1'b0;
#(PERIOD*1);
@(posedge CLK);
nRST = 1'b1;
#(PERIOD*1);
//load something into the cache
dcif.dmemaddr = 32'h00000000;
dcif.dmemstore = 32'hdeadbeef;
dcif.dmemREN = 1'b1;
dcif.dmemWEN = 1'b0;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'hffffffff;

/*#(PERIOD*2);
@(negedge CLK);
ccif.dload[CPUID] = 32'h00000000;
@(posedge dcif.dhit);
@(posedge CLK);
dcif.dmemREN = 1'b0;*/

@(posedge dcif.dhit);

#(PERIOD*1);
//load something into the other way
dcif.dmemaddr = 32'hffff0000;
dcif.dmemstore = 32'hdeadbeef;
dcif.dmemREN = 1'b1;
dcif.dmemWEN = 1'b0;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'h0000ffff;

@(posedge dcif.dhit);

#(PERIOD*2);

/*@(negedge CLK);
ccif.dload[CPUID] = 32'hffff0000;
@(posedge dcif.dhit);
@(posedge CLK);
dcif.dmemREN = 1'b0;
*/

#(PERIOD*2);
//read next index from RAM
dcif.dmemaddr = 32'b00000000000000000000000000_001_0_00;
dcif.dmemstore = 32'hbad1bad1;
dcif.dmemREN = 1'b1;
dcif.dmemWEN = 1'b0;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'h00000000;

@(posedge dcif.dhit);

/*#(PERIOD*2);
@(negedge CLK);
ccif.dload[CPUID] = 32'hffffffff;
@(posedge dcif.dhit);
@(posedge CLK);
*/

dcif.dmemREN = 1'b0;
#(PERIOD*1);
//write to data already in cache
dcif.dmemaddr = 32'b00000000000000000000000000_001_0_00;
dcif.dmemstore = 32'hffff0000;
dcif.dmemREN = 1'b0;
dcif.dmemWEN = 1'b1;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'hbad1bad1;
@(posedge dcif.dhit);
dcif.dmemWEN = 1'b0;


#(PERIOD*2);
//consecutive read hits
dcif.dmemaddr = 32'b00000000000000000000000000_001_0_00;
dcif.dmemstore = 32'hffff0000;
dcif.dmemREN = 1'b1;
dcif.dmemWEN = 1'b0;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'hbad1bad1;
@(posedge dcif.dhit);
//dcif.dmemREN = 1'b0;


#(PERIOD*2);
dcif.dmemREN = 1'b0;
//write to data not in cache
dcif.dmemaddr = 32'b00000000000000000000000000_010_0_00;
dcif.dmemstore = 32'hf0faf0f0;
dcif.dmemREN = 1'b0;
dcif.dmemWEN = 1'b1;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'hbad1bad1;
#(PERIOD*2);

//@(posedge dcif.dhit);
//dcif.dmemWEN = 1'b0;


#(PERIOD*1);
//datapath read hit way0
dcif.dmemaddr = 32'b00000000000000000000000000_000_0_00;
dcif.dmemstore = 32'hbad1bad1;
dcif.dmemREN = 1'b1;
dcif.dmemWEN = 1'b0;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload[CPUID] = 32'hbad1bad1;


#(PERIOD*1);
//datapath read hit way1
dcif.dmemaddr = 32'hffff0000;
dcif.dmemstore = 32'hbad1bad1;
dcif.dmemREN = 1'b1;
dcif.dmemWEN = 1'b0;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'hbad1bad1;
#(PERIOD*1);
dcif.dmemREN = 1'b0;


#(PERIOD*1);
//eviction on read clean
dcif.dmemaddr = 32'b10101010101000000000000000_000_0_00; // should replace way0, index0
dcif.dmemstore = 32'hbad1bad1;
dcif.dmemREN = 1'b1;
dcif.dmemWEN = 1'b0;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'h10101010;


#(PERIOD*1);
//eviction on write clean
dcif.dmemaddr = 32'b01010101010100000000000000_000_0_00; // should replace way1, index0
dcif.dmemstore = 32'hFEEDBEEF;
dcif.dmemREN = 1'b0;
dcif.dmemWEN = 1'b1;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'hbad1bad1;
#(PERIOD*2); // 

//write banother
#(PERIOD*2);
dcif.dmemREN = 1'b0;
//write to data not in cache
dcif.dmemaddr = 32'b00001111000000000000000000_010_0_00;
dcif.dmemstore = 32'hf0fffff0;
dcif.dmemREN = 1'b0;
dcif.dmemWEN = 1'b1;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'hbad1bad1;
#(PERIOD*2);


//write back
#(PERIOD*2);
dcif.dmemREN = 1'b0;
//write to data not in cache
dcif.dmemaddr = 32'b00001110000000000000000000_010_0_00;
dcif.dmemstore = 32'hfafffffa;
dcif.dmemREN = 1'b0;
dcif.dmemWEN = 1'b1;
dcif.halt = 1'b0;
ccif.dwait = 1'b0;
ccif.dload = 32'hbad1bad1;
#(PERIOD*2);

//flush
//write back
#(PERIOD*2);
dcif.dmemREN = 1'b0;
//write to data not in cache
dcif.dmemaddr = 32'b00001111110000000000000000_100_0_00;
dcif.dmemstore = 32'hfafffffa;
dcif.dmemREN = 1'b0;
dcif.dmemWEN = 1'b0;
dcif.halt = 1'b1;
ccif.dwait = 1'b0;
ccif.dload = 32'hbad1bad1;
#(PERIOD*2);


#(PERIOD*4);
#(PERIOD*4);
#(PERIOD*4);
#(PERIOD*4);
#(PERIOD*4);
#(PERIOD*4);
#(PERIOD*4);

end
endprogram


