/*
  Eric Villasenor
  evillase@gmail.com

  holds datapath and cache interface signals
*/
`ifndef DATAPATH_CACHE_IF_VH
`define DATAPATH_CACHE_IF_VH

// types
`include "cpu_types_pkg.vh"

interface datapath_cache_if;
  // import types
  import cpu_types_pkg::*;

// datapath signals
  // stop processing
  logic               halt;

// Icache signals
  // hit and enable
  logic               ihit, imemREN;
  // instruction addr
  word_t             imemload, imemaddr;

// Dcache signals
  // hit, atomic and enables
  logic               dhit, datomic, dmemREN, dmemWEN, flushed;
  // data and address
  word_t              dmemload, dmemstore, dmemaddr;

  logic [1:0] datomicSTATE;

  // datapath ports
  modport dp (
    input   ihit, imemload, dhit, dmemload, datomicSTATE,
    output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic,
            dmemstore, dmemaddr
  );

  // cache block ports
  modport cache (
    input   halt, imemREN, dmemREN, dmemWEN, datomic,
            dmemstore, dmemaddr, imemaddr,
    output  ihit, dhit, imemload, dmemload, flushed
  );

  // icache ports
  modport icache (
    input   imemREN, imemaddr,
    output  ihit, imemload
  );

  modport icachetb (
    input ihit, imemload,
    output imemREN, imemaddr
  );

  // dcache ports
  modport dcache (
    input   halt, dmemREN, dmemWEN,
            datomic, dmemstore, dmemaddr,
    output  dhit, dmemload, flushed
  );

  modport dcachetb (
    input  dhit, dmemload, flushed,
    output halt, dmemREN, dmemWEN,
            datomic, dmemstore, dmemaddr
  );

endinterface

`endif //DATAPATH_CACHE_IF_VH
