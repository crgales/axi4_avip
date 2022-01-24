`ifndef AXI4_SLAVE_MONITOR_BFM_INCLUDED_
`define AXI4_SLAVE_MONITOR_BFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : axi4_slave_monitor_bfm
//Used as the HDL monitor for axi4
//It connects with the HVL monitor_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import axi4_globals_pkg::*;
interface axi4_slave_monitor_bfm(input aclk, input aresetn,
                                //Write_address_channel
                                input [3:0]               awid    ,
                                input [ADDRESS_WIDTH-1:0] awaddr  ,
                                input [3: 0]              awlen   ,
                                input [2: 0]              awsize  ,
                                input [1: 0]              awburst ,
                                input [1: 0]              awlock  ,
                                input [3: 0]              awcache ,
                                input [2: 0]              awprot  ,
                                input                     awvalid ,
                                input 	                  awready ,

                                
                                //write_data_channel
                                input [DATA_WIDTH-1: 0]     wdata  ,
                                input [(DATA_WIDTH/8)-1: 0] wstrb  ,
                                input                       wlast  ,
                                input [3: 0]                wuser  ,
                                input                       wvalid ,
                                input 	                    wready ,

                                //Write Response Channel
                                input  [3:0]              bid    ,
                                input  [1:0]              bresp  ,
                                input  [3:0]              buser  ,
                                input                     bvalid ,
                                input		                  bready ,

                                //Read Address Channel
                                input [3: 0]                arid    ,
                                input [ADDRESS_WIDTH-1: 0]  araddr  ,
                                input [7:0]                 arlen   ,
                                input [2:0]                 arsize  ,
                                input [1:0]                 arburst ,
                                input [1:0]                 arlock  ,
                                input [3:0]                 arcache ,
                                input [2:0]                 arprot  ,
                                input [3:0]                 arqos   ,
                                input [3:0]                 arregion,
                                input [3:0]                 aruser  ,
                                input                       arvalid ,
                                input                       arready ,

                                //Read Data Channel
                                input  [3:0]                rid    ,
                                input  [DATA_WIDTH-1: 0]    rdata  ,
                                //input  [(DATA_WIDTH/8)-1: 0]rstrb  ,
                                input  [1:0]                rresp  ,
                                input                       rlast  ,
                                input  [3:0]                ruser  ,
                                input                       rvalid ,
                                input		                        rready   
  
                               ); 
  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  //-------------------------------------------------------
  // Importing axi4 Global Package slave package
  //-------------------------------------------------------
  import axi4_slave_pkg::axi4_slave_monitor_proxy;

  reg[3:0] i = 0;

  //--------------------------------------------------------------------------------------------
  // Creating handle for virtual Interface
  //--------------------------------------------------------------------------------------------
 
  //Variable : axi4_slave_monitor_proxy_h
  //Creating the handle for proxy monitor
  axi4_slave_monitor_proxy axi4_slave_mon_proxy_h;
  
  //Printing axi4 slave monitor bfm
  initial begin
    `uvm_info("axi4 slave monitor bfm",$sformatf("AXI4 SLAVE MONITOR BFM"),UVM_LOW);
  end

  //-------------------------------------------------------
  // Task: wait_for_aresetn
  // Waiting for the system reset to be active low
  //-------------------------------------------------------

  task wait_for_aresetn();
    @(negedge aresetn);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("SYSTEM RESET DETECTED"),UVM_HIGH)
   
    @(posedge aresetn);
    `uvm_info("FROM SLAVE MON BFM",$sformatf("SYSTEM RESET DEACTIVATED"),UVM_HIGH)
  endtask : wait_for_aresetn
  
  //-------------------------------------------------------
  // Task: axi4_write_address_sampling
  // Used for sample the write address channel signals
  //-------------------------------------------------------

  task axi4_slave_write_address_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(posedge aclk);
    while(awvalid!==1 || awready!==1)begin
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop......"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop from axi4_slave_write_address_sampling "),UVM_HIGH)
   
    req.awid = awid;
    req.awaddr = awaddr;
    req.awlen = awlen;
    req.awsize = awsize;
    req.awburst = awburst;
    req.awlock = awlock;
    req.awcache = awcache;
    req.awprot = awprot;  
  endtask

  task axi4_slave_write_data_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(posedge aclk);
    while(wvalid!==1 || wready!==1)begin
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop......"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop ......."),UVM_HIGH)
   req.wdata.push_back(wdata);
   req.wstrb.push_back(wstrb);
   req.wlast = wlast;
   req.wuser = wuser;
  endtask
  
  task axi4_write_response_sampling(output axi4_write_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
    @(posedge aclk);
    while(bvalid!==1 || bready!==1)begin
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop of the write response"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop of the write sampling"),UVM_HIGH)
    req.bid = bid;
    req.bresp = bresp;
    req.buser = buser;
    `uvm_info("FROM SLAVE MON BFM",$sformatf("WRITE RESPONSE SAMPLING: \n %p ",req),UVM_HIGH) 
  endtask
    
  task axi4_read_address_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);

    @(posedge aclk);
    while(arvalid!==1 || arready!==1)begin
      @(posedge aclk);
      `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("Inside while loop of read address"),UVM_HIGH)
    end    
    `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("after while loop of read address"),UVM_HIGH)
    
    req.arid     = arid;
    req.araddr   = araddr;
    req.arlen    = arlen;
    req.arsize   = arsize;
    req.arburst  = arburst;
    req.arlock   = arlock;
    req.arcache  = arcache;
    req.arprot   = arprot;
    req.arqos    = arqos;
    req.arregion = arregion;
    req.aruser   = aruser;

    `uvm_info("FROM SLAVE MON BFM READ ADDR",$sformatf("datapacket =%p",req),UVM_HIGH)

  endtask
 
  task axi4_read_data_sampling(output axi4_read_transfer_char_s req ,input axi4_transfer_cfg_s cfg);
   @(posedge aclk);
     while(rvalid!==1 || rready!==1)begin
       @(posedge aclk);
       `uvm_info("FROM SLAVE MON BFM",$sformatf("Inside while loop of read data sample"),UVM_HIGH)
     end    
     `uvm_info("FROM SLAVE MON BFM",$sformatf("after while loop of read data sample"),UVM_HIGH)
    
     //for(int i=0; i<arlen + 1; i++) begin
     //do begin
   while(rlast!=1) begin
       @(posedge aclk);
       req.rid      = rid;
       `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON RID=%0b",req.rid),UVM_HIGH)
       req.rdata[i] = rdata;
       req.ruser    = ruser;
       req.rresp    = rresp;
       i++;
       `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON RDATA[%0d]=%0h",i,rdata),UVM_HIGH)
       `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("DEBUG:SLAVE MON RDATA[%0d]=%0h",i,req.rdata[i]),UVM_HIGH)
     end //while(rlast!=1);
     
     req.rlast  <= rlast;
     `uvm_info("FROM SLAVE MON BFM READ DATA",$sformatf("Read data packet: %p",req),UVM_HIGH)

  endtask

endinterface : axi4_slave_monitor_bfm
`endif
