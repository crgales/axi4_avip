//--------------------------------------------------------------------------------------------
// Class: axi4_non_blocking_cross_write_read_test
// Extends the base test and starts the virtual sequence of write and read sequences
//--------------------------------------------------------------------------------------------
class axi4_non_blocking_cross_write_read_test extends axi4_base_test;
  `uvm_component_utils(axi4_non_blocking_cross_write_read_test)

  function new(string name = "axi4_non_blocking_cross_write_read_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void setup_test();
    set_type_override_by_type(axi4_virtual_base_seq::get_type(),
                              axi4_virtual_nbk_cross_write_read_seq::get_type());
  endfunction
endclass : axi4_non_blocking_cross_write_read_test
