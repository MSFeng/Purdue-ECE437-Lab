// interface
`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module register_file (
  
  input logic CLK,
  input logic nRST,
  register_file_if.rf rfif
  
  );
  
  word_t [31:0] regs;
 // word_t n_dat;
 // word_t n_loc;
  
  always_ff @(posedge CLK or negedge nRST)
  begin
    if(!nRST)
    begin
      regs <= '{default:0}; //'
    end
    else 
    if (rfif.WEN == 1) 
    begin
      regs[rfif.wsel] <= rfif.wdat;
    end
  end
  
 // assign n_dat = irf.WEN ? (irf.wdat) : (0x00000000);
 // assign n_loc = irf.WEN ? (irf.wsel) : (0);
  assign rfif.rdat1 = rfif.rsel1 ? regs[rfif.rsel1] : 0;
  assign rfif.rdat2 = rfif.rsel2 ? regs[rfif.rsel2] : 0;
  
  endmodule