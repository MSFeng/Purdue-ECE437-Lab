`include "hazard_unit_if.vh"

// memory types
`include "cpu_types_pkg.vh"
 import cpu_types_pkg::*;

module hazard_unit (
  //	input logic CLK, nRST,
  	hazard_unit_if hzif
);

assign hzif.pipeline_tick = hzif.ihit | hzif.dhit;

//data hazard
assign hzif.src1_hazard_t = (hzif.src1_req_reg == hzif.forward1_set_reg && hzif.forward1_set_reg!=5'b00000) ? ((hzif.lw_instr) ? 2'b11 : 2'b01): ((hzif.src1_req_reg == hzif.forward2_set_reg && hzif.forward2_set_reg!=5'b00000) ? ((hzif.lw_instr_later) ? 3'b100 : 2'b10) : 2'b00);
assign hzif.src2_hazard_t = (hzif.src2_req_reg == hzif.forward1_set_reg && hzif.forward1_set_reg!=5'b00000) ? ((hzif.lw_instr) ? 2'b11 : 2'b01) : ((hzif.src2_req_reg == hzif.forward2_set_reg && hzif.forward2_set_reg!=5'b00000) ?  ((hzif.lw_instr_later) ? 3'b100 : 2'b10): 2'b00);

endmodule