//--------------------------------------------------------------------------------------------
// Class axi4_non_blocking_qos_write_read_test
// Extends the base test and starts the virtual sequenceof write
//--------------------------------------------------------------------------------------------
class axi4_non_blocking_qos_write_read_test extends axi4_base_test;
  `uvm_component_utils(axi4_non_blocking_qos_write_read_test)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  function new(string name = "axi4_non_blocking_qos_write_read_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void setup_axi4_master_agent_cfg();
    super.setup_axi4_master_agent_cfg();
    foreach(axi4_env_cfg_h.axi4_master_agent_cfg_h[i])begin
      axi4_env_cfg_h.axi4_master_agent_cfg_h[i].qos_mode_type = WRITE_READ_QOS_MODE_ENABLE;
    end
  endfunction: setup_axi4_master_agent_cfg

  function void setup_axi4_slave_agent_cfg();
    super.setup_axi4_slave_agent_cfg();
    //  axi4_env_cfg_h.axi4_slave_agent_cfg_h = new[axi4_env_cfg_h.no_of_slaves];
    foreach(axi4_env_cfg_h.axi4_slave_agent_cfg_h[i])begin
      axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].qos_mode_type =  WRITE_READ_QOS_MODE_ENABLE;
    end
  endfunction: setup_axi4_slave_agent_cfg

  function void setup_axi4_env_cfg();
    super.setup_axi4_env_cfg();
    axi4_env_cfg_h.write_read_mode_h = ONLY_WRITE_DATA;
  endfunction:setup_axi4_env_cfg

  function void setup_test();
    set_type_override_by_type(axi4_virtual_base_seq::get_type(),
                              axi4_virtual_nbk_qos_write_read_seq::get_type());
  endfunction

endclass : axi4_non_blocking_qos_write_read_test
