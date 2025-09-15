//--------------------------------------------------------------------------------------------
// Class: axi4_write_read_test
// Extends the base test and starts the virtual sequenceof write
//--------------------------------------------------------------------------------------------
class axi4_write_read_test extends axi4_base_test;
  `uvm_component_utils(axi4_write_read_test)

  //Variable : axi4_virtual_write_read_seq_h
  //Instatiation of axi4_virtual_write_read_seq
  axi4_virtual_write_read_seq axi4_virtual_write_read_seq_h;
  
  //--------------------------------------------------------------------------------------------
  // Construct: new
  //
  // Parameters:
  //  name - axi4_write_read_test
  //  parent - parent under which this component is created
  //--------------------------------------------------------------------------------------------
  function new(string name = "axi4_write_read_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------------------------------------------------------------
  // Task: run_phase
  // Creates the axi4_virtual_write_read_seq sequence and starts the write virtual sequences
  //
  // Parameters:
  //  phase - uvm phase
  //--------------------------------------------------------------------------------------------
  task run_phase(uvm_phase phase);

    axi4_virtual_write_read_seq_h=axi4_virtual_write_read_seq::type_id::create("axi4_virtual_write_read_seq_h");
    configure_vsequencer(axi4_virtual_write_read_seq_h);
    `uvm_info(get_type_name(),$sformatf("axi4_write_read_test"),UVM_LOW);
    phase.raise_objection(this);
    axi4_virtual_write_read_seq_h.start(null);
    phase.drop_objection(this);

  endtask : run_phase

endclass : axi4_write_read_test


