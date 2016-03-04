// interface
`include "pipeline_registers_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module pipeline_registers (
  input logic CLK,
  input logic nRST,
  pipeline_registers_if plif
  );
  
  //IF regs
  logic [31:0] IF_Instr;
  logic [31:0] IF_NPC;

  //ID regs
  //logic [31:0] ID_Instr;
  logic [31:0] ID_NPC;
  logic [31:0] ID_Instr;

  logic [2:0] ID_jump_t;
  logic [1:0] ID_RegDst_t;
  logic       ID_RegWen;
  logic [31:0] ID_ALUSrc1;
  logic [31:0] ID_ALUSrc2;
  logic [31:0] ID_RegDat2;
  aluop_t     ID_ALUOP;
  logic       ID_MemToReg;
  logic       ID_PcToReg;
  logic       ID_MemWrite;
  logic       ID_careOF;
  logic       ID_halt;
  logic       ID_hazard_care_RT;

  //EX regs
  logic        EX_PcToReg;
  logic [31:0] EX_NPC;
  logic [2:0]  EX_jump_t;
  logic [31:0] EX_Result;
  logic [31:0] EX_Wdata;
  logic        EX_RegWen;
  logic [4:0]  EX_RegDst;
  logic        EX_MemToReg;
  logic        EX_MemWrite;
  logic        EX_halt;

  //Mem regs
  logic        MEM_PcToReg;
  logic [31:0] MEM_NPC;
  logic [31:0] MEM_ReadData;
  logic [31:0] MEM_CalcData;
  logic [4:0]  MEM_RegDst;
  logic        MEM_RegWen;
  logic        MEM_MemToReg;
  logic        MEM_halt;

  
  always_ff @(posedge CLK or negedge nRST)
  begin
    if(!nRST)
    begin
      //IF regs
      IF_Instr <= '0;//'
      IF_NPC <= '0;//'

      //ID regs
      ID_NPC = '0;//'
      ID_Instr <= '0;//'

      ID_jump_t <= '0;//'
      ID_RegDst_t <= '0;//'
      ID_RegWen <= '0;//'
      ID_ALUSrc1 <= '0;//'
      ID_ALUSrc2 <= '0;//'
      ID_RegDat2 <= '0;//'
      ID_ALUOP <= ALU_SLL;
      ID_MemToReg <= '0;//'
      ID_PcToReg <= '0;//'
      ID_MemWrite <= '0;//'
      ID_careOF <= '0;//'
      ID_halt <= '0;//'
      ID_hazard_care_RT <= 0;


      //EX regs
      EX_PcToReg <= '0;//'
      EX_NPC <= '0;//'
      EX_jump_t <= '0;//'
      EX_Result <= '0;//'
      EX_Wdata <= '0;//'
      EX_RegDst <= '0;//'
      EX_RegWen <= '0;//'
      EX_MemToReg <= '0;//'
      EX_MemWrite <= '0;//'
      EX_halt <= 0;

      //MEM regs
      MEM_PcToReg <= '0;//'
      MEM_NPC <= '0;//'
      MEM_ReadData <= '0;//'
      MEM_CalcData <= '0;//'
      MEM_RegDst <= '0;//'
      MEM_MemToReg <= '0;//'
      MEM_RegWen <= '0;//'
      MEM_halt <= 0;

    end
    else 
    begin


      //MEM regs
     /* MEM_PcToReg <= '0;
      MEM_NPC <= '0;
      MEM_ReadData <= '0;
      MEM_CalcData <= '0;
      MEM_RegDst <= '0;
      MEM_MemToReg <= '0;
      MEM_RegWen <= '0;
      MEM_halt <= 0;*/
      
      if (plif.tick == 1) 
      begin

        if (plif.lw_hazard != 1 && plif.lw_later_hazard != 1) begin

          if (plif.branching == 1) begin
             //IF regs
            IF_Instr <= '0;//'
            IF_NPC <= '0;//'

            //ID regs
            ID_NPC <= '0;//'
            ID_Instr <= '0;//'

            ID_jump_t <= '0;//'
            ID_RegDst_t <= '0;//'
            ID_RegWen <= '0;//'
            ID_ALUSrc1 <= '0;//'
            ID_ALUSrc2 <= '0;//'
            ID_RegDat2 <= '0;//'
            ID_ALUOP <= ALU_SLL;
            ID_MemToReg <= '0;//'
            ID_PcToReg <= '0;//'
            ID_MemWrite <= '0;//'
            ID_careOF <= '0;//'
            ID_halt <= '0;//'
            ID_hazard_care_RT <= 0;
          end
          else 
          begin
            //IF
            IF_Instr <= plif.IF_Instr_IN;
            IF_NPC <= plif.IF_NPC_IN;

            //ID
            ID_NPC <= IF_NPC;
            ID_Instr <= IF_Instr;
            
            ID_jump_t <= plif.ID_jump_t_IN;
            ID_RegDst_t <= plif.ID_RegDst_t_IN;
            ID_RegWen <= plif.ID_RegWen_IN;
            ID_ALUSrc1 <= plif.ID_ALUSrc1_IN;
            ID_ALUSrc2 <= plif.ID_ALUSrc2_IN;
            ID_RegDat2 <= plif.ID_RegDat2_IN;
            ID_ALUOP <= plif.ID_ALUOP_IN;
            ID_MemToReg <= plif.ID_MemToReg_IN;
            ID_PcToReg <= plif.ID_PcToReg_IN;
            ID_MemWrite <= plif.ID_MemWrite_IN;
            ID_careOF <= plif.ID_careOF_IN;
            ID_halt <= plif.ID_halt_IN;
            ID_hazard_care_RT <= plif.ID_hazard_care_RT_IN;
          end
        end

        if (plif.lw_hazard == 1 || plif.lw_later_hazard == 1)
        begin
          //EX regs
          EX_PcToReg <= '0;//'
          EX_NPC <= '0;//'
          EX_jump_t <= '0;//'
          EX_Result <= '0;//'
          EX_Wdata <= '0;//'
          EX_RegDst <= '0;//'
          EX_RegWen <= '0;//'
          EX_MemToReg <= '0;//'
          EX_MemWrite <= '0;//'
          EX_halt <= 0;
        end else 
        begin
          //EX
          EX_PcToReg <= ID_PcToReg;
          EX_NPC <= ID_NPC;
          //EX_jump_t <= ID_jump_t;
          EX_Result <= plif.EX_Result_IN;
          EX_Wdata <= plif.EX_Wdata_IN;
          EX_RegWen <= ID_RegWen;
          EX_RegDst <= plif.EX_RegDst_IN;
          EX_MemToReg <= ID_MemToReg;
          EX_MemWrite <= ID_MemWrite;
          EX_halt <= ID_halt;          
        end

        if(plif.lw_later_hazard == 2'b01)
        begin
          ID_ALUSrc1 <= MEM_ReadData;
        end else if (plif.lw_later_hazard == 2'b10) begin
          ID_ALUSrc2 <= MEM_ReadData;
        end

        //MEM
        MEM_NPC <= EX_NPC;
        MEM_ReadData <= plif.MEM_ReadData_IN;
        MEM_PcToReg <= EX_PcToReg;
        MEM_CalcData <= EX_Result;
        MEM_RegDst <= EX_RegDst;
        MEM_RegWen <= EX_RegWen;
        MEM_MemToReg <= EX_MemToReg;
        MEM_halt <= EX_halt;
       // ID_ALUSrc1 <= plif.ID_ALUSrc1_IN;
       // ID_ALUSrc2 <= plif.ID_ALUSrc2_IN;
      end

      //if (plif.valid) begin
        //MEM_ReadData <= plif.MEM_ReadData_IN;
      //end

    end
  end

  assign plif.IF_Instr_OUT = IF_Instr;

  assign plif.ID_NPC_OUT = ID_NPC;
  assign plif.ID_Instr_OUT = ID_Instr;
  assign plif.ID_ALUSrc1_OUT = ID_ALUSrc1;
  assign plif.ID_ALUSrc2_OUT = ID_ALUSrc2;
  assign plif.ID_ALUOP_OUT = ID_ALUOP;
  assign plif.ID_jump_t_OUT = ID_jump_t;
  assign plif.ID_RegDst_t_OUT = ID_RegDst_t;
  assign plif.ID_careOF_OUT = ID_careOF;
  assign plif.ID_halt_OUT = ID_halt;
  assign plif.ID_hazard_care_RT_OUT = ID_hazard_care_RT;
  assign plif.ID_RegDat2_OUT = ID_RegDat2;
  assign plif.ID_MemToReg_OUT = ID_MemToReg;
  assign plif.ID_MemWrite_OUT = ID_MemWrite;

  assign plif.EX_Result_OUT = EX_Result;
  assign plif.EX_Wdata_OUT =EX_Wdata;
  assign plif.EX_RegDst_OUT = EX_RegDst;
  assign plif.EX_RegWen_OUT = EX_RegWen;
  assign plif.EX_MemToReg_OUT = EX_MemToReg;
  assign plif.EX_MemWrite_OUT = EX_MemWrite;

  assign plif.MEM_PcToReg_OUT = MEM_PcToReg;
  assign plif.MEM_NPC_OUT = MEM_NPC;
  assign plif.MEM_MemToReg_OUT = MEM_MemToReg;
  assign plif.MEM_RegDst_OUT = MEM_RegDst;
  assign plif.MEM_RegWen_OUT = MEM_RegWen;
  assign plif.MEM_ReadData_OUT = MEM_ReadData;
  assign plif.MEM_CalcData_OUT = MEM_CalcData;
  assign plif.MEM_halt_OUT = MEM_halt;

  endmodule