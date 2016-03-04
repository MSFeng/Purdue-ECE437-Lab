`ifndef MEM_REQ_IF_VH
`define MEM_REQ_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface memory_request_if;
  import cpu_types_pkg::*;

  //input
  logic MemToReg;
  logic MemWrite;
  logic dhit;
  logic ihit;

  //outputs
  logic dmemREN;
  logic dmemWEN;

endinterface


`endif