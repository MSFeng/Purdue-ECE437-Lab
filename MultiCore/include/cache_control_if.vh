/*
  Eric Villasenor
  evillase@gmail.com

  interface to coordinate caches and
  implement coherence protocol
  TODO: make interface array of 2 and pass array, or something
*/
`ifndef CACHE_CONTROL_IF_VH
`define CACHE_CONTROL_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"

// split this into cache_control_if and ram_if
interface cache_control_if;
  // import types
  import cpu_types_pkg::*;

  // access with cpuid on each processor
  parameter CPUS = 2;

  // arbitration
  logic   [CPUS-1:0]       iwait, dwait, iREN, dREN, dWEN;
  word_t  [CPUS-1:0]       iload, dload, dstore;
  word_t  [CPUS-1:0]       iaddr, daddr;

  // coherence
  // CPUS = number of cpus parameter passed from system -> cc
  // ccwait         : lets a cache know it needs to block cpu
  // ccinv          : let a cache know it needs to invalidate entry
  // ccwrite        : high if cache is doing a write of addr
  // ccsnoopaddr    : the addr being sent to other cache with either (wb/inv)
  // cctrans        : high if the cache state is transitioning (i.e. I->S, I->M, etc...)
  logic   [CPUS-1:0]      ccwait, ccinv;
  logic   [CPUS-1:0]      ccwrite, cctrans;
  word_t  [CPUS-1:0]      ccsnoopaddr;
  logic  [CPUS-1:0]      ccsnoopchecking;
  word_t  [CPUS-1:0]      ccsnoopvalue;
  logic  [CPUS-1:0]       ccsnoopvalid;
  logic                   cccofreetomove;

  logic  [CPUS-1:0]       ccatomicinvalidating;
  word_t [CPUS-1:0]       ccatomicaddr;
  logic  [CPUS-1:0]       ccatomicinvalidate;



  //customized
  //logic   [CPUS-1:0]      ccinvdone;
  //logic   [CPUS-1:0]      ccwb;
  //logic   [CPUS-1:0]      ccwbdone;

  // ram side
  logic                   ramWEN, ramREN;
  ramstate_t              ramstate;
  word_t                  ramaddr, ramstore, ramload;

  // controller ports to ram and caches
  modport cc (
            // cache inputs
    input   iREN, dREN, dWEN, dstore, iaddr, daddr,
            // ram inputs
            ramload, ramstate,
            // coherence inputs from cache
            ccwrite, cctrans,
            // cache outputs
    output  iwait, dwait, iload, dload,
            // ram outputs
            ramstore, ramaddr, ramWEN, ramREN,
            // coherence outputs to cache
            ccwait, ccinv, ccsnoopaddr
  );

  // icache ports to controller
  /*modport icache (
    input   iwait, iload,
    output  iREN, iaddr
  );

  // dcache ports to controller
  modport dcache (
    input   dwait, dload,
            ccwait, ccinv, ccsnoopaddr,
    output  dREN, dWEN, daddr, dstore,
            ccwrite, cctrans
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 249050928643769724f18ca6662802967b5b838a
  );
  modport caches (
    input   iwait, iload, dwait, dload,
            ccwait, ccinv, ccsnoopaddr,
    output  iREN, iaddr, dREN, dWEN, daddr, dstore,
            ccwrite, cctrans
<<<<<<< HEAD
>>>>>>> 7dabfc3f11bbd03f1d249da3c2c0e8ce18ffaab5
  );
  modport caches (
    input   iwait, iload, dwait, dload,
            ccwait, ccinv, ccsnoopaddr,
    output  iREN, iaddr, dREN, dWEN, daddr, dstore,
            ccwrite, cctrans
  );*/

  modport caches (
    input   iwait, 
    input   iload,
    input   dwait, 
    input   dload,
    input   ccwait,
    input   ccinv,
    input   ccsnoopaddr,

    output  iREN,
    output  iaddr,
    output  dREN,
    output  dWEN,
    output  daddr,
    output  dstore,
    output  ccwrite,
    output  cctrans  
);

  modport icache (
    input   iwait, 
    input   iload,

    output  iREN,
    output  iaddr  
);

  /*modport icachetb (
    output  iwait, 
    output  iload,

    input  iREN,
    input  iaddr 

  );*/

  modport dcache (
    input   dwait, 
    input   dload,
    input   ccwait,
    input   ccinv,
    input   ccsnoopaddr,

    output  dREN,
    output  dWEN,
    output  daddr,
    output  dstore,
    output  ccwrite,
    output  cctrans  
);

 /* modport dcachetb (
    output   dwait, 
    output   dload,
    output   ccwait,
    output   ccinv,
    output   ccsnoopaddr,

    input  dREN,
    input  dWEN,
    input  daddr,
    input  dstore,
    input  ccwrite,
    input  cctrans  
  );*/



endinterface

`endif //CACHE_CONTROL_IF_VH
