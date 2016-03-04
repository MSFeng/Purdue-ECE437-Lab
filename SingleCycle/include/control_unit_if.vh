`ifndef CONTR_UNIT_IF_VH
`define CONTR_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface control_unit_if;
  import cpu_types_pkg::*;

  //input
  logic [31:0] Instr;

  //outputs
  logic [2:0]jump_t;
  logic [1:0] RegDst_t; //choose dst srouce between Rd and Rt and 31
  logic RegWen; //Enanle when need to write to register
  logic [2:0] ALUSrc_t; //choose between a register source and an Imediation source and shamt
  aluop_t ALUOP;
  logic MemToReg; //choose between a result from memory and alu result
  logic PcToReg;
  logic MemWrite; //data write enable
  logic careOF;
  logic halt;

endinterface


`endif