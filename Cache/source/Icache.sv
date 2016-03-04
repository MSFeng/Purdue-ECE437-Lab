
 `include "datapath_cache_if.vh"
 `include "cache_control_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module Icache (
  input logic CLK, nRST,
  input dmemREN,
  input dmemWEN,
  input halt,
  cache_control_if ccif,
  datapath_cache_if dcif
);

logic [31:0] instr;
logic [31:0] n_instr;

  /***** I_Cache *****/
  //16 slots, 512 bits
  //tag[57:32], data[31:0], valid[58]
  logic [15:0][58:0] icacheReg;
  logic [15:0][58:0] n_icacheReg;

  //values for checking icache
  logic [25:0] i_tag;
  logic [3:0]  i_index;

  logic [25:0] i_tag_chk;
  logic        i_valid_chk;

  logic        i_same_tag;
  logic [31:0] i_data_stored;

  assign i_tag = dcif.imemaddr[31:6];
  assign i_index = dcif.imemaddr[5:2];

  assign i_tag_chk = icacheReg[i_index][57:32];
  assign i_valid_chk = icacheReg[i_index][58];

  assign i_data_stored = icacheReg[i_index][31:0];
  assign i_same_tag = (i_tag_chk == i_tag) ? 1 : 0;

integer i;


always_ff @(posedge CLK)
  begin
    if (!nRST)
    begin
      instr <= '0; //'

       begin
       for (i=0;i<16;i++)
         icacheReg[i][58] <= 0;
       end

    end
    else 
    begin
      instr <= n_instr;
      icacheReg <= n_icacheReg;
    end
    /*else
    if (dcif.ihit)
    begin
      instr <= ccif.iload;

      //icache
      icacheReg <= n_icacheReg;
    end*/

  end


   // icache comb logic
  always_comb
  begin

    //default value, prevent latch
    dcif.ihit = 0;

    ccif.iREN = 0;
    ccif.iaddr = 0;
    dcif.imemload = 0;
    n_instr = instr;
    n_icacheReg = icacheReg;

    if((dmemREN == 0) && (dmemWEN == 0) && (halt == 0))
    begin
      if(i_valid_chk && i_same_tag) //found a match
      begin
        dcif.imemload = i_data_stored;
        dcif.ihit = 1;
        n_instr = i_data_stored;
      end
      else begin                   //match not found, requesting from mem
        ccif.iREN = dcif.imemREN;
        ccif.iaddr = dcif.imemaddr;
        if(ccif.iwait == 0)
        begin
          n_icacheReg[i_index][58] = 1; //set valid
          n_icacheReg[i_index][57:32] = i_tag; //set tag
          n_icacheReg[i_index][31:0] = ccif.iload; //store data

          dcif.ihit = 1;
          dcif.imemload = ccif.iload;

          n_instr = ccif.iload;
        end
        else begin
          dcif.imemload = instr;
        end
      end
        
    end

  end

  endmodule
