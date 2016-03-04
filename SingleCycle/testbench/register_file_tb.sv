/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;
  parameter WAIT = 1;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();

  // test program
  test PROG (
  CLK,
  nRST,
  rfif
  );
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(
  input logic CLK,
  output logic nRST,
  register_file_if.tb tbif
);

initial begin
  
  //initial reset
  #1;
  nRST = 0;
  
  //first write
  @(negedge CLK);
  nRST = 1;
  tbif.wsel = 5'b00001;
  tbif.wdat = 32'h0f0f;
  tbif.WEN = 1'b1;
  tbif.rsel1 = 5'b00000;
  tbif.rsel2 = 5'b00001;
  
  @(negedge CLK);
  tbif.wsel = 5'b00000;
  tbif.wdat = 32'h1234;
  tbif.WEN = 1'b1;
  tbif.rsel1 = 5'b00001;
  tbif.rsel2 = 5'b00000;
  
  //WEN test
  @(negedge CLK);
  tbif.wsel = 5'b00001;
  tbif.wdat = 32'hffff;
  tbif.WEN = 1'b0;
  tbif.rsel1 = 5'b00001;
  tbif.rsel2 = 5'b01000;
  
  //zero addr test
   @(negedge CLK);
  tbif.rsel1 = 5'b00000;
  tbif.rsel2 = 5'b00000;
  
  //second reset test
  @(negedge CLK);
 // nRST = 0;
  tbif.rsel1 = 5'b00001;
  tbif.rsel2 = 5'b01000;
  
  //boundery test
  @(negedge CLK);
  nRST = 1;
  tbif.wsel = 5'b11111;
  tbif.wdat = 32'hffffabcf;
  tbif.WEN = 1'b1;
  tbif.rsel1 = 5'b11111;
  tbif.rsel2 = 5'b11111;
  
   @(posedge CLK);
   @(posedge CLK);
  
  $finish;  
end

endprogram
