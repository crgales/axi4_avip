//--------------------------------------------------------------------------------------------
// Class: axi4_read_test
// Extends the base test and starts the virtual sequence of 8 bit
//--------------------------------------------------------------------------------------------
class axi4_read_test extends axi4_base_test;
  `uvm_component_utils(axi4_read_test)

  function new(string name = "axi4_read_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void setup_test();
    set_type_override_by_type(axi4_virtual_base_seq::get_type(),
                              axi4_virtual_read_seq::get_type());
  endfunction
endclass : axi4_read_test
