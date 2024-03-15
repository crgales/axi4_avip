//--------------------------------------------------------------------------------------------
// Class: axi4_64b_data_read_test
// Extends the base test and starts the virtual sequenceof write
//--------------------------------------------------------------------------------------------
class axi4_blocking_64b_data_read_test extends axi4_base_test;
  `uvm_component_utils(axi4_blocking_64b_data_read_test)

  function new(string name = "axi4_blocking_64b_data_read_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void setup_axi4_env_cfg();
    super.setup_axi4_env_cfg();
    axi4_env_cfg_h.write_read_mode_h = ONLY_READ_DATA;
  endfunction:setup_axi4_env_cfg

  function void setup_test();
    set_type_override_by_type(axi4_virtual_base_seq::get_type(),
                              axi4_virtual_bk_64b_data_read_seq::get_type());
  endfunction

endclass : axi4_blocking_64b_data_read_test
