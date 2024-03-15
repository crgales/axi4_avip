//--------------------------------------------------------------------------------------------
// Class: axi4_blocking_slave_error_write_read_test
// Extends the base test and starts the virtual sequence of slave error of write and read sequences
//--------------------------------------------------------------------------------------------
class axi4_blocking_slave_error_write_read_test extends axi4_base_test;
  `uvm_component_utils(axi4_blocking_slave_error_write_read_test)

  function new(string name = "axi4_blocking_slave_error_write_read_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void setup_axi4_slave_agent_cfg();
    super.setup_axi4_slave_agent_cfg();
    foreach(axi4_env_cfg_h.axi4_slave_agent_cfg_h[i])begin
      axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].read_data_mode = SLAVE_ERR_RESP_MODE;
    end
  endfunction: setup_axi4_slave_agent_cfg

  function void setup_test();
    set_type_override_by_type(axi4_virtual_base_seq::get_type(),
                              axi4_virtual_bk_slave_error_write_read_seq::get_type());
  endfunction

endclass : axi4_blocking_slave_error_write_read_test
