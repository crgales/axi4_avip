//--------------------------------------------------------------------------------------------
// Package: axi4_slave_pkg
//  Includes all the files related to axi4 axi4_slave
//--------------------------------------------------------------------------------------------
package axi4_slave_pkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Import axi4_globals_pkg 
  import axi4_globals_pkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "axi4_slave_memory.sv"
  `include "axi4_slave_tx.sv"
  `include "axi4_slave_agent_config.sv"
  `include "axi4_slave_seq_item_converter.sv"
  `include "axi4_slave_cfg_converter.sv"
  `include "axi4_slave_coverage.sv"
  typedef uvm_sequencer#(axi4_slave_tx) axi4_slave_sequencer_t;
  `include "axi4_slave_driver_proxy.sv"
  `include "axi4_slave_monitor_proxy.sv"
  `include "axi4_slave_agent.sv"
  
endpackage : axi4_slave_pkg

