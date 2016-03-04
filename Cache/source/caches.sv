/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/




// cpu types
`include "cpu_types_pkg.vh"

// interfaces
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"

module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  cache_control_if ccif
);
  // import types
  import cpu_types_pkg::word_t;

  parameter CPUID = 0;  


  //logic imemload;
 // logic dmemload;


 Icache ICACHE(CLK, nRST, dcif.dmemREN, dcif.dmemWEN, dcif.halt, ccif, dcif);
 Dcache DCACHE(CLK, nRST, ccif, dcif);


  // dcache invalidate before halt
  //assign dcif.flushed = dcif.halt;

  //single cycle
 // assign dcif.ihit = (dcif.imemREN) ? ~ccif.iwait : 0;
 // assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~ccif.dwait : 0;

  //assign dcif.ihit = ihit;
  //assign dcif.dhit = dhit;

  //assign dcif.imemload = imemload;
  //assign dcif.dmemload = dmemload;
  //assign dcif.dmemload = ccif.dload;


  //assign ccif.iREN = dcif.imemREN;
  //assign ccif.dREN = dcif.dmemREN;
  //assign ccif.dWEN = dcif.dmemWEN;
  //assign ccif.dstore = dcif.dmemstore;
  //assign ccif.iaddr = dcif.imemaddr;
  //assign ccif.daddr = daddr;
  //assign ccif.daddr = dcif.dmemaddr;

endmodule
