// mapped needs this
`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module control_unit_tb;

  parameter PERIOD = 10;
  parameter WAIT = 1;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  control_unit_if cuif ();
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
  test control_unit (
    CLK,
    nRST,
    cuif
  );
 
  // DUT
  //memory_control DUT(CLK,nRST,ccif);
  //ram DUT2(CLK,nRST,crif);
  control_unit DUT(cuif);

endmodule

program test(
  input logic CLK,
  output logic nRST,
  control_unit_if cuif
);

parameter PERIOD = 10;

integer memfile;

initial begin
  //initial reset
  #4;
  cuif.Instr = 32'h340100F0;
  #(PERIOD);
  cuif.Instr = 32'h34020080;
  #(PERIOD);
  cuif.Instr = 32'h3C07DEAD;
  #(PERIOD);
  cuif.Instr = 32'h8C250008;
  #(PERIOD);
  cuif.Instr = 32'hAC47000C;
  #(PERIOD);
  $finish; 
end


endprogram