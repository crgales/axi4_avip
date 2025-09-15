//--------------------------------------------------------------------------------------------
//Class: axi4_virtual_base_seq
// Description:
// This class contains the handle of actual sequencer pointing towards them
//--------------------------------------------------------------------------------------------
class axi4_virtual_base_seq extends uvm_sequence;
  `uvm_object_utils(axi4_virtual_base_seq)
 
  axi4_env_config env_cfg_h;

  axi4_master_sequencer_t axi4_master_write_seqr_h;
  axi4_master_sequencer_t axi4_master_read_seqr_h;
  axi4_slave_sequencer_t axi4_slave_write_seqr_h;
  axi4_slave_sequencer_t axi4_slave_read_seqr_h;

  //--------------------------------------------------------------------------------------------
  //Constructor:new
  //
  //Paramters:
  //name - Instance name of the virtual_sequence
  //parent - parent under which this component is created
  //--------------------------------------------------------------------------------------------
  function new(string name="axi4_virtual_base_seq");
    super.new(name);
  endfunction:new

endclass:axi4_virtual_base_seq



