
// cpu types
`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"


// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns
module icache_tb;
import cpu_types_pkg::*;
parameter PERIOD = 10;
logic CLK = 0, nRST;
// clock
always #(PERIOD/2) CLK++;
// interface
cache_control_if ccif ();
datapath_cache_if dcif ();

logic dmemREN;
logic dmemWEN;
logic halt;

// test program
test PROG (CLK, nRST, dmemREN, dmemWEN, halt, ccif, dcif);
// DUT
`ifndef MAPPED
icache DUT(CLK, nRST, dmemREN, dmemWEN, halt, ccif, dcif);
`else
icache DUT(
.\ccif.iwait(ccif.iwait),
.\ccif.iload(ccif.iload),
.\ccif.iREN(ccif.iREN),
.\ccif.iaddr(ccif.iaddr),
.\dcif.imemREN(dcif.imemREN),
.\dcif.imemaddr(dcif.imemaddr),
.\dcif.ihit(dcif.ihit),
.\dcif.imemload(dcif.imemload),
.\nRST (nRST),
.\CLK (CLK)
);

`endif
endmodule
program test (
input logic CLK,
output logic nRST,
output logic dmemREN,
output logic dmemWEN,
output logic halt,
cache_control_if.icachetb ccif,
datapath_cache_if.icachetb dcif
);

parameter PERIOD = 10;
initial begin: TEST

dmemREN = 0;
dmemWEN = 0;
halt = 0;

nRST = 1'b0;
#(PERIOD*1);
nRST = 1'b1;
#(PERIOD*1);
dcif.imemREN = 0;
dcif.imemaddr = 0;
ccif.iwait = 0;
ccif.iload = 0;
#(PERIOD*1);
//add something to the cache
dcif.imemREN = 1;
dcif.imemaddr = '0;//'
ccif.iwait = 0;
ccif.iload = '1; //'
#(PERIOD*1);
//read entry in cache
dcif.imemREN = 1;
dcif.imemaddr = 0;
ccif.iwait = 0;
ccif.iload = '0; //'
#(PERIOD*1);
//fill address 1
dcif.imemREN = 1;
dcif.imemaddr = 1*4;
ccif.iwait = 0;
ccif.iload = '0; //'
#(PERIOD*1);
//fill address 2
dcif.imemREN = 1;
dcif.imemaddr = 2*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 3
dcif.imemREN = 1;
dcif.imemaddr = 3*4;
ccif.iwait = 0;
ccif.iload = '0; //'
#(PERIOD*1);
//fill address 4
dcif.imemREN = 1;
dcif.imemaddr = 4*4;
ccif.iwait = 0;
ccif.iload = '0; //'
#(PERIOD*1);
//fill address 5
dcif.imemREN = 1;
dcif.imemaddr = 5*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 6
dcif.imemREN = 1;
dcif.imemaddr = 6*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 7
dcif.imemREN = 1;
dcif.imemaddr = 7*4;
ccif.iwait = 0;
ccif.iload = '0; //'
#(PERIOD*1);
//fill address 8
dcif.imemREN = 1;
dcif.imemaddr = 8*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 9
dcif.imemREN = 1;
dcif.imemaddr = 9*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 10
dcif.imemREN = 1;
dcif.imemaddr = 10*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 11
dcif.imemREN = 1;
dcif.imemaddr = 11*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 12
dcif.imemREN = 1;
dcif.imemaddr = 12*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 13
dcif.imemREN = 1;
dcif.imemaddr = 13*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 14
dcif.imemREN = 1;
dcif.imemaddr = 14*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//fill address 15
dcif.imemREN = 1;
dcif.imemaddr = 15*4;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//replace address 0
dcif.imemREN = 1;
dcif.imemaddr = 32'hffff0000;
ccif.iwait = 0;
ccif.iload = '0;//'
#(PERIOD*1);
//wait for RAM
dcif.imemREN = 1;
dcif.imemaddr = 3;
ccif.iwait = 1;
ccif.iload = '0;//'
#(PERIOD*5);
ccif.iwait = 0;
#(PERIOD*1);
//read entry in cache
dcif.imemREN = 1;
dcif.imemaddr = 10*4;
ccif.iwait = 0;
ccif.iload = '0; //'
#(PERIOD*1);
#(PERIOD*1);
end
endprogram

  

