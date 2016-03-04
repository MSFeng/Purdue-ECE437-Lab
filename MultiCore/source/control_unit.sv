// interface include
`include "control_unit_if.vh"

// memory types
`include "cpu_types_pkg.vh"
 import cpu_types_pkg::*;

module control_unit (
  control_unit_if cuif
);

always_comb
begin
  	cuif.jump_t = 3'b000; //000 for not jump, 001 for jump to addr, 010 for jump to reg, 011 for beq,  100 for bne
  	cuif.RegDst_t = 2'b00; //choose dst source between Rd(0) and Rt(1) and 31[10]
  	cuif.RegWen = 0; //Enanle when need to write to register
    cuif.ALUSrc_t = 3'b000; //0:reg, 001: singed im 010: zero im 011:lui 100: shamt   
  	cuif.ALUOP = ALU_SLL;
    cuif.MemToReg = 0; //00: not from mem, 01: from full word, 10: from half word, 11: from byte
    cuif.PcToReg = 0;
    cuif.MemWrite = 0; //00: not write to mem, 01: write full word, 10: write half word, 11: write byte
    cuif.careOF = 0;
    cuif.Atomic = 0;
    cuif.halt = 0;

    cuif.careAboutRT = 0;

	   casez(cuif.Instr[31:26])
		RTYPE: //r instructions
		begin
			cuif.careAboutRT = 1;

			  casez(cuif.Instr[5:0])
				SLL:
				begin
					cuif.ALUOP = ALU_SLL;
					cuif.ALUSrc_t = 3'b100;
					cuif.RegWen = 1;
				end

				SRL:
				begin
					cuif.ALUOP = ALU_SRL;
					cuif.ALUSrc_t = 3'b100;
					cuif.RegWen = 1;
				end

				JR:
				begin
					cuif.jump_t = 3'b010;
				end

				ADD:
				begin
					cuif.ALUOP = ALU_ADD;
					cuif.RegWen = 1;
					cuif.careOF = 1;
				end

				ADDU:
				begin
					cuif.ALUOP = ALU_ADD;
					cuif.RegWen = 1;
				end

				SUB:
				begin
					cuif.ALUOP = ALU_SUB;
					cuif.RegWen = 1;
					cuif.careOF = 1;
				end

				SUBU:
				begin
					cuif.ALUOP = ALU_SUB;
					cuif.RegWen = 1;
				end

				AND:
				begin
					cuif.ALUOP = ALU_AND;
					cuif.RegWen = 1;
				end

				OR:
				begin
					cuif.ALUOP = ALU_OR;
					cuif.RegWen = 1;
				end

				XOR:
				begin
					cuif.ALUOP = ALU_XOR;
					cuif.RegWen = 1;
				end

				NOR:
				begin
					cuif.ALUOP = ALU_NOR;
					cuif.RegWen = 1;
				end

				SLT:
				begin
					cuif.ALUOP = ALU_SLT;
					cuif.RegWen = 1;
				end

				SLTU:
				begin
					cuif.ALUOP = ALU_SLTU;
					cuif.RegWen = 1;
				end

			endcase
		end

		J:
		begin
			cuif.jump_t = 3'b001;
		end

		JAL:
		begin
			cuif.jump_t = 3'b001;
			cuif.RegWen = 1'b1;
			cuif.RegDst_t = 2'b10;
			cuif.PcToReg = 1;
		end

		//itype
		BEQ:
		begin
			cuif.jump_t = 3'b011;
			cuif.ALUOP = ALU_SUB;
		end

		BNE:
		begin
			cuif.jump_t = 3'b100;
			cuif.ALUOP = ALU_SUB;
		end

		ADDI:
		begin
			cuif.ALUOP = ALU_ADD;
			cuif.ALUSrc_t = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
			cuif.careOF = 1;
		end

		ADDIU:
		begin
			cuif.ALUOP = ALU_ADD;
			cuif.ALUSrc_t = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
		end

		SLTI:
		begin
			cuif.ALUOP = ALU_SLT;
			cuif.ALUSrc_t = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
		end

		SLTIU:
		begin
			cuif.ALUOP = ALU_SLTU;
			cuif.ALUSrc_t = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
		end

		ANDI:
		begin
			cuif.ALUOP = ALU_AND;
			cuif.ALUSrc_t = 3'b010;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
		end

		ORI:
		begin
			cuif.ALUOP = ALU_OR;
			cuif.ALUSrc_t = 3'b010;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
		end

		XORI:
		begin
			cuif.ALUOP = ALU_XOR;
			cuif.ALUSrc_t = 3'b010;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
		end

		LUI:
		begin
			cuif.ALUOP = ALU_OR;
			cuif.ALUSrc_t = 3'b011;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
		end

		LW:
		begin
			cuif.ALUOP = ALU_ADD;
			cuif.ALUSrc_t = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
			cuif.MemToReg = 1;
		end
		
		LBU:
		begin
			
		end

		LHU:
		begin
			
		end

		SB:
		begin
			
		end

		SH:
		begin
			
		end

		SW:
		begin
			cuif.ALUOP = ALU_ADD;
			cuif.ALUSrc_t = 3'b001;
			cuif.MemWrite = 1;
			cuif.careAboutRT = 1;
		end

		LL:
		begin
			cuif.ALUOP = ALU_ADD;
			cuif.ALUSrc_t = 3'b001;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
			cuif.MemToReg = 1;
			cuif.Atomic = 1;
		end

		SC:
		begin
			cuif.ALUOP = ALU_ADD;
			cuif.ALUSrc_t = 3'b001;
			cuif.MemWrite = 1;
			cuif.RegWen = 1;
			cuif.RegDst_t = 2'b01;
			//cuif.MemToReg = 1;
			cuif.careAboutRT = 1;
			cuif.Atomic = 1;
		end

		HALT:
		begin
			cuif.halt = 1;
		end


	endcase
end

endmodule