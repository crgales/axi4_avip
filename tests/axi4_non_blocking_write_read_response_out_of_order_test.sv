//--------------------------------------------------------------------------------------------
// Class: axi4_non_blocking_write_read_response_out_of_order_test
// Extends the base test and starts the virtual sequence of fixed burst write and read sequences
//--------------------------------------------------------------------------------------------
class axi4_non_blocking_write_read_response_out_of_order_test extends axi4_base_test;
  `uvm_component_utils(axi4_non_blocking_write_read_response_out_of_order_test)

  function new(string name = "axi4_non_blocking_write_read_response_out_of_order_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void setup_axi4_slave_agent_cfg();
    super.setup_axi4_slave_agent_cfg();
    foreach(axi4_env_cfg_h.axi4_slave_agent_cfg_h[i])begin
      axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].read_data_mode = SLAVE_MEM_MODE;
      axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].slave_response_mode =WRITE_READ_RESP_OUT_OF_ORDER ;
    end
  endfunction: setup_axi4_slave_agent_cfg

  function void setup_test();
    set_type_override_by_type(axi4_virtual_base_seq::get_type(),
                              axi4_virtual_nbk_write_read_response_out_of_order_seq::get_type());
  endfunction
endclass : axi4_non_blocking_write_read_response_out_of_order_test
