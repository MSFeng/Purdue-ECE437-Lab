`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module alu (
  alu_if aluif
  );
  
  logic [32:0] pre_out;
  logic [31:0] PortBComplement;
  //logic [32:0] signedSubOut;
  
  assign PortBComplement = ~aluif.PortB + 1;
 // assign signedSubOut = {aluif.PortA[31], aluif.PortA[31:0]} + {PortBComplement[31], PortBComplement[31:0]};
  
  assign aluif.Zero = (aluif.OutputPort == 0) ? 1:0;
  assign aluif.Negative = (aluif.OutputPort[31] == 1) ? 1:0;
  assign aluif.OutputPort = pre_out[31:0];
  assign aluif.Overflow = (pre_out[32:31] == 2'b01 || pre_out[32:31] == 2'b10) ? 1 : 0;
  
  always_comb
  begin
    
    pre_out = '{default:0}; //;'
    
    unique casez(aluif.ALUOP)
      //Left Shift
      ALU_SLL:
      begin
        pre_out = aluif.PortA<<aluif.PortB[5:0];
      end
      
      //Right Shift
      ALU_SRL:
      begin
        pre_out = aluif.PortA>>aluif.PortB[5:0];
      end
      
       //Signed ADD
      ALU_ADD:
      begin
        pre_out = {aluif.PortA[31], aluif.PortA[31:0]} + {aluif.PortB[31], aluif.PortB[31:0]};
      end
      
      //Signed SUB
      ALU_SUB:
      begin
        pre_out = {aluif.PortA[31], aluif.PortA[31:0]} + {PortBComplement[31], PortBComplement[31:0]};
      end
      
      //And
      ALU_AND:
      begin
        pre_out = aluif.PortA&aluif.PortB;
      end
      
      //OR
      ALU_OR:
      begin
        pre_out = aluif.PortA|aluif.PortB;
      end
      
      //XOR
      ALU_XOR:
      begin
        pre_out = aluif.PortA^aluif.PortB;
      end
      
      //NOR
      ALU_NOR:
      begin
        pre_out = ~(aluif.PortA|aluif.PortB);
      end
      
      
      //Signed SET LESS THAN
      ALU_SLT:
      begin
        pre_out = (signed'(aluif.PortA)<signed'(aluif.PortB))?1:0;
      end
      
      //Unsigned SET LESS THAN
      ALU_SLTU:
      begin
        pre_out = (aluif.PortA<aluif.PortB)?1:0;
      end
      
    endcase
  end
  
endmodule