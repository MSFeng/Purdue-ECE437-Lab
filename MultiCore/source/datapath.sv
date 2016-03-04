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
`include "pipeline_registers_if.vh"
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
  //memory_request_if mrif();
  hazard_unit_if hzif();
  register_file_if rfif();
  alu_if alif();
  pipeline_registers_if plif();

  //DUT
  control_unit CU (cuif);
  hazard_unit HZ (hzif);
  //memory_request MR (CLK, nRST, mrif);
  register_file RF (CLK, nRST, rfif);
  alu ALU (alif);
  pipeline_registers PR (CLK, nRST, plif);

  logic pcEN;
  //assign pcEN = dpif.ihit & (~dpif.dhit);
  always_comb 
  begin
    pcEN = 0;
    if(plif.branching)
    begin
      if ((dpif.ihit | dpif.dhit)&(!(plif.lw_hazard|plif.lw_later_hazard))) begin
        pcEN = 1;
      end
    end
    else begin
       pcEN = dpif.ihit&(~dpif.dhit);
    end
  end

  always_ff @(posedge CLK, negedge nRST) begin
    if (!nRST) begin
      // reset
      pc <= PC_INIT;
    end
    else begin
      if (pcEN) begin
         pc <= n_pc;
      end
    end
  end


  //Instruction Fetch
  assign plif.IF_Instr_IN =(dpif.ihit) ? dpif.imemload : '0;//'
  assign plif.IF_NPC_IN = n_pc_p4;

  //Instruction Decode
  assign signedExtImm = (plif.IF_Instr_OUT[15] == 0) ? {16'h0000, plif.IF_Instr_OUT[15:0]} : {16'hffff, plif.IF_Instr_OUT[15:0]};
  assign zeroExtImm = {16'h0000, plif.IF_Instr_OUT[15:0]};
  assign luiImm = {plif.IF_Instr_OUT[15:0], 16'h0000};
  assign shamt = {24'h000000, 3'b000, plif.IF_Instr_OUT[10:6]};

  //assign plif.ID_PC_PLUS_IN = signedExtImm;
  logic real_data1; //real rdat1 from register file
  logic real_data2; //real rdat2 from register file

  assign plif.ID_jump_t_IN = cuif.jump_t;
  assign plif.ID_RegDst_t_IN = cuif.RegDst_t;
  assign plif.ID_RegWen_IN = cuif.RegWen;
  assign plif.ID_ALUSrc1_IN = (rfif.rsel1 == rfif.wsel&&rfif.rsel1 != 0) ? rfif.wdat : rfif.rdat1;
  assign plif.ID_ALUSrc2_IN = (cuif.ALUSrc_t == 3'b000) ? ((rfif.rsel2 == rfif.wsel && rfif.rsel2 != 0) ? rfif.wdat : rfif.rdat2) : ((cuif.ALUSrc_t == 3'b001) ? signedExtImm : ((cuif.ALUSrc_t == 3'b010) ? zeroExtImm : (cuif.ALUSrc_t == 3'b011) ? luiImm : shamt));
  assign plif.ID_RegDat2_IN = rfif.rdat2;
  assign plif.ID_ALUOP_IN = cuif.ALUOP;
  assign plif.ID_MemToReg_IN = cuif.MemToReg;
  assign plif.ID_PcToReg_IN = cuif.PcToReg;
  assign plif.ID_MemWrite_IN = cuif.MemWrite;
  assign plif.ID_careOF_IN = cuif.careOF;
  assign plif.ID_halt_IN = cuif.halt;
  assign plif.ID_hazard_care_RT_IN = cuif.careAboutRT;
  assign plif.ID_Atomic_IN = cuif.Atomic;


  //Excute
  assign n_pc_p4 = pc+4;
  assign n_pc_j = {pc[31:28], plif.ID_Instr_OUT[25:0], 2'b00};
  //assign n_pc_reg = rfif.rdat1;
  //assign n_pc_reg = plif.ID_ALUSrc1_OUT;
  logic [31:0] br_offset;
  assign br_offset = (plif.ID_Instr_OUT[15] == 0) ? {16'h0000, plif.ID_Instr_OUT[15:0]} : {16'hffff, plif.ID_Instr_OUT[15:0]};
  assign n_pc_br = (br_offset<<2) + plif.ID_NPC_OUT;
  always_comb
  begin
     n_pc_reg = '0;//'

    if (hzif.src1_hazard_t == 2'b00) 
    begin
        n_pc_reg = plif.ID_ALUSrc1_OUT;
    end else if (hzif.src1_hazard_t == 2'b01) 
    begin
        n_pc_reg = plif.EX_Result_OUT;
    end else if (hzif.src1_hazard_t == 2'b10) 
    begin
        //n_pc_reg = plif.MEM_CalcData_OUT;
        n_pc_reg = (plif.MEM_MemToReg_OUT == 1) ? plif.MEM_ReadData_OUT : plif.MEM_CalcData_OUT;
    end
  end


//  assign plif.EX_NPC_IN = 
  always_comb
  begin
    n_pc = 0;
    plif.branching = 0;
    if(plif.ID_jump_t_OUT == 3'b000)
    begin
      n_pc = n_pc_p4;
    end else if(plif.ID_jump_t_OUT == 3'b001)
    begin
      n_pc = n_pc_j;
      plif.branching = 1;
    end else if(plif.ID_jump_t_OUT == 3'b010)
    begin
      n_pc = n_pc_reg;
      plif.branching = 1;
    end else if (plif.ID_jump_t_OUT == 3'b011) 
    begin
      if(alif.Zero == 1)
      begin
        n_pc = n_pc_br;
        plif.branching = 1;
      end else begin
        n_pc = n_pc_p4;
      end  
    end else if(plif.ID_jump_t_OUT== 3'b100)
    begin
      if(alif.Zero != 1)
      begin
        n_pc = n_pc_br;
        plif.branching = 1;
      end else begin
        n_pc = n_pc_p4;
      end
    end
  end

  assign plif.EX_Result_IN = (plif.ID_jump_t_OUT == 3'b001) ?  plif.ID_NPC_OUT : alif.OutputPort;
  assign plif.EX_RegDst_IN = (plif.ID_RegDst_t_OUT == 2'b00) ? plif.ID_Instr_OUT[15:11] : ((plif.ID_RegDst_t_OUT == 2'b01) ?  plif.ID_Instr_OUT[20:16] : 5'b11111);
  always_comb
  begin
     plif.EX_Wdata_IN = '0;//'

    if (hzif.src2_hazard_t == 2'b00) 
    begin
        plif.EX_Wdata_IN = plif.ID_RegDat2_OUT;
    end else if (hzif.src2_hazard_t == 2'b01) 
    begin
        //plif.EX_Wdata_IN = plif.EX_Result_OUT; 
        if(dpif.datomicSTATE == 2'b10)
        begin
           plif.EX_Wdata_IN = plif.EX_Result_OUT;
         end 
         else 
         begin
           plif.EX_Wdata_IN = dpif.datomicSTATE;
         end
       
    end else if (hzif.src2_hazard_t == 2'b10) 
    begin
        //plif.EX_Wdata_IN = (plif.MEM_MemToReg_OUT == 1) ? plif.MEM_ReadData_OUT : plif.MEM_CalcData_OUT;
        if (plif.MEM_MemToReg_OUT == 1)
        begin
          plif.EX_Wdata_IN = plif.MEM_ReadData_OUT;
        end
        else if (plif.MEM_AtomicSTATE_OUT != 2'b10) 
        begin
          plif.EX_Wdata_IN = plif.MEM_AtomicSTATE_OUT;
        end
        else 
        begin
          plif.EX_Wdata_IN = plif.MEM_CalcData_OUT;
        end
    end
  end

  //MEM
  assign plif.MEM_ReadData_IN = dpif.dmemload;
  assign plif.MEM_AtomicSTATE_IN = dpif.datomicSTATE;

  //tick signal
  assign plif.tick = hzif.pipeline_tick;
  assign plif.lw_hazard = (hzif.src1_hazard_t == 2'b11 || hzif.src2_hazard_t == 2'b11) ? 1 : 0;
  assign plif.lw_later_hazard = (hzif.src1_hazard_t == 3'b100) ? 2'b01 : ((hzif.src2_hazard_t == 3'b100) ? 2'b10 : 2'b00);
  ////////////////////////////////////////////////////////


  //control unit
  assign cuif.Instr = plif.IF_Instr_OUT;


  //hazard unit setup
  assign hzif.ihit = dpif.ihit;
  assign hzif.dhit = dpif.dhit;

  assign hzif.src1_req_reg = plif.ID_Instr_OUT[25:21];
  assign hzif.src2_req_reg = (plif.ID_hazard_care_RT_OUT) ? plif.ID_Instr_OUT[20:16] : '0;//'
  assign hzif.forward1_set_reg = (plif.EX_RegWen_OUT) ? plif.EX_RegDst_OUT : '0;//'
  assign hzif.forward2_set_reg = (plif.MEM_RegWen_OUT) ? plif.MEM_RegDst_OUT : '0;//'

  logic EX_MEMREG;
  logic MEM_MEMREG;
  assign EX_MEMREG = plif.EX_MemToReg_OUT||(plif.EX_MemWrite_OUT&&plif.EX_Atomic_OUT);
  assign MEM_MEMREG = EX_MEMREG && (plif.MEM_MemToReg_OUT || (plif.MEM_AtomicSTATE_OUT != 2'b10));
  //assign hzif.lw_instr = plif.EX_MemToReg_OUT;
  assign hzif.lw_instr = EX_MEMREG;
  assign hzif.lw_instr_later = MEM_MEMREG;


  //register file
  assign rfif.WEN = plif.MEM_MemToReg_OUT ? (1 ? plif.MEM_RegWen_OUT : 0) : plif.MEM_RegWen_OUT;
  assign rfif.wsel = plif.MEM_RegDst_OUT;
  assign rfif.rsel1 = plif.IF_Instr_OUT[25:21];
  assign rfif.rsel2 = plif.IF_Instr_OUT[20:16];
  //assign rfif.wdat = (plif.MEM_MemToReg_OUT == 1) ? plif.MEM_ReadData_OUT : plif.MEM_CalcData_OUT;
  assign rfif.wdat = (plif.MEM_AtomicSTATE_OUT == 2'b10) ? ((plif.MEM_MemToReg_OUT == 1) ? plif.MEM_ReadData_OUT : plif.MEM_CalcData_OUT) : plif.MEM_AtomicSTATE_OUT;

//alu setup
  assign alif.ALUOP = plif.ID_ALUOP_OUT;
  
  always_comb
  begin
    alif.PortA = '0;//'
    alif.PortB = '0;//'

    if (hzif.src1_hazard_t == 2'b00) 
    begin
        alif.PortA = plif.ID_ALUSrc1_OUT;
    end else if (hzif.src1_hazard_t == 2'b01) 
    begin
        alif.PortA = plif.EX_Result_OUT;
    end else if (hzif.src1_hazard_t == 2'b10) 
    begin
        //alif.PortA = plif.MEM_CalcData_OUT;
        //alif.PortA = (plif.MEM_MemToReg_OUT == 1) ? plif.MEM_ReadData_OUT : plif.MEM_CalcData_OUT;
        if(plif.MEM_MemToReg_OUT == 1)
        begin
          alif.PortA = plif.MEM_ReadData_OUT;
        end
        else if (plif.MEM_AtomicSTATE_OUT != 2'b10)
        begin
          alif.PortA = plif.MEM_AtomicSTATE_OUT;
        end
        else 
        begin
          alif.PortA = plif.MEM_CalcData_OUT;
        end
    end

    if(plif.ID_MemWrite_OUT)
    begin
        alif.PortB = plif.ID_ALUSrc2_OUT;
    end else if (hzif.src2_hazard_t == 2'b00) 
    begin
        alif.PortB = plif.ID_ALUSrc2_OUT;
    end else if (hzif.src2_hazard_t == 2'b01) 
    begin
        alif.PortB = plif.EX_Result_OUT;
    end else if (hzif.src2_hazard_t == 2'b10) 
    begin
        //alif.PortB = plif.MEM_CalcData_OUT;
        alif.PortB = (plif.MEM_MemToReg_OUT == 1) ? plif.MEM_ReadData_OUT : plif.MEM_CalcData_OUT;
    end
  end
 
//halt logic
logic halt_reg;
logic n_halt;
always_ff @(negedge CLK, negedge nRST)
begin
  if (!nRST) begin
    halt_reg <= 0;
  end
  else begin
      if(n_halt)
      begin
        halt_reg <= 1;
      end

   
  end
end

assign n_halt = (plif.ID_careOF_OUT == 1) ? ((alif.Overflow == 1) ? 1 : 0) : plif.MEM_halt_OUT;

//memory and cpu
  assign dpif.halt = halt_reg;
  assign dpif.imemREN = 1;
  assign dpif.imemaddr = pc;
  assign dpif.dmemREN = plif.EX_MemToReg_OUT;
  assign dpif.dmemWEN = plif.EX_MemWrite_OUT;
  assign dpif.dmemstore = plif.EX_Wdata_OUT;
  assign dpif.dmemaddr = plif.EX_Result_OUT;
  assign dpif.datomic = plif.EX_Atomic_OUT;

endmodule