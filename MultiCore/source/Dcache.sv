
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
// cpu types
`include "cpu_types_pkg.vh"

// import types
  import cpu_types_pkg::word_t;
module Dcache (
  input logic CLK,
  input logic nRST,
  //cache_control_if ccif,
  input word_t ccsnoopaddr,
  input logic ccwait,
  input logic ccinv,
  input logic dwait,
  input word_t dload,
  input logic ccatomicinvalidate,
  input logic cccofreetomove,

  output logic cctrans,
  output logic dREN,
  output logic dWEN,
  output word_t daddr,
  output word_t dstore,
  output logic ccwrite,
  output logic ccsnoopchecking,
  output word_t ccsnoopvalue,
  output logic ccsnoopvalid,
  output logic ccatomicinvalidating,
  output word_t ccatomicaddr,
  
  datapath_cache_if dcif
);

parameter CPUID = 0;

/**** D_Cache****/
  //8 slots each sid, total 1024 bits
  //valid[91], dirty[90], tag[89:64], data1[63:32], data2[31:0]
  logic [1:0][7:0][91:0] dcacheReg;
  logic [1:0][7:0][91:0] n_dcacheReg;

  logic [31:0] linkReg;
  logic [31:0] n_linkReg;
  logic        link_valid;
  logic        n_link_valid;

  typedef enum {IDLE, ALL1, ALL2, WB1, WB2, SNOOP_CHK,SNOOP_WB1, SNOOP_WB2, FLUSH1, FLUSH2, HIT_CNT} state_type;
  state_type d_state;
  state_type n_d_state;

  //values for checking dcache
  logic [25:0]  d_tag;
  logic [2:0]   d_index;

  logic [25:0]  d_tag_chk_0;
  logic [25:0]  d_tag_chk_1;
  logic         d_valid_chk_0;
  logic         d_valid_chk_1;
  logic         d_dirty_chk_0;
  logic         d_dirty_chk_1;

  logic [31:0]  d_data_stored_0;
  logic [31:0]  d_data_stored_1;
  logic [31:0]  d_data_stored;
  logic [1:0]   d_same_tag; //00:no match, 01:match 0, 10:match 1

  logic [7:0]   d_acc_map;
  logic [7:0]   n_d_acc_map;

  logic [31:0]  d_other_addr;

  //just for flush
  //logic        halt;
  logic [31:0] hitT;
  logic [31:0] n_hitT;
  logic [3:0]  d_count;
  logic [3:0]  n_d_count;

  logic flushReg;
  logic n_flushReg;
 
  assign d_tag = dcif.dmemaddr[31:6];
  assign d_index = dcif.dmemaddr[5:3];

  assign d_tag_chk_0 = dcacheReg[0][d_index][89:64];
  assign d_tag_chk_1 = dcacheReg[1][d_index][89:64];
  assign d_valid_chk_0 = dcacheReg[0][d_index][91];
  assign d_valid_chk_1 = dcacheReg[1][d_index][91];
  assign d_dirty_chk_0 = dcacheReg[0][d_index][90];
  assign d_dirty_chk_1 = dcacheReg[1][d_index][90];


  assign d_data_stored_0 = dcif.dmemaddr[2] ? dcacheReg[0][d_index][63:32] : dcacheReg[0][d_index][31:0];
  assign d_data_stored_1 = dcif.dmemaddr[2] ? dcacheReg[1][d_index][63:32] : dcacheReg[1][d_index][31:0];
  assign d_same_tag = (d_tag == d_tag_chk_0) ? 2'b00 : ((d_tag == d_tag_chk_1) ? 2'b01 : 2'b10);
  assign d_data_stored = (d_same_tag == 2'b00) ? d_data_stored_0 : d_data_stored_1;

  assign dcif.flushed = flushReg;



  //Bus read related]
  logic [2:0] snoop_index;
  logic [25:0]snoop_tag;

  logic [25:0] snoop_tag_chk_0;
  logic [25:0] snoop_tag_chk_1;

  logic snoop_valid_chk_0;
  logic snoop_valid_chk_1;

  logic [31:0] snoop_data_stored_0;
  logic [31:0] snoop_data_stored_1;
  logic [1:0] snoop_same_tag;

  assign snoop_tag = ccsnoopaddr[31:6];
  assign snoop_index = ccsnoopaddr[5:3];
 
  assign snoop_tag_chk_0 = dcacheReg[0][snoop_index][89:64];
  assign snoop_tag_chk_1 = dcacheReg[1][snoop_index][89:64];

  assign snoop_valid_chk_0 = dcacheReg[0][snoop_index][91];
  assign snoop_valid_chk_1 = dcacheReg[1][snoop_index][91];

  assign snoop_data_stored_0 = ccsnoopaddr[2] ? dcacheReg[0][snoop_index][63:32] : dcacheReg[0][snoop_index][31:0];
  assign snoop_data_stored_1 = ccsnoopaddr[2] ? dcacheReg[1][snoop_index][63:32] : dcacheReg[1][snoop_index][31:0];
 
  assign snoop_same_tag = (snoop_tag == snoop_tag_chk_0) ? 2'b00 : ((snoop_tag == snoop_tag_chk_1) ? 2'b01 : 2'b10);
  assign ccsnoopvalue = (snoop_same_tag == 2'b00) ? snoop_data_stored_0 : snoop_data_stored_1; 
  assign ccsnoopvalid = (snoop_valid_chk_0 == 1 && snoop_same_tag == 2'b00) ? 1 : ((snoop_valid_chk_1 == 1 && snoop_same_tag == 2'b01) ? 1 : 0); 




  //LLSC
  assign ccatomicaddr = linkReg;

integer i;

 always_ff @(posedge CLK, negedge nRST)
  begin
    if (!nRST)
    begin
    
      //dcache
     // dcacheReg <= '0;//'
     for (i=0;i<8;i++)
     begin
      dcacheReg[1][i]<=0;
      dcacheReg[0][i]<=0;
     end

      d_state <= IDLE;
      d_acc_map <= '0;//'
      hitT <= '0;//'
      d_count <= '0;//'

      flushReg <= '0;//'

      linkReg <= '0;//'
      link_valid <= '0;//'

    end
    else
    begin

      //dcache
      dcacheReg <= n_dcacheReg;
      d_state <= n_d_state;
      d_acc_map <= n_d_acc_map;
      hitT <= n_hitT;
      d_count <= n_d_count;

      flushReg <= n_flushReg;

      linkReg <= n_linkReg;
      link_valid <= n_link_valid;
    end
  end


  logic canstore;
  assign canstore = (dcif.datomic) ? ((linkReg != dcif.dmemaddr || link_valid == 0) ? 0 : 1): 1;


  //dcache comb logic
always_comb
begin
  //set default values
  cctrans = 0;
  n_d_state = d_state;
  n_dcacheReg = dcacheReg;
  dcif.dmemload = 0;
  dcif.dhit = 0;

  dREN = 0;
  dWEN = 0;
  daddr = dcif.dmemaddr;
  dstore = 0;
  d_other_addr = dcif.dmemaddr;

  n_d_acc_map = d_acc_map; //store index least used

  n_hitT = hitT;
  n_d_count = d_count;
  n_flushReg = flushReg;

  n_linkReg = linkReg;
  n_link_valid = link_valid;

  dcif.datomicSTATE = 2'b10;
  ccatomicinvalidating = 0;

  //ccif.ccwrite[CPUID] = 0;
  if(ccwait == 1)
  begin
    ccwrite = 0;
  end
  else 
  begin
    ccwrite = dcif.dmemWEN;
  end
  
  if(ccatomicinvalidate)
  begin
    n_link_valid = 0;
  end

  ccsnoopchecking = 0;


  unique casez (d_state)
    IDLE:
    begin
      if(ccwait == 1)//if wait, block all cpu actions
      begin
        n_d_state = SNOOP_CHK;
      end
      else
      if(dcif.dmemREN && ccwait == 0) //read mode
      begin
        //LL
        if(dcif.datomic)
        begin
          n_linkReg = dcif.dmemaddr;
          n_link_valid = 1;
        end

        if(d_same_tag != 2'b10) //there is a potential match
        begin
          if (d_same_tag == 2'b00 && d_valid_chk_0 == 1) //data match on block 0
          begin
            dcif.dhit = 1;
            n_hitT=hitT+1;
            dcif.dmemload = d_data_stored;
            n_d_acc_map[d_index] = 1;
            /*if(d_acc_map[d_index] == d_same_tag)
            begin
              n_d_acc_map[d_index]=d_acc_map[d_index]+1;
            end*/                                                              

            n_d_state = IDLE;
          end
          else if (d_same_tag == 2'b01 && d_valid_chk_1 == 1) //data match on block 1 
          begin
            dcif.dhit = 1;
            n_hitT=hitT+1;
            dcif.dmemload = d_data_stored;
            n_d_acc_map[d_index] = 0;
             /*if(d_acc_map[d_index] == d_same_tag)
            begin
              n_d_acc_map[d_index]=d_acc_map[d_index]+1;
            end*/
            n_d_state = IDLE;
          end
          else //no match, requesting data from mem
          begin
            if((!d_valid_chk_0) || (!d_valid_chk_1))
            begin
              cctrans = 1;
              n_d_state = ALL1;
              if (!d_valid_chk_0) 
              begin
                n_d_acc_map[d_index] = 0; //block 0 is ok to fill in new data
              end
              else 
              begin
                n_d_acc_map[d_index] = 1; //block 1 is ok to fill in new data
              end
              
            end
            else
            if((!d_dirty_chk_0) || (!d_dirty_chk_1)) //no dirty data, override directly
            begin //have to write dirty back first
              cctrans = 1;
              n_d_state = ALL1;
              if(!d_dirty_chk_0)
              begin
                n_d_acc_map[d_index] = 0; //block 0 is available for override  
              end
              else 
              begin
                n_d_acc_map[d_index] = 1; //block 1 is available for override
              end
            end
            else
            begin //no open spot, need wb first
              cctrans = 1;
              n_d_state = WB1;
            end
            
          end
        end
        else 
        begin //absolutely no match, requesting data from mem

            if(dcif.halt)
            begin
              n_d_state = FLUSH1;
            end
            else if((!d_valid_chk_0) || (!d_valid_chk_1))
            begin
              cctrans = 1;
              n_d_state = ALL1;
              if (!d_valid_chk_0) 
              begin
                n_d_acc_map[d_index] = 0; //block 0 is ok to fill in new data
              end
              else 
              begin
                n_d_acc_map[d_index] = 1; //block 1 is ok to fill in new data
              end
            end
            else if((!d_dirty_chk_0) || (!d_dirty_chk_1)) //no dirty data, override directly
            begin //have to write dirty back first
              cctrans = 1;
              n_d_state = ALL1;
              if(!d_dirty_chk_0)
              begin
                n_d_acc_map[d_index] = 0; //block 0 is available for override
              end
              else 
              begin
                n_d_acc_map[d_index] = 1; //block 1 is available for override
              end
            end
            else
            begin //no open spot, need wb first
              cctrans = 1;
              n_d_state = WB1;
            end
        end
      end
      else if (dcif.dmemWEN && ccwait == 0) //write mode 
      begin

          ccatomicinvalidating = 1;

          if(dcif.datomic == 0 && dcif.dmemaddr == linkReg) //invalidate self
          begin
            n_link_valid = 0;
          end

          if (canstore == 0)
          begin
            dcif.dhit = 1;
            dcif.datomicSTATE = 2'b00;
            n_d_state = IDLE;
          end
          else
          if (d_same_tag == 2'b00 && d_valid_chk_0 == 1)
          begin

            cctrans = 1;

            //SC
            if (dcif.datomic)
            begin
              n_link_valid = 0;
              dcif.datomicSTATE = 2'b01;
            end

            if (cccofreetomove)
            begin
                dcif.dhit = 1;
                n_d_state = IDLE;    
            end

            if(d_valid_chk_0==1)
            begin
               n_hitT=hitT+1;
            end
            //n_d_acc_map[d_index] = 1;
            if(d_acc_map[d_index] == d_same_tag && d_valid_chk_0)
            begin
              n_d_acc_map[d_index]=d_acc_map[d_index]+1;
            end

            n_dcacheReg[0][d_index][90] = 1; //set dirty
            n_dcacheReg[0][d_index][91] = 1; //set valid
            if (dcif.dmemaddr[2] == 1) //check offset
            begin
              n_dcacheReg[0][d_index][63:32] = dcif.dmemstore;
            end
            else 
            begin
              n_dcacheReg[0][d_index][31:0] = dcif.dmemstore;  
            end
          end
          else if (d_same_tag == 2'b01 && d_valid_chk_1==1)
          begin
            cctrans = 1;

           //SC
            if (dcif.datomic)
            begin
              n_link_valid = 0;
              dcif.datomicSTATE = 2'b01;
            end

            if (cccofreetomove)
            begin
                dcif.dhit = 1;
                n_d_state = IDLE;    
            end
          
             if(d_valid_chk_1==1)
            begin
               n_hitT=hitT+1;
            end
            //n_d_acc_map[d_index] = 0;
            if(d_acc_map[d_index] == d_same_tag)
            begin
              n_d_acc_map[d_index]=d_acc_map[d_index]+1;
            end

            n_dcacheReg[1][d_index][90] = 1; //set dirty
            n_dcacheReg[1][d_index][91] = 1; //set valid
            if(dcif.dmemaddr[2] == 1) //check offset
            begin
              n_dcacheReg[1][d_index][63:32] = dcif.dmemstore;
            end
            else 
            begin
              n_dcacheReg[1][d_index][31:0] = dcif.dmemstore;
            end
          end
          else  //no match, may require wb
          begin
            if(dcif.halt)
            begin
              n_d_state = FLUSH1;
            end
            else 
            begin
              if(!d_valid_chk_0)
              begin
                cctrans = 1;
                n_d_acc_map[d_index] = 0;
                n_d_state = ALL1;
              end
              else if(!d_valid_chk_1)
              begin
                cctrans = 1;
                n_d_acc_map[d_index] = 1;
                n_d_state = ALL1;
              end
              else if(!d_dirty_chk_0) //block 0 not dirty, realloc it
              begin
                cctrans = 1;
                n_d_acc_map[d_index] = 0;
                n_d_state = ALL1;
              end 
              else if (!d_dirty_chk_1) //block 1 not dirty, realloc it
              begin
                cctrans = 1;
                n_d_acc_map[d_index] = 1;
                n_d_state = ALL1;
              end
              else 
              begin
                if (dcif.datomic)
                begin
                  if (dcif.dmemaddr == linkReg && link_valid == 1)
                  begin
                    cctrans = 1;
                    n_d_state = WB1;
                  end
                end
                else 
                begin
                  cctrans = 1;
                  n_d_state = WB1;
                end

               
              end
            end
            
          end
        

      end
      else 
      begin   //neither read nor write
        if(dcif.halt)
        begin
          n_d_state = FLUSH1;
        end
        else begin
          n_d_state = IDLE;  
        end
        
      end
    end

    ALL1:
    begin //alloc memory
      dREN = 1;
      daddr = dcif.dmemaddr;

      n_dcacheReg[d_acc_map[d_index]][d_index][89:64] = dcif.dmemaddr[31:6]; //set tag
      n_dcacheReg[d_acc_map[d_index]][d_index][91] = 1; //set valid

      if(!dwait)
      begin    //done loading
        if(dcif.dmemaddr[2])
        begin
          n_dcacheReg[d_acc_map[d_index]][d_index][63:32] = dload;
        end
        else 
        begin
          n_dcacheReg[d_acc_map[d_index]][d_index][31:0] = dload;
        end

        n_d_state = ALL2;
      end
      else 
      begin  //not done yet
        n_d_state = ALL1;  
      end
    end

    ALL2:
    begin
      dREN = 1;
      if(!dcif.dmemaddr[2]) //low 32 bits
      begin
        d_other_addr = dcif.dmemaddr + 4;
      end
      else 
      begin
        d_other_addr = dcif.dmemaddr - 4;
      end

      daddr = d_other_addr;

      //get data just loaded
      if(dcif.dmemaddr[2])
      begin
        dcif.dmemload = dcacheReg[d_acc_map[d_index]][d_index][63:32];  
      end
      else 
      begin
        dcif.dmemload = dcacheReg[d_acc_map[d_index]][d_index][31:0];  
      end

      if(!dwait)
      begin

        n_d_acc_map[d_index] = d_acc_map[d_index]+1;

        dcif.dhit = 1;
        n_d_state = IDLE;

        if(d_other_addr[2])
        begin
          n_dcacheReg[d_acc_map[d_index]][d_other_addr[5:3]][63:32] = dload;
        end
        else 
        begin
          n_dcacheReg[d_acc_map[d_index]][d_other_addr[5:3]][31:0] = dload;
        end

        if(dcif.dmemWEN)
        begin
          //SC
          if (dcif.datomic)
          begin
            n_link_valid = 0;
            dcif.datomicSTATE = 2'b01;
          end

          n_dcacheReg[d_acc_map[d_index]][d_index][90] = 1; //set dirty
          //n_dcacheReg[d_acc_map[d_index]][d_index][91] = 1; //set valid
          if (dcif.dmemaddr[2])
          begin
            n_dcacheReg[d_acc_map[d_index]][d_index][63:32] = dcif.dmemstore;
          end
          else 
          begin
            n_dcacheReg[d_acc_map[d_index]][d_index][31:0]  = dcif.dmemstore;  
          end
        end
      end
      else 
      begin
        n_d_state = ALL2;  
      end
    end

    WB1:
    begin
      dWEN = 1;
      n_dcacheReg[d_acc_map[d_index]][d_index][90] = 0; //not dirty after wb
      daddr = {dcacheReg[d_acc_map[d_index]][d_index][89:64], dcif.dmemaddr[5:2], 2'b00};
      if(dcif.dmemaddr[2])
      begin
        dstore = dcacheReg[d_acc_map[d_index]][d_index][63:32];
      end
      else 
      begin
        dstore = dcacheReg[d_acc_map[d_index]][d_index][31:0];  
      end

      if(!dwait)
      begin
        n_d_state = WB2;
      end
      else 
      begin
        n_d_state = WB1;  
      end
    end

    WB2:
    begin
      dWEN = 1;
      if(!dcif.dmemaddr[2])
      begin
        d_other_addr = dcif.dmemaddr + 4;
      end
      else 
      begin
        d_other_addr = dcif.dmemaddr - 4;
      end

      daddr = {dcacheReg[d_acc_map[d_index]][d_other_addr[5:3]][89:64], d_other_addr[5:2], 2'b00};

      if(d_other_addr[2])
      begin
        dstore = dcacheReg[d_acc_map[d_index]][d_other_addr[5:3]][63:32];
      end
      else 
      begin
        dstore = dcacheReg[d_acc_map[d_index]][d_other_addr[5:3]][31:0];
      end

      if(!dwait)
      begin
        n_d_state = ALL1;
      end
      else
      begin
        n_d_state = WB2;
      end
    end

    SNOOP_CHK:
    begin

      ccsnoopchecking = 1;

      if (snoop_same_tag != 2'b10) //tag matched
      begin
        if (ccinv == 0 && dcacheReg[snoop_same_tag][snoop_index][90] == 1) //M->S
        begin
          ccwrite = 1;//to write back
          n_dcacheReg[snoop_same_tag][snoop_index][90] = 0; //undirty
          n_d_state = SNOOP_WB1;
        end
        else if (ccinv == 1 && dcacheReg[snoop_same_tag][snoop_index][90] == 1) //M->I
        begin
          if (linkReg == ccsnoopaddr)
          begin
            n_link_valid = 0;  
          end
          
          ccwrite = 1;
          n_dcacheReg[snoop_same_tag][snoop_index][91] = 0; //invalidate
          n_dcacheReg[snoop_same_tag][snoop_index][90] = 0; //undirty
          n_d_state = SNOOP_WB1;
        end
        else if (ccinv == 1 && dcacheReg[snoop_same_tag][snoop_index][90] == 0) //S->I
        begin
          if (linkReg == ccsnoopaddr)
          begin
            n_link_valid = 0;
          end
          n_dcacheReg[snoop_same_tag][snoop_index][91] = 0; //invalidate
          n_dcacheReg[snoop_same_tag][snoop_index][90] = 0; //undirty
          n_d_state = IDLE;
        end
        else 
        begin
          n_d_state = IDLE;
        end
      end
      else 
      begin
        n_d_state = IDLE;
      end
       //n_d_state = IDLE;
    end

    SNOOP_WB1:
    begin
      dWEN = 1;
      n_dcacheReg[snoop_same_tag][snoop_index][90] = 0; //not dirty after wb
      daddr = {dcacheReg[snoop_same_tag][snoop_index][89:64], ccsnoopaddr[5:2], 2'b00};
      if(ccsnoopaddr[2])
      begin
        dstore = dcacheReg[snoop_same_tag][snoop_index][63:32];
      end
      else 
      begin
        dstore = dcacheReg[snoop_same_tag][snoop_index][31:0];  
      end

      if(!dwait)
      begin
        n_d_state = SNOOP_WB2;
      end
      else 
      begin
        n_d_state = SNOOP_WB1;  
      end
    end

    SNOOP_WB2:
    begin
      dWEN = 1;
      if(!ccsnoopaddr[2])
      begin
        d_other_addr = ccsnoopaddr + 4;
      end
      else 
      begin
        d_other_addr = ccsnoopaddr - 4;
      end

      daddr = {dcacheReg[snoop_same_tag][d_other_addr[5:3]][89:64], d_other_addr[5:2], 2'b00};

      if(d_other_addr[2])
      begin
        dstore = dcacheReg[snoop_same_tag][d_other_addr[5:3]][63:32];
      end
      else 
      begin
        dstore = dcacheReg[snoop_same_tag][d_other_addr[5:3]][31:0];
      end

      if(!dwait)
      begin
        n_d_state = IDLE;
      end
      else
      begin
        n_d_state = SNOOP_WB2;
      end
    end

    FLUSH1:
    begin
      if (dcacheReg[d_count[0]][d_count[3:1]][90])
      begin
        dWEN = 1;
        daddr = {dcacheReg[d_count[0]][d_count[3:1]][89:64], d_count[3:1], 3'b100};
        dstore = dcacheReg[d_count[0]][d_count[3:1]][63:32]; //hight 32 bits
        
        /*if (dcacheReg[d_count[0]][d_count[3:1]][63:32] == 32'hBAD0BAD0)
        begin
          dWEN = 0;
          n_d_state = FLUSH2;
        end
        else*/
        if(!dwait)
        begin
          n_dcacheReg[d_count[0]][d_count[3:1]][91] = 0;
          n_dcacheReg[d_count[0]][d_count[3:1]][90] = 0;
          n_d_state = FLUSH2;
        end
        else 
        begin
          n_d_state = FLUSH1;  
        end
      end
      else if (d_count == 15) 
      begin
        n_d_state = HIT_CNT;
      end
      else 
      begin
        n_d_count = d_count + 1;
        n_d_state = FLUSH1;  
      end
    end

    FLUSH2:
    begin
      dWEN = 1;
      daddr = {dcacheReg[d_count[0]][d_count[3:1]][89:64], d_count[3:1], 3'b000};
      dstore = dcacheReg[d_count[0]][d_count[3:1]][31:0]; //low 32 bits
      n_dcacheReg[d_count[0]][d_count[3:1]][91] = 0;
      n_dcacheReg[d_count[0]][d_count[3:1]][90] = 0;
     /* if(dcacheReg[d_count[0]][d_count[3:1]][31:0] ==32'hBAD0BAD0)
      begin
        dWEN = 0;
        if (d_count == 15) 
        begin
          n_d_state = HIT_CNT;
        end
        else 
        begin
          n_d_count = d_count + 1;
          n_d_state = FLUSH1;  
        end
      end
      else*/
      if(!dwait)
      begin
        if (d_count == 15) 
        begin
          n_d_state = HIT_CNT;
        end
        else 
        begin
          n_d_count = d_count + 1;
          n_d_state = FLUSH1;  
        end
      end
      else 
      begin
        n_d_state = FLUSH2;  
      end

    end

    HIT_CNT:
    begin
      dWEN = 0;
      daddr = 'h3100;
      dstore = hitT;
      //dcif.flushed = 1;
     
      /*if(dwait)
      begin
        n_d_state = HIT_CNT;
      end
      else begin*/
      n_d_state = IDLE;
      n_flushReg = 1;
      //end
    end

  endcase

end

endmodule

