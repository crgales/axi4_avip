//--------------------------------------------------------------------------------------------
// Class: axi4_non_blocking_64b_write_data_test
// Extends the base test and starts the virtual sequenceof write
//--------------------------------------------------------------------------------------------
class axi4_non_blocking_64b_write_data_test extends axi4_base_test;
  `uvm_component_utils(axi4_non_blocking_64b_write_data_test)

  function new(string name = "axi4_non_blocking_64b_write_data_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void setup_axi4_env_cfg();
    super.setup_axi4_env_cfg();
    axi4_env_cfg_h.write_read_mode_h = ONLY_WRITE_DATA;
  endfunction:setup_axi4_env_cfg

  function void setup_test();
    set_type_override_by_type(axi4_virtual_base_seq::get_type(),
                              axi4_virtual_nbk_64b_write_data_seq::get_type());
  endfunction
endclass : axi4_non_blocking_64b_write_data_test
