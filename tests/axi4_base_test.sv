//--------------------------------------------------------------------------------------------
// Class: axi4_base_test
// axi4_base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class axi4_base_test extends uvm_test;

  `uvm_component_utils(axi4_base_test)

  // Variable: e_cfg_h
  // Declaring environment config handle
  axi4_env_config axi4_env_cfg_h;

  // Variable: axi4_env_h
  // Handle for environment
  axi4_env axi4_env_h;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "axi4_base_test", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void setup_axi4_env_cfg();
  extern virtual function void setup_axi4_master_agent_cfg();
  extern virtual local function void set_and_display_master_config();
  extern virtual function void setup_axi4_slave_agent_cfg();
  extern virtual local function void set_and_display_slave_config();
  extern virtual function void set_virtual_sequence_handles(axi4_virtual_base_seq seq,
                                                            axi4_master_agent axi4_master_agent_h,
                                                            axi4_slave_agent axi4_slave_agent_h);
  extern virtual function void setup_test();
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : axi4_base_test

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes class object
//
// Parameters:
//  name - axi4_base_test
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function axi4_base_test::new(string name = "axi4_base_test",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Setup the environemnt cfg
  setup_axi4_env_cfg();
  // Create the environment
  axi4_env_h = axi4_env::type_id::create("axi4_env_h",this);
endfunction : build_phase


//--------------------------------------------------------------------------------------------
// Function: setup_axi4_env_cfg
// Setup the environment configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void axi4_base_test:: setup_axi4_env_cfg();
  axi4_env_cfg_h = axi4_env_config::type_id::create("axi4_env_cfg_h");

  axi4_env_cfg_h.has_scoreboard = 1;
  axi4_env_cfg_h.no_of_masters = NO_OF_MASTERS;
  axi4_env_cfg_h.no_of_slaves = NO_OF_SLAVES;

  // Setup the axi4_master agent cfg
  setup_axi4_master_agent_cfg();
  set_and_display_master_config();

  // Setup the axi4_slave agent cfg
  setup_axi4_slave_agent_cfg();
  set_and_display_slave_config();

  axi4_env_cfg_h.write_read_mode_h = WRITE_READ_DATA;

  // set method for axi4_env_cfg
  uvm_config_db #(axi4_env_config)::set(this,"*","axi4_env_config",axi4_env_cfg_h);
  `uvm_info(get_type_name(),$sformatf("\nAXI4_ENV_CONFIG\n%s",axi4_env_cfg_h.sprint()),UVM_LOW);
endfunction: setup_axi4_env_cfg

//--------------------------------------------------------------------------------------------
// Function: setup_axi4_master_agent_cfg
// Setup the axi4_master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void axi4_base_test::setup_axi4_master_agent_cfg();
  bit [63:0]local_min_address;
  bit [63:0]local_max_address;
  axi4_env_cfg_h.axi4_master_agent_cfg_h = new[axi4_env_cfg_h.no_of_masters];
  foreach(axi4_env_cfg_h.axi4_master_agent_cfg_h[i])begin
    axi4_env_cfg_h.axi4_master_agent_cfg_h[i] =
    axi4_master_agent_config::type_id::create($sformatf("axi4_master_agent_cfg_h[%0d]",i));
    axi4_env_cfg_h.axi4_master_agent_cfg_h[i].is_active   = uvm_active_passive_enum'(UVM_ACTIVE);
    axi4_env_cfg_h.axi4_master_agent_cfg_h[i].has_coverage = 1;
    axi4_env_cfg_h.axi4_master_agent_cfg_h[i].qos_mode_type = QOS_MODE_DISABLE;
  end

  for(int i =0; i<NO_OF_SLAVES; i++) begin
    if(i == 0) begin
      axi4_env_cfg_h.axi4_master_agent_cfg_h[i].master_min_addr_range(i,0);
      local_min_address = axi4_env_cfg_h.axi4_master_agent_cfg_h[i].master_min_addr_range_array[i];
      axi4_env_cfg_h.axi4_master_agent_cfg_h[i].master_max_addr_range(i,2**(SLAVE_MEMORY_SIZE)-1 );
      local_max_address = axi4_env_cfg_h.axi4_master_agent_cfg_h[i].master_max_addr_range_array[i];
    end
    else begin
      axi4_env_cfg_h.axi4_master_agent_cfg_h[i].master_min_addr_range(i,local_max_address + SLAVE_MEMORY_GAP);
      local_min_address = axi4_env_cfg_h.axi4_master_agent_cfg_h[i].master_min_addr_range_array[i];
      axi4_env_cfg_h.axi4_master_agent_cfg_h[i].master_max_addr_range(i,local_max_address+ 2**(SLAVE_MEMORY_SIZE)-1 +
                                                                      SLAVE_MEMORY_GAP);
      local_max_address = axi4_env_cfg_h.axi4_master_agent_cfg_h[i].master_max_addr_range_array[i];
    end
  end
endfunction: setup_axi4_master_agent_cfg

//--------------------------------------------------------------------------------------------
// Using this function for setting the master config to database
//--------------------------------------------------------------------------------------------
function void axi4_base_test::set_and_display_master_config();
  foreach(axi4_env_cfg_h.axi4_master_agent_cfg_h[i])begin
    uvm_config_db#(axi4_master_agent_config)::set(this,"*env*",$sformatf("axi4_master_agent_config[%0d]",i),axi4_env_cfg_h.axi4_master_agent_cfg_h[i]);
   `uvm_info(get_type_name(),$sformatf("\nAXI4_MASTER_CONFIG[%0d]\n%s",i,axi4_env_cfg_h.axi4_master_agent_cfg_h[i].sprint()),UVM_LOW);
 end
endfunction: set_and_display_master_config

//--------------------------------------------------------------------------------------------
// Function: setup_axi4_slave_agents_cfg
// Setup the axi4_slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void axi4_base_test::setup_axi4_slave_agent_cfg();
  axi4_env_cfg_h.axi4_slave_agent_cfg_h = new[axi4_env_cfg_h.no_of_slaves];
  foreach(axi4_env_cfg_h.axi4_slave_agent_cfg_h[i])begin
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i] =
    axi4_slave_agent_config::type_id::create($sformatf("axi4_slave_agent_cfg_h[%0d]",i));
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].slave_id = i;
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].min_address = axi4_env_cfg_h.axi4_master_agent_cfg_h[i].
                                                           master_min_addr_range_array[i];
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].max_address = axi4_env_cfg_h.axi4_master_agent_cfg_h[i].
                                                           master_max_addr_range_array[i];
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].maximum_transactions = 3;
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].read_data_mode = RANDOM_DATA_MODE;
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].slave_response_mode = RESP_IN_ORDER;
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].qos_mode_type = QOS_MODE_DISABLE;

    if(SLAVE_AGENT_ACTIVE === 1) begin
      axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].is_active = uvm_active_passive_enum'(UVM_ACTIVE);
    end
    else begin
      axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].is_active = uvm_active_passive_enum'(UVM_PASSIVE);
    end
    axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].has_coverage = 1;

  end
endfunction: setup_axi4_slave_agent_cfg

//--------------------------------------------------------------------------------------------
// Using this function for setting the slave config to database
//--------------------------------------------------------------------------------------------
function void axi4_base_test::set_and_display_slave_config();
  foreach(axi4_env_cfg_h.axi4_slave_agent_cfg_h[i])begin
    uvm_config_db #(axi4_slave_agent_config)::set(this,"*env*",$sformatf("axi4_slave_agent_config[%0d]",i), axi4_env_cfg_h.axi4_slave_agent_cfg_h[i]);
    uvm_config_db #(read_data_type_mode_e)::set(this,"*","read_data_mode",axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].read_data_mode);
   `uvm_info(get_type_name(),$sformatf("\nAXI4_SLAVE_CONFIG[%0d]\n%s",i,axi4_env_cfg_h.axi4_slave_agent_cfg_h[i].sprint()),UVM_LOW);
 end
endfunction: set_and_display_slave_config

//--------------------------------------------------------------------------------------------
// Using this function for setting the sequencer handles
//--------------------------------------------------------------------------------------------
function void axi4_base_test::set_virtual_sequence_handles(axi4_virtual_base_seq seq,
                                                           axi4_master_agent axi4_master_agent_h,
                                                           axi4_slave_agent axi4_slave_agent_h);
  seq.axi4_master_write_seqr_h = axi4_master_agent_h.axi4_master_write_seqr_h;
  seq.axi4_master_read_seqr_h = axi4_master_agent_h.axi4_master_read_seqr_h;
  seq.axi4_slave_write_seqr_h = axi4_slave_agent_h.axi4_slave_write_seqr_h;
  seq.axi4_slave_read_seqr_h = axi4_slave_agent_h.axi4_slave_read_seqr_h;
endfunction: set_virtual_sequence_handles

//--------------------------------------------------------------------------------------------
// Using this function for setting the virtual test sequence
//--------------------------------------------------------------------------------------------
function void axi4_base_test::setup_test();
  set_type_override_by_type(axi4_virtual_base_seq::get_type(),  // For reference - extend in test
                            axi4_virtual_base_seq::get_type());
endfunction: setup_test

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// Used for printing the testbench topology
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void axi4_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
  uvm_test_done.set_drain_time(this,3000ns);
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used for giving basic delay for simulation
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task axi4_base_test::run_phase(uvm_phase phase);
  axi4_virtual_base_seq seq_h;
  setup_test();
  seq_h = axi4_virtual_base_seq::type_id::create("seq_h");
  if (!seq_h.randomize()) begin
    `uvm_fatal("SEQRNDERR", "Unable to randomize test sequence");
  end
  seq_h.env_cfg_h = axi4_env_cfg_h;
  set_virtual_sequence_handles(seq_h,
                               axi4_env_h.axi4_master_agent_h[0],
                               axi4_env_h.axi4_slave_agent_h[0]);
  phase.raise_objection(this, "axi4_base_test");
  seq_h.start(null);
  phase.drop_objection(this);
endtask : run_phase
