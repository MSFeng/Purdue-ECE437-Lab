// mapped needs this
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;
  parameter WAIT = 1;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  cache_control_if ccif ();
  cpu_ram_if crif();

  // path throughs
  assign ccif.ramload =crif.ramload;
  assign ccif.ramstate = crif.ramstate;
  assign crif.ramstore = ccif.ramstore;
  assign crif.ramaddr = ccif.ramaddr;
  assign crif.ramWEN = ccif.ramWEN;
  assign crif.ramREN = ccif.ramREN;
 

  // test program
  test PROG (
  CLK,
  nRST,
  ccif
  );
 
  // DUT
  memory_control DUT(CLK,nRST,ccif);
  ram DUT2(CLK,nRST,crif);



endmodule

program test(
  input logic CLK,
  output logic nRST,
  cache_control_if ccif
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
  ccif.iaddr = 0;
  ccif.daddr = 0; //word to byte addr
  ccif.iREN = 0;
  ccif.dWEN = 0;
  ccif.dREN = 0;
  #(PERIOD)
  #(PERIOD)
  //read 20 instructions from addr:0x00000000
  $display("read 20 instructions");
  for (int i = 0; i < 20; i++)
  begin
    ccif.iaddr = i << 2; //word to byte addr
    ccif.iREN = 1'b1;
    ccif.dWEN = 1'b0;
    ccif.dREN = 1'b0;
    #(PERIOD);
  end

  //load datas from addr:0x00f0
  $display("load 4 datas start from 0x00f0");
  for (int i = 0; i < 4; i++)
  begin
    ccif.daddr = (i << 2) + 16'h00f0; //word to byte addr
    ccif.iREN = 1'b0;
    ccif.dWEN = 1'b0;
    ccif.dREN = 1'b1;
    #(PERIOD);
  end

  //write datas from addr:0x0080
  $display("write 5 datas start from 0x0080");
  for (int i = 0; i < 5; i++)
  begin
    ccif.daddr = (i << 2) + 16'h0080; //word to byte addr
    ccif.iREN = 1'b0;
    ccif.dWEN = 1'b1;
    ccif.dREN = 1'b0;
    ccif.dstore = i + 16'h0a00;
    #(PERIOD);
    #(PERIOD);
  end

  //load datas from addr:0x0080
  $display("load 5 datas start from 0x0080");
  for (int i = 0; i < 5; i++)
  begin
    ccif.daddr = (i << 2) + 16'h0080; //word to byte addr
    ccif.iREN = 1'b0;
    ccif.dWEN = 1'b0;
    ccif.dREN = 1'b1;
    #(PERIOD);
    //#(PERIOD);
  end

  //dumpmemory
  $display("start dumping memory");
  memfile = $fopen("MemDumpLog.txt","w");
  for (int i = 0; i < 20; i++)
  begin
    ccif.iaddr = i << 2; //word to byte addr
    ccif.iREN = 1'b1;
    ccif.dWEN = 1'b0;
    ccif.dREN = 1'b0;
    #(PERIOD);
    $fdisplay(memfile,"Location: 0x%h, Content: 0x%h", i<<2, ccif.ramload);
  end
  $fclose(memfile);

  //load instruction and data at same time
   $display("should read data value");
  ccif.iaddr = 0;
  ccif.daddr = 16'h0080; //word to byte addr
  ccif.iREN = 1'b1;
  ccif.dWEN = 1'b0;
  ccif.dREN = 1'b1;

  #(PERIOD);
  #(PERIOD);
  $finish; 
end


endprogram