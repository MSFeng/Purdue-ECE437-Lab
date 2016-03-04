// mapped needs this
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module coherency_control_tb;

  parameter PERIOD = 10;
  parameter WAIT = 1;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  cache_control_if ccif ();

  logic [1:0] snoopMatch;
  // test program
  test PROG (
  CLK,
  nRST,
  ccif,
  );
 
  // DUT
  coherency_control DUT(CLK,nRST,snoopMatch,ccif);

endmodule

program test(
  input logic CLK,
  output logic nRST,
  cache_control_if ccif,
);

parameter PERIOD = 10;

integer memfile;

initial begin
  //initial reset
  #4;
  nRST = 0;
  #(PERIOD)
  #(PERIOD)
  nRST = 1;
  ccif.daddr[0] = 32'hdeadbeef;
  ccif.daddr[1] = 32'hdeadbeee;

  ccif.dREN[0] = 1;//SNOOP1
  ccif.dREN[1] = 0;
  ccif.cctrans[0] = 1;
  ccif.cctrans[1] = 0;
  ccif.ccwrite[0] = 0;
  ccif.ccwrite[1] = 0;
  ccif.dwait[0] = 1;
  ccif.dwait[1] = 1;
  snoopMatch[0] = 0;
  snoopMatch[1] = 1;
  #(PERIOD)
  nRST = 1;
  ccif.dWEN[0] = 0;
  ccif.dWEN[1] = 0;
  ccif.ccwrite[0] = 0;
  ccif.ccwrite[1] = 0;
  ccif.ccinvdone[0] = 0;
  ccif.ccinvdone[1] = 0;
  ccif.ccwbdone[0] = 0;
  ccif.ccwbdone[1] = 0;
  snoopMatch[0] = 0;
  snoopMatch[1] = 1;
  #(PERIOD)
  nRST = 1;
  ccif.dREN[0] = 0;//IDLE
  ccif.dREN[1] = 0;
  ccif.ccwrite[0] = 0;
  ccif.ccwrite[1] = 0;

  ccif.dwait[0] = 0;
  ccif.dwait[1] = 0;

  #(PERIOD)





  ccif.dREN[0] = 0;//SNOOP0
  ccif.dREN[1] = 1;
  ccif.cctrans[0] = 0;
  ccif.cctrans[1] = 1;
  ccif.ccwrite[0] = 0;
  ccif.ccwrite[1] = 0;
  ccif.dwait[0] = 1;
  ccif.dwait[1] = 1;
 
  #(PERIOD)
  nRST = 1;
  ccif.dWEN[0] = 1; //WB0
  ccif.dWEN[1] = 0;
  ccif.ccwrite[0] = 0;
  ccif.ccwrite[1] = 0;
 
  #(PERIOD)
  nRST = 1;
  ccif.dREN[0] = 0;//IDLE
  ccif.dREN[1] = 0;
  ccif.ccwrite[0] = 0;
  ccif.ccwrite[1] = 0;
  ccif.dwait[0] = 0;
  ccif.dwait[1] = 0;
 
  #(PERIOD)



  

  #(PERIOD);
  #(PERIOD);
  $finish; 
end


endprogram