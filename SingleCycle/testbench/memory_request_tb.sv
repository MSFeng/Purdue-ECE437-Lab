// mapped needs this
`include "memory_request_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_request_tb;

  parameter PERIOD = 10;
  parameter WAIT = 1;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  memory_request_if mrif ();
  //cpu_ram_if crif();

  // path throughs
  /*assign ccif.ramload =crif.ramload;
  assign ccif.ramstate = crif.ramstate;
  assign crif.ramstore = ccif.ramstore;
  assign crif.ramaddr = ccif.ramaddr;
  assign crif.ramWEN = ccif.ramWEN;
  assign crif.ramREN = ccif.ramREN;
 */

  // test program
  test TEST (
    CLK,
    nRST,
    mrif
  );
 
  // DUT
  //memory_control DUT(CLK,nRST,ccif);
  //ram DUT2(CLK,nRST,crif);
  memory_request DUT(CLK, nRST, mrif);

endmodule

program test(
  input logic CLK,
  output logic nRST,
  memory_request_if mrif
);

parameter PERIOD = 10;

integer memfile;

initial begin
  //initial reset
  #4;
  mrif.ihit = 1;
  mrif.dhit = 0;
  mrif.MemToReg = 0;
  mrif.MemWrite = 0;
  #(PERIOD);
  mrif.ihit = 1;
  mrif.dhit = 0;
  mrif.MemToReg = 1;
  mrif.MemWrite = 0;
  #(PERIOD);
    mrif.ihit = 1;
  mrif.dhit = 0;
  mrif.MemToReg = 0;
  mrif.MemWrite = 1;
  #(PERIOD);
  mrif.ihit = 0;
  mrif.dhit = 1;
  mrif.MemToReg = 1;
  mrif.MemWrite = 0;
  #(PERIOD);
  mrif.ihit = 0;
  mrif.dhit = 1;
  mrif.MemToReg = 0;
  mrif.MemWrite = 1;
  #(PERIOD);
  mrif.ihit = 0;
  mrif.dhit = 0;
  mrif.MemToReg = 0;
  mrif.MemWrite = 0;
 #(PERIOD);
 #(PERIOD);
  $finish; 
end


endprogram