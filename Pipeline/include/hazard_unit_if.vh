`ifndef HARZ_IF_VH
`define HARZ_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  import cpu_types_pkg::*;

  //inputs
  //structure hazard
  logic dhit;
  logic ihit;

  //data hazard
  logic [4:0] src1_req_reg;
  logic [4:0] src2_req_reg;
  logic [4:0] forward1_set_reg;
  logic [4:0] forward2_set_reg;
  logic 	  lw_instr;
  logic     lw_instr_later;


  //outputs
  //structure hazard
  logic pipeline_tick;
  //data hazard
  //logic data_hazard;
  logic [2:0] src1_hazard_t; //0:no hazard 01:foward1 10:forward2
  logic [2:0] src2_hazard_t; //0:no hazard 01:foward1 10:forward2
  logic 	  stall_for_load;

endinterface


`endif