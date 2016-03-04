`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  aluop_t ALUOP;
  word_t    PortA, PortB, OutputPort;
  logic Negative, Overflow, Zero;
  
  // register file ports
  modport al (
    input   ALUOP, PortA, PortB,
    output  Negative, OutputPort, Overflow, Zero
  );
  // register file tb
  modport tb (
    input   Negative, OutputPort, Overflow, Zero,
    output  ALUOP, PortA, PortB
  );
endinterface

`endif //REGISTER_FILE_IF_VH
