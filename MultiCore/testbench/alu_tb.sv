// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;
  parameter WAIT = 1;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aluif ();

  // test program
  test PROG (
  CLK,
  aluif
  );
  // DUT
`ifndef MAPPED
  alu DUT(aluif);
`else
  alu DUT(
    .\aluif.PortA (aluif.PortA),
    .\aluif.PortB (aluif.PortB),
    .\aluif.OutputPort (aluif.OutputPort),
    .\aluif.ALUOP (aluif.ALUOP),
    .\aluif.Negative (aluif.Negative),
    .\aluif.Overflow (aluif.Overflow),
    .\aluif.Zero (aluif.Zero)
  );
`endif

endmodule

program test(
  input logic CLK,
  alu_if.tb tbif
);

initial begin
  
  //left shift test
  @(posedge CLK);
  tbif.ALUOP = ALU_SLL;
  tbif.PortA = 32'b01010101010101010101010101010101;
  tbif.PortB = 32'b00000000000000000000000000000010;
  #1;
  if(tbif.OutputPort == tbif.PortA<<tbif.PortB)
  begin
    $display("left shift test pased");
  end
  
  //right shift test
  @(posedge CLK);
  tbif.ALUOP =  ALU_SRL;
  tbif.PortA = 32'b01010101010101010101010101010101;
  tbif.PortB = 32'b00000000000000000000000000000011;
  #1;
  if(tbif.OutputPort == tbif.PortA>>tbif.PortB)
  begin
    $display("right shift test pased");
  end
  
  //AND test
  @(posedge CLK);
  tbif.ALUOP = ALU_AND;
  tbif.PortA = 32'b01010101010101010101010101010101;
  tbif.PortB = 32'b10101010101010101010101010101010;
  #1;
  if(tbif.OutputPort == (tbif.PortA&tbif.PortB))
  begin
    $display("AND test pased");
  end
  
  //OR addr test
   @(posedge CLK);
   tbif.ALUOP = ALU_OR;
   tbif.PortA = 32'b01010101010101010101010101010101;
   tbif.PortB = 32'b10101010101010101010101010101010;
   #1;
   if(tbif.OutputPort == (tbif.PortA|tbif.PortB))
   begin
     $display("OR test pased");
   end
  
  //XOR test
  @(posedge CLK);
  tbif.ALUOP = ALU_XOR;
   tbif.PortA = 32'b01010101010101010101010101010101;
   tbif.PortB = 32'b10101010101010101010101010101010;
   #1;
   if(tbif.OutputPort == tbif.PortA^tbif.PortB)
   begin
     $display("XOR test pased");
   end
  
  //NOR test
  @(posedge CLK);
  tbif.ALUOP = ALU_NOR;
   tbif.PortA = 32'b01010101010101010101010101010101;
   tbif.PortB = 32'b10101010101010101010101010101010;
   #1;
   if(tbif.OutputPort == ~(tbif.PortA|tbif.PortB))
   begin
     $display("NOR test pased");
   end
  
  //ADD value test
   @(posedge CLK);
    tbif.ALUOP = ALU_ADD;
   tbif.PortA = 32'b01010101010101010101010101010101;
   tbif.PortB = 32'b10101010101010101010101010101010;
   #1;
   if(tbif.OutputPort == 1431655765 + (-1431655766));
   begin
     $display("ADD Value test pased");
   end
   
   if(tbif.Negative == 1)
    begin
      $display("ADD Neg test pased");
    end
   
   //ADD POS OF test
   @(posedge CLK);
    tbif.ALUOP = ALU_ADD;
   tbif.PortA = 32'b01010101010101010101010101010101;
   tbif.PortB = 32'b01010101010101010101010101010101;
   #1;
   if(tbif.Overflow == 1);
   begin
     $display("ADD POS OF test pased");
    end
    
   
    //ADD NEG OF test
   @(posedge CLK);
   tbif.ALUOP = ALU_ADD;
   tbif.PortA = 32'b10000000010000000000010000001111;
   tbif.PortB = 32'b10000000010000000000010000001111;
   #1;
   if(tbif.Overflow == 1);
   begin
     $display("ADD NEG OF test pased");
   end
   
   //SUB Value test
    @(posedge CLK);
   tbif.ALUOP = ALU_SUB;
   tbif.PortA = 32'b10000000010000000000010000010000;
   tbif.PortB = 32'b10000000010000000000010000001111;
   #1;
   if(tbif.OutputPort == 1);
   begin
     $display("SUB Value test pased");
   end
   
   //SUB NEG OF Value test
    @(posedge CLK);
   tbif.ALUOP = ALU_SUB;
   tbif.PortA = 32'b10000000010000000000010000010000;
   tbif.PortB = 32'b01111111111111111111111111111111;
   #1;
   if(tbif.Overflow == 1);
   begin
     $display("SUB NEG OF test pased");
   end
   
   
   //SUB POS OF Value test
    @(posedge CLK);
   tbif.ALUOP = ALU_SUB;
   tbif.PortA = 32'b01111111111111111111111111111111;
   tbif.PortB = 32'b10000000010000000000010000010000;
   #1;
   if(tbif.Overflow == 1);
   begin
     $display("SUB POS OF test pased");
   end
   
   //signed less than test
    @(posedge CLK);
   tbif.ALUOP = ALU_SLT;
   tbif.PortA = 32'b10000000010000000000010000010000;
   tbif.PortB = 32'b00000000010000000000010000010000;
   #1;
   if(tbif.OutputPort == 1);
   begin
     $display("Signed Less than test pased");
   end
   
   //unsigned less than test
    @(posedge CLK);
   tbif.ALUOP = ALU_SLTU;
   tbif.PortA = 32'b01111111111111111111111111111111;
   tbif.PortB = 32'b10000000010000000000010000010000;
   #1;
   if(tbif.OutputPort == 1);
   begin
     $display("unSigned Less than test pased");
   end
   
  $finish;  
end

endprogram
