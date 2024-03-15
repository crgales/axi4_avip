//--------------------------------------------------------------------------------------------
//Class: axi4_virtual_base_seq
// Description:
// This class contains the handle of actual sequencer pointing towards them
//--------------------------------------------------------------------------------------------
class axi4_virtual_base_seq extends uvm_sequence;
  `uvm_object_utils(axi4_virtual_base_seq)

  // Variable: master_write_seqr_h
  // Declaring master write sequencer handle
  axi4_master_write_sequencer axi4_master_write_seqr_h;

  // Variable: master_read_seqr_h
  // Declaring master read sequencer handle
  axi4_master_read_sequencer axi4_master_read_seqr_h;

  // Variable: slave_write_seqr_h
  // Declaring slave write sequencer handle
  axi4_slave_write_sequencer axi4_slave_write_seqr_h;

  // Variable: slave_read_seqr_h
  // Declaring slave read sequencer handle
  axi4_slave_read_sequencer axi4_slave_read_seqr_h;

  axi4_env_config env_cfg_h;

  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="axi4_virtual_base_seq");
  extern task body();

endclass:axi4_virtual_base_seq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_virtual_base_seq::new(string name="axi4_virtual_base_seq");
  super.new(name);
endfunction:new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task axi4_virtual_base_seq::body();
   if(env_cfg_h == null) begin
    `uvm_fatal("CONFIG","Configuration not provided to virtual sequence")
  end
endtask:body
