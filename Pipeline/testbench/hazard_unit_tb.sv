// mapped needs this
`include "hazard_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 10;
  parameter WAIT = 1;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  hazard_unit_if hzif ();
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
    hzif
  );
 
  // DUT
  //memory_control DUT(CLK,nRST,ccif);
  //ram DUT2(CLK,nRST,crif);
  hazard_unit DUT(hzif);

endmodule

program test(
  input logic CLK,
  output logic nRST,
  hazard_unit_if hzif
);

parameter PERIOD = 10;

integer memfile;

initial begin
  //initial reset
  #4;
  hzif.ihit = 0;
  hzif.dhit = 0;
  hzif.src1_req_reg = 5'b00001;
  hzif.src2_req_reg = 5'b00010;
  hzif.forward1_set_reg = 5'b00001;
  hzif.forward2_set_reg = 5'b00010;
 
  #(PERIOD);
  hzif.ihit = 1;
  hzif.dhit = 0;
  hzif.src1_req_reg = 5'b00001;
  hzif.src2_req_reg = 5'b00010;
  hzif.forward1_set_reg = 5'b00001;
  hzif.forward2_set_reg = 5'b00010;
  
  #(PERIOD);
   hzif.ihit = 1;
  hzif.dhit = 1;
  hzif.src1_req_reg = 5'b00000;
  hzif.src2_req_reg = 5'b00000;
  hzif.forward1_set_reg = 5'b00000;
  hzif.forward2_set_reg = 5'b00000;
  #(PERIOD);
  hzif.ihit = 1;
  hzif.dhit = 0;
  hzif.src1_req_reg = 5'b00001;
  hzif.src2_req_reg = 5'b00010;
  hzif.forward1_set_reg = 5'b00001;
  hzif.forward2_set_reg = 5'b00010;
  
  #(PERIOD);
  hzif.ihit = 1;
  hzif.dhit = 1;
  hzif.src1_req_reg = 5'b00001;
  hzif.src2_req_reg = 5'b00010;
  hzif.forward1_set_reg = 5'b00001;
  hzif.forward2_set_reg = 5'b00010;
  
  #(PERIOD);
  hzif.ihit = 0;
  hzif.dhit = 0;
  hzif.src1_req_reg = 5'b00001;
  hzif.src2_req_reg = 5'b00001;
  hzif.forward1_set_reg = 5'b00001;
  hzif.forward2_set_reg = 5'b00001;
 
 #(PERIOD);
 #(PERIOD);
  $finish; 
end


endprogram