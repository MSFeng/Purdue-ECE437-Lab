/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "memory_request_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  word_t pc; //program counter
  word_t n_pc;

  word_t signedExtImm;
  word_t zeroExtImm;
  word_t luiImm;
  word_t shamt;

  //jump options
  word_t n_pc_p4;
  word_t n_pc_j;
  word_t n_pc_reg;
  word_t n_pc_br;

  //interfaces
  control_unit_if cuif();
  memory_request_if mrif();
  register_file_if rfif();
  alu_if alif();

  //DUT
  control_unit CU (cuif);
  memory_request MR (CLK, nRST, mrif);
  register_file RF (CLK, nRST, rfif);
  alu ALU (alif);

  logic pcEN;
  assign pcEN = dpif.ihit & (~dpif.dhit);

  always_ff @(posedge CLK, negedge nRST) begin
    if (!nRST) begin
      // reset
      pc <= 32'h00000000;
    end
    else begin
      /*if(cuif.MemToReg | cuif.MemWrite) //'
      begin
        if (dpif.dhit != 1) begin
          pc <= pc;
        end
        else begin
          pc <= n_pc;
        end
      end
      else begin
        if (dpif.ihit != 1) begin
          pc <= pc;
        end
        else begin
          pc <= n_pc;
        end
      end*/
      if (pcEN) begin
         pc <= n_pc;
      end
    end
  end

  assign signedExtImm = (dpif.imemload[15] == 0) ? {16'h0000, dpif.imemload[15:0]} : {16'hffff, dpif.imemload[15:0]};
  assign zeroExtImm = {16'h0000, dpif.imemload[15:0]};
  assign luiImm = {dpif.imemload[15:0], 16'h0000};
  assign shamt = {24'h000000, 3'b000, dpif.imemload[10:6]};

  //control unit setup
  assign cuif.Instr = dpif.imemload;

  //memory request setup
  assign mrif.MemToReg = cuif.MemToReg;
  assign mrif.MemWrite = cuif.MemWrite;
  assign mrif.dhit = dpif.dhit;
  assign mrif.ihit = dpif.ihit;

  //register file setup
  assign rfif.WEN = cuif.MemToReg ? ((dpif.dhit) ? cuif.RegWen : 0) : cuif.RegWen;
  assign rfif.wsel = (cuif.RegDst_t == 2'b00) ? dpif.imemload[15:11] : ((cuif.RegDst_t == 2'b01) ? dpif.imemload[20:16] : 5'b11111);
  assign rfif.rsel1 = dpif.imemload[25:21];
  assign rfif.rsel2 = dpif.imemload[20:16];
  assign rfif.wdat = cuif.PcToReg ? n_pc_p4 : ((cuif.MemToReg == 1) ? dpif.dmemload : alif.OutputPort);

  //alu setup
  assign alif.ALUOP = cuif.ALUOP;
  assign alif.PortA = rfif.rdat1;
  assign alif.PortB = (cuif.ALUSrc_t == 3'b000) ? rfif.rdat2 : ((cuif.ALUSrc_t == 3'b001) ? signedExtImm : ((cuif.ALUSrc_t == 3'b010) ? zeroExtImm : (cuif.ALUSrc_t == 3'b011) ? luiImm : shamt));

  //implement jump

  assign n_pc_p4 = pc+4;
  assign n_pc_j = {pc[31:28], dpif.imemload[25:0], 2'b00};
  assign n_pc_reg = rfif.rdat1;
  assign n_pc_br = (signedExtImm<<2) + n_pc_p4;

  always_comb
  begin
    n_pc = 0;
    if(cuif.jump_t == 3'b000)
    begin
      n_pc = n_pc_p4;
    end else if(cuif.jump_t == 3'b001)
    begin
      n_pc = n_pc_j;
    end else if(cuif.jump_t == 3'b010)
    begin
      n_pc = n_pc_reg;
    end else if (cuif.jump_t == 3'b011) 
    begin
      if(alif.Zero == 1)
      begin
        n_pc = n_pc_br;
      end else begin
        n_pc = n_pc_p4;
      end  
    end else if(cuif.jump_t == 3'b100)
    begin
      if(alif.Zero != 1)
      begin
        n_pc = n_pc_br;
      end else begin
        n_pc = n_pc_p4;
      end
    end
  end

  logic halt_reg;
  logic n_halt;
  always_ff @(posedge CLK, negedge nRST)
  begin
    if (!nRST) begin
      halt_reg <= 0;
    end
    else begin
      //halt_reg <= cuif.halt;
      halt_reg <= n_halt;
    end
  end

  assign n_halt = (cuif.careOF == 1) ? ((alif.Overflow == 1) ? 1 : 0) : cuif.halt;

 //memory and cpu
  assign dpif.halt = halt_reg;
  assign dpif.imemREN = 1;
  assign dpif.imemaddr = pc;
  assign dpif.dmemREN = mrif.dmemREN;
  assign dpif.dmemWEN = mrif.dmemWEN;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr = alif.OutputPort;

endmodule
