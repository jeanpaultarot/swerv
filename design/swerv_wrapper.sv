// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Western Digital Corporation or its affiliates.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//********************************************************************************
// $Id$
//
// Function: Top wrapper file with swerv/mem instantiated inside
// Comments: 
//
//********************************************************************************
`include "build.h"
//`include "def.sv"
module swerv_wrapper  
   import swerv_types::*;
(
   input logic                       clk,
   input logic                       rst_l,
   input logic [31:1]                rst_vec,
   input logic                       nmi_int,
   input logic [31:1]                nmi_vec,                       
   input logic [31:1]                jtag_id,
                       

   output logic [63:0] trace_rv_i_insn_ip,
   output logic [63:0] trace_rv_i_address_ip,
   output logic [2:0]  trace_rv_i_valid_ip,
   output logic [2:0]  trace_rv_i_exception_ip,
   output logic [4:0]  trace_rv_i_ecause_ip,
   output logic [2:0]  trace_rv_i_interrupt_ip,
   output logic [31:0] trace_rv_i_tval_ip,

   // Bus signals

`ifdef RV_BUILD_AXI4
   //-------------------------- LSU AXI signals--------------------------
   // AXI Write Channels
   output logic                            lsu_axi_awvalid,
   input  logic                            lsu_axi_awready,
   output logic [`RV_LSU_BUS_TAG-1:0]      lsu_axi_awid,
   output logic [31:0]                     lsu_axi_awaddr,
   output logic [3:0]                      lsu_axi_awregion,
   output logic [7:0]                      lsu_axi_awlen,
   output logic [2:0]                      lsu_axi_awsize,
   output logic [1:0]                      lsu_axi_awburst,
   output logic                            lsu_axi_awlock,
   output logic [3:0]                      lsu_axi_awcache,
   output logic [2:0]                      lsu_axi_awprot,
   output logic [3:0]                      lsu_axi_awqos,
                                           
   output logic                            lsu_axi_wvalid,                                       
   input  logic                            lsu_axi_wready,
   output logic [63:0]                     lsu_axi_wdata,
   output logic [7:0]                      lsu_axi_wstrb,
   output logic                            lsu_axi_wlast,
                                           
   input  logic                            lsu_axi_bvalid,
   output logic                            lsu_axi_bready,
   input  logic [1:0]                      lsu_axi_bresp,
   input  logic [`RV_LSU_BUS_TAG-1:0]      lsu_axi_bid,
                                           
   // AXI Read Channels                    
   output logic                            lsu_axi_arvalid,
   input  logic                            lsu_axi_arready,
   output logic [`RV_LSU_BUS_TAG-1:0]      lsu_axi_arid,
   output logic [31:0]                     lsu_axi_araddr,
   output logic [3:0]                      lsu_axi_arregion,
   output logic [7:0]                      lsu_axi_arlen,
   output logic [2:0]                      lsu_axi_arsize,
   output logic [1:0]                      lsu_axi_arburst,
   output logic                            lsu_axi_arlock,
   output logic [3:0]                      lsu_axi_arcache,
   output logic [2:0]                      lsu_axi_arprot,
   output logic [3:0]                      lsu_axi_arqos,
                                           
   input  logic                            lsu_axi_rvalid,
   output logic                            lsu_axi_rready,
   input  logic [`RV_LSU_BUS_TAG-1:0]      lsu_axi_rid,
   input  logic [63:0]                     lsu_axi_rdata,
   input  logic [1:0]                      lsu_axi_rresp,
   input  logic                            lsu_axi_rlast,
   
   //-------------------------- IFU AXI signals--------------------------
   // AXI Write Channels
   output logic                            ifu_axi_awvalid,
   input  logic                            ifu_axi_awready,
   output logic [`RV_IFU_BUS_TAG-1:0]      ifu_axi_awid,
   output logic [31:0]                     ifu_axi_awaddr,
   output logic [3:0]                      ifu_axi_awregion,
   output logic [7:0]                      ifu_axi_awlen,
   output logic [2:0]                      ifu_axi_awsize,
   output logic [1:0]                      ifu_axi_awburst,
   output logic                            ifu_axi_awlock,
   output logic [3:0]                      ifu_axi_awcache,
   output logic [2:0]                      ifu_axi_awprot,
   output logic [3:0]                      ifu_axi_awqos,
                                           
   output logic                            ifu_axi_wvalid,                                       
   input  logic                            ifu_axi_wready,
   output logic [63:0]                     ifu_axi_wdata,
   output logic [7:0]                      ifu_axi_wstrb,
   output logic                            ifu_axi_wlast,
                                           
   input  logic                            ifu_axi_bvalid,
   output logic                            ifu_axi_bready,
   input  logic [1:0]                      ifu_axi_bresp,
   input  logic [`RV_IFU_BUS_TAG-1:0]      ifu_axi_bid,
                                           
   // AXI Read Channels                    
   output logic                            ifu_axi_arvalid,
   input  logic                            ifu_axi_arready,
   output logic [`RV_IFU_BUS_TAG-1:0]      ifu_axi_arid,
   output logic [31:0]                     ifu_axi_araddr,
   output logic [3:0]                      ifu_axi_arregion,
   output logic [7:0]                      ifu_axi_arlen,
   output logic [2:0]                      ifu_axi_arsize,
   output logic [1:0]                      ifu_axi_arburst,
   output logic                            ifu_axi_arlock,
   output logic [3:0]                      ifu_axi_arcache,
   output logic [2:0]                      ifu_axi_arprot,
   output logic [3:0]                      ifu_axi_arqos,
                                           
   input  logic                            ifu_axi_rvalid,
   output logic                            ifu_axi_rready,
   input  logic [`RV_IFU_BUS_TAG-1:0]      ifu_axi_rid,
   input  logic [63:0]                     ifu_axi_rdata,
   input  logic [1:0]                      ifu_axi_rresp,
   input  logic                            ifu_axi_rlast,

   //-------------------------- SB AXI signals--------------------------
   // AXI Write Channels
   output logic                            sb_axi_awvalid,
   input  logic                            sb_axi_awready,
   output logic [`RV_SB_BUS_TAG-1:0]       sb_axi_awid,
   output logic [31:0]                     sb_axi_awaddr,
   output logic [3:0]                      sb_axi_awregion,
   output logic [7:0]                      sb_axi_awlen,
   output logic [2:0]                      sb_axi_awsize,
   output logic [1:0]                      sb_axi_awburst,
   output logic                            sb_axi_awlock,
   output logic [3:0]                      sb_axi_awcache,
   output logic [2:0]                      sb_axi_awprot,
   output logic [3:0]                      sb_axi_awqos,
                                           
   output logic                            sb_axi_wvalid,                                       
   input  logic                            sb_axi_wready,
   output logic [63:0]                     sb_axi_wdata,
   output logic [7:0]                      sb_axi_wstrb,
   output logic                            sb_axi_wlast,
                                           
   input  logic                            sb_axi_bvalid,
   output logic                            sb_axi_bready,
   input  logic [1:0]                      sb_axi_bresp,
   input  logic [`RV_SB_BUS_TAG-1:0]       sb_axi_bid,
                                           
   // AXI Read Channels                    
   output logic                            sb_axi_arvalid,
   input  logic                            sb_axi_arready,
   output logic [`RV_SB_BUS_TAG-1:0]       sb_axi_arid,
   output logic [31:0]                     sb_axi_araddr,
   output logic [3:0]                      sb_axi_arregion,
   output logic [7:0]                      sb_axi_arlen,
   output logic [2:0]                      sb_axi_arsize,
   output logic [1:0]                      sb_axi_arburst,
   output logic                            sb_axi_arlock,
   output logic [3:0]                      sb_axi_arcache,
   output logic [2:0]                      sb_axi_arprot,
   output logic [3:0]                      sb_axi_arqos,
                                           
   input  logic                            sb_axi_rvalid,
   output logic                            sb_axi_rready,
   input  logic [`RV_SB_BUS_TAG-1:0]       sb_axi_rid,
   input  logic [63:0]                     sb_axi_rdata,
   input  logic [1:0]                      sb_axi_rresp,
   input  logic                            sb_axi_rlast,

   //-------------------------- DMA AXI signals--------------------------
   // AXI Write Channels
   input  logic                         dma_axi_awvalid,
   output logic                         dma_axi_awready,
   input  logic [`RV_DMA_BUS_TAG-1:0]   dma_axi_awid,
   input  logic [31:0]                  dma_axi_awaddr,
   input  logic [2:0]                   dma_axi_awsize,
   input  logic [2:0]                   dma_axi_awprot,
   input  logic [7:0]                   dma_axi_awlen,
   input  logic [1:0]                   dma_axi_awburst,


   input  logic                         dma_axi_wvalid,                                       
   output logic                         dma_axi_wready,
   input  logic [63:0]                  dma_axi_wdata,
   input  logic [7:0]                   dma_axi_wstrb,
   input  logic                         dma_axi_wlast,
                                        
   output logic                         dma_axi_bvalid,
   input  logic                         dma_axi_bready,
   output logic [1:0]                   dma_axi_bresp,
   output logic [`RV_DMA_BUS_TAG-1:0]   dma_axi_bid,

   // AXI Read Channels
   input  logic                         dma_axi_arvalid,
   output logic                         dma_axi_arready,
   input  logic [`RV_DMA_BUS_TAG-1:0]   dma_axi_arid,
   input  logic [31:0]                  dma_axi_araddr,                                     
   input  logic [2:0]                   dma_axi_arsize,
   input  logic [2:0]                   dma_axi_arprot,
   input  logic [7:0]                   dma_axi_arlen,
   input  logic [1:0]                   dma_axi_arburst,

   output logic                         dma_axi_rvalid,
   input  logic                         dma_axi_rready,
   output logic [`RV_DMA_BUS_TAG-1:0]   dma_axi_rid,
   output logic [63:0]                  dma_axi_rdata,
   output logic [1:0]                   dma_axi_rresp,
   output logic                         dma_axi_rlast,                 
                       
`endif

`ifdef RV_BUILD_AHB_LITE
 //// AHB LITE BUS
   output logic [31:0]               haddr,
   output logic [2:0]                hburst,
   output logic                      hmastlock,
   output logic [3:0]                hprot,
   output logic [2:0]                hsize,
   output logic [1:0]                htrans,
   output logic                      hwrite,

   input logic [63:0]                hrdata,
   input logic                       hready,
   input logic                       hresp,

   // LSU AHB Master
   output logic [31:0]               lsu_haddr,
   output logic [2:0]                lsu_hburst,
   output logic                      lsu_hmastlock,
   output logic [3:0]                lsu_hprot,
   output logic [2:0]                lsu_hsize,
   output logic [1:0]                lsu_htrans,
   output logic                      lsu_hwrite,
   output logic [63:0]               lsu_hwdata,

   input logic [63:0]                lsu_hrdata,
   input logic                       lsu_hready,
   input logic                       lsu_hresp,
   // Debug Syster Bus AHB
   output logic [31:0]               sb_haddr,
   output logic [2:0]                sb_hburst,
   output logic                      sb_hmastlock,
   output logic [3:0]                sb_hprot,
   output logic [2:0]                sb_hsize,
   output logic [1:0]                sb_htrans,
   output logic                      sb_hwrite,
   output logic [63:0]               sb_hwdata,
                                    
   input  logic [63:0]               sb_hrdata,
   input  logic                      sb_hready,
   input  logic                      sb_hresp,
   
   // DMA Slave
   input logic [31:0]                dma_haddr,
   input logic [2:0]                 dma_hburst,
   input logic                       dma_hmastlock,
   input logic [3:0]                 dma_hprot,
   input logic [2:0]                 dma_hsize,
   input logic [1:0]                 dma_htrans,
   input logic                       dma_hwrite,
   input logic [63:0]                dma_hwdata,
   input logic                       dma_hsel,
   input logic                       dma_hreadyin,                    
 
   output logic [63:0]               dma_hrdata,
   output logic                      dma_hreadyout,
   output logic                      dma_hresp,

`endif


   // clk ratio signals
   input logic                       lsu_bus_clk_en, // Clock ratio b/w cpu core clk & AHB master interface
   input logic                       ifu_bus_clk_en, // Clock ratio b/w cpu core clk & AHB master interface
   input logic                       dbg_bus_clk_en, // Clock ratio b/w cpu core clk & AHB master interface
   input logic                       dma_bus_clk_en, // Clock ratio b/w cpu core clk & AHB slave interface             

   
//   input logic                   ext_int,
   input logic                       timer_int,
   input logic [`RV_PIC_TOTAL_INT:1] extintsrc_req,

   output logic [1:0] dec_tlu_perfcnt0, // toggles when perf counter 0 has an event inc
   output logic [1:0] dec_tlu_perfcnt1,
   output logic [1:0] dec_tlu_perfcnt2,
   output logic [1:0] dec_tlu_perfcnt3,

   // ports added by the soc team              
   input logic                       jtag_tck, // JTAG clk
   input logic                       jtag_tms, // JTAG TMS  
   input logic                       jtag_tdi, // JTAG tdi
   input logic                       jtag_trst_n, // JTAG Reset
   output logic                      jtag_tdo, // JTAG TDO
   // external MPC halt/run interface
   input logic mpc_debug_halt_req, // Async halt request
   input logic mpc_debug_run_req, // Async run request
   input logic mpc_reset_run_req, // Run/halt after reset
   output logic mpc_debug_halt_ack, // Halt ack
   output logic mpc_debug_run_ack, // Run ack
   output logic debug_brkpt_status, // debug breakpoint

   input logic                       i_cpu_halt_req, // Async halt req to CPU
   output logic                      o_cpu_halt_ack, // core response to halt
   output logic                      o_cpu_halt_status, // 1'b1 indicates core is halted
   output logic                      o_debug_mode_status, // Core to the PMU that core is in debug mode. When core is in debug mode, the PMU should refrain from sendng a halt or run request
   input logic                       i_cpu_run_req, // Async restart req to CPU
   output logic                      o_cpu_run_ack, // Core response to run req
   input logic                       scan_mode, // To enable scan mode
   input logic                       mbist_mode // to enable mbist 
);

`include "global.h"   

   // DCCM ports
   logic         dccm_wren;
   logic         dccm_rden;
   logic [DCCM_BITS-1:0]  dccm_wr_addr;
   logic [DCCM_BITS-1:0]  dccm_rd_addr_lo;
   logic [DCCM_BITS-1:0]  dccm_rd_addr_hi;
   logic [DCCM_FDATA_WIDTH-1:0]  dccm_wr_data;
                      
   logic [DCCM_FDATA_WIDTH-1:0]  dccm_rd_data_lo;
   logic [DCCM_FDATA_WIDTH-1:0]  dccm_rd_data_hi;

   logic         lsu_freeze_dc3;

   // PIC ports

   // Icache & Itag ports
   logic [31:3]  ic_rw_addr;   
   logic [3:0]   ic_wr_en  ;     // Which way to write
   logic         ic_rd_en ;


   logic [3:0]   ic_tag_valid;   // Valid from the I$ tag valid outside (in flops). 

   logic [3:0]   ic_rd_hit;      // ic_rd_hit[3:0]
   logic         ic_tag_perr;    // Ic tag parity error

   logic [15:2]  ic_debug_addr;      // Read/Write addresss to the Icache.   
   logic         ic_debug_rd_en;     // Icache debug rd
   logic         ic_debug_wr_en;     // Icache debug wr
   logic         ic_debug_tag_array; // Debug tag array
   logic [3:0]   ic_debug_way;       // Debug way. Rd or Wr.

`ifdef RV_ICACHE_ECC
   logic [24:0]  ictag_debug_rd_data;// Debug icache tag. 
   logic [83:0]  ic_wr_data;         // ic_wr_data[135:0]
   logic [167:0] ic_rd_data;         // ic_rd_data[135:0]
   logic [41:0]  ic_debug_wr_data;   // Debug wr cache. 
`else
   logic [20:0]  ictag_debug_rd_data;// Debug icache tag. 
   logic [67:0]  ic_wr_data;         // ic_wr_data[135:0]
   logic [135:0] ic_rd_data;         // ic_rd_data[135:0]
   logic [33:0]  ic_debug_wr_data;   // Debug wr cache. 
`endif

   logic [127:0] ic_premux_data;
   logic         ic_sel_premux_data;

`ifdef RV_ICCM_ENABLE  
   // ICCM ports
   logic [`RV_ICCM_BITS-1:2]    iccm_rw_addr;   
   logic           iccm_wren;
   logic           iccm_rden;
   logic [2:0]     iccm_wr_size;
   logic [77:0]    iccm_wr_data;
   logic [155:0]   iccm_rd_data;
`endif

   logic        core_rst_l;     // Core reset including rst_l and dbg_rst_l  
   logic        jtag_tdoEn;
   
   logic        dccm_clk_override;
   logic        icm_clk_override;
   logic        dec_tlu_core_ecc_disable;
  
   logic        dmi_reg_en;
   logic [6:0]  dmi_reg_addr;
   logic        dmi_reg_wr_en;
   logic [31:0] dmi_reg_wdata;
   logic [31:0] dmi_reg_rdata;
   logic        dmi_hard_reset;

   //------------------------------------------------------------
   // OUTPUT SIGNALS TO BE IGNORED FROM SWERV2
   logic                 core_rst_l2;   // This is "rst_l | dbg_rst_l"  
   logic [63:0] trace_rv_i_insn_ip2;
   logic [63:0] trace_rv_i_address_ip2;
   logic [2:0]  trace_rv_i_valid_ip2;
   logic [2:0]  trace_rv_i_exception_ip2;
   logic [4:0]  trace_rv_i_ecause_ip2;
   logic [2:0]  trace_rv_i_interrupt_ip2;
   logic [31:0] trace_rv_i_tval_ip2;
                            
   logic                 lsu_freeze_dc32;
   logic                 dccm_clk_override2;
   logic                 icm_clk_override2;
   logic                 dec_tlu_core_ecc_disable2;
  
   // external halt/run interface

   logic o_cpu_halt_ack2;    // Core Acknowledge to Halt request
   logic o_cpu_halt_status2; // 1'b1 indicates processor is halted
   logic o_cpu_run_ack2;     // Core Acknowledge to run request
   logic o_debug_mode_status2; // Core to the PMU that core is in debug mode. When core is in debug mode2; the PMU should refrain from sendng a halt or run request
   // external MPC halt/run interface

   logic mpc_debug_halt_ack2; // Halt ack
   logic mpc_debug_run_ack2; // Run ack
   logic debug_brkpt_status2; // debug breakpoint
   
   logic [1:0] dec_tlu_perfcnt02; // toggles when perf counter 0 has an event inc
   logic [1:0] dec_tlu_perfcnt12;
   logic [1:0] dec_tlu_perfcnt22;
   logic [1:0] dec_tlu_perfcnt32;
                            
   // DCCM ports                
   logic                          dccm_wren2;
   logic                          dccm_rden2;
   logic [`RV_DCCM_BITS-1:0]          dccm_wr_addr2;
   logic [`RV_DCCM_BITS-1:0]          dccm_rd_addr_lo2;
   logic [`RV_DCCM_BITS-1:0]          dccm_rd_addr_hi2;
   logic [`RV_DCCM_FDATA_WIDTH-1:0]   dccm_wr_data2;
                                

`ifdef RV_ICCM_ENABLE
   // ICCM ports
   logic [`RV_ICCM_BITS-1:2]           iccm_rw_addr2;
   logic                  iccm_wren2;
   logic                  iccm_rden2;
   logic [2:0]            iccm_wr_size2;
   logic [77:0]           iccm_wr_data2;
                                 
`endif
   // ICache 2; ITAG  ports
   logic [31:3]           ic_rw_addr2;
   logic [3:0]            ic_tag_valid2;
   logic [3:0]            ic_wr_en2;
   logic                  ic_rd_en2;
`ifdef RV_ICACHE_ECC
   logic [83:0]               ic_wr_data2;         // Data to fill to the Icache. With ECC

   logic [41:0]               ic_debug_wr_data2;   // Debug wr cache. 
`else 
   logic [67:0]               ic_wr_data2;         // Data to fill to the Icache. With Parity
   logic [33:0]               ic_debug_wr_data2;   // Debug wr cache. 
`endif
   logic [127:0]              ic_premux_data2;     // Premux data to be muxed with each way of the Icache. 
   logic                      ic_sel_premux_data2; // Select premux data

   logic [15:2]               ic_debug_addr2;      // Read/Write addresss to the Icache.   
   logic                      ic_debug_rd_en2;     // Icache debug rd
   logic                      ic_debug_wr_en2;     // Icache debug wr
   logic                      ic_debug_tag_array2; // Debug tag array
   logic [3:0]                ic_debug_way2;       // Debug way. Rd or Wr.
`ifdef RV_BUILD_AXI4
   //-------------------------- LSU AXI signals--------------------------
   // AXI Write Channels
   logic                            lsu_axi_awvalid2;
   logic [`RV_LSU_BUS_TAG-1:0]      lsu_axi_awid2;
   logic [31:0]                     lsu_axi_awaddr2;
   logic [3:0]                      lsu_axi_awregion2;
   logic [7:0]                      lsu_axi_awlen2;
   logic [2:0]                      lsu_axi_awsize2;
   logic [1:0]                      lsu_axi_awburst2;
   logic                            lsu_axi_awlock2;
   logic [3:0]                      lsu_axi_awcache2;
   logic [2:0]                      lsu_axi_awprot2;
   logic [3:0]                      lsu_axi_awqos2;
   logic                            lsu_axi_wvalid2;                                       
   logic [63:0]                     lsu_axi_wdata2;
   logic [7:0]                      lsu_axi_wstrb2;
   logic                            lsu_axi_wlast2;
   logic                            lsu_axi_bready2;
   // AXI Read Channels                    
   logic                            lsu_axi_arvalid2;
   logic [`RV_LSU_BUS_TAG-1:0]      lsu_axi_arid2;
   logic [31:0]                     lsu_axi_araddr2;
   logic [3:0]                      lsu_axi_arregion2;
   logic [7:0]                      lsu_axi_arlen2;
   logic [2:0]                      lsu_axi_arsize2;
   logic [1:0]                      lsu_axi_arburst2;
   logic                            lsu_axi_arlock2;
   logic [3:0]                      lsu_axi_arcache2;
   logic [2:0]                      lsu_axi_arprot2;
   logic [3:0]                      lsu_axi_arqos2;
   logic                            lsu_axi_rready2;
   //-------------------------- IFU AXI signals--------------------------
   // AXI Write Channels
   logic                            ifu_axi_awvalid2;
   logic [`RV_IFU_BUS_TAG-1:0]      ifu_axi_awid2;
   logic [31:0]                     ifu_axi_awaddr2;
   logic [3:0]                      ifu_axi_awregion2;
   logic [7:0]                      ifu_axi_awlen2;
   logic [2:0]                      ifu_axi_awsize2;
   logic [1:0]                      ifu_axi_awburst2;
   logic                            ifu_axi_awlock2;
   logic [3:0]                      ifu_axi_awcache2;
   logic [2:0]                      ifu_axi_awprot2;
   logic [3:0]                      ifu_axi_awqos2;
   logic                            ifu_axi_wvalid2;                                       
   logic [63:0]                     ifu_axi_wdata2;
   logic [7:0]                      ifu_axi_wstrb2;
   logic                            ifu_axi_wlast2;
   logic                            ifu_axi_bready2;
   // AXI Read Channels                    
   logic                            ifu_axi_arvalid2;
   logic [`RV_IFU_BUS_TAG-1:0]      ifu_axi_arid2;
   logic [31:0]                     ifu_axi_araddr2;
   logic [3:0]                      ifu_axi_arregion2;
   logic [7:0]                      ifu_axi_arlen2;
   logic [2:0]                      ifu_axi_arsize2;
   logic [1:0]                      ifu_axi_arburst2;
   logic                            ifu_axi_arlock2;
   logic [3:0]                      ifu_axi_arcache2;
   logic [2:0]                      ifu_axi_arprot2;
   logic [3:0]                      ifu_axi_arqos2;
   logic                            ifu_axi_rready2;
   //-------------------------- SB AXI signals--------------------------
   // AXI Write Channels
   logic                            sb_axi_awvalid2;
   logic [`RV_SB_BUS_TAG-1:0]       sb_axi_awid2;
   logic [31:0]                     sb_axi_awaddr2;
   logic [3:0]                      sb_axi_awregion2;
   logic [7:0]                      sb_axi_awlen2;
   logic [2:0]                      sb_axi_awsize2;
   logic [1:0]                      sb_axi_awburst2;
   logic                            sb_axi_awlock2;
   logic [3:0]                      sb_axi_awcache2;
   logic [2:0]                      sb_axi_awprot2;
   logic [3:0]                      sb_axi_awqos2;
   logic                            sb_axi_wvalid2;                                       
   logic [63:0]                     sb_axi_wdata2;
   logic [7:0]                      sb_axi_wstrb2;
   logic                            sb_axi_wlast2;
   logic                            sb_axi_bready2;
   // AXI Read Channels                    
   logic                            sb_axi_arvalid2;
   logic [`RV_SB_BUS_TAG-1:0]       sb_axi_arid2;
   logic [31:0]                     sb_axi_araddr2;
   logic [3:0]                      sb_axi_arregion2;
   logic [7:0]                      sb_axi_arlen2;
   logic [2:0]                      sb_axi_arsize2;
   logic [1:0]                      sb_axi_arburst2;
   logic                            sb_axi_arlock2;
   logic [3:0]                      sb_axi_arcache2;
   logic [2:0]                      sb_axi_arprot2;
   logic [3:0]                      sb_axi_arqos2;
   logic                            sb_axi_rready2;
   //-------------------------- DMA AXI signals--------------------------
   // AXI Write Channels
   logic                         dma_axi_awready2;
   logic                         dma_axi_wready2;
   logic                         dma_axi_bvalid2;
   logic [1:0]                   dma_axi_bresp2;
   logic [`RV_DMA_BUS_TAG-1:0]   dma_axi_bid2;
   // AXI Read Channels
   logic                         dma_axi_arready2;
   logic                         dma_axi_rvalid2;
   logic [`RV_DMA_BUS_TAG-1:0]   dma_axi_rid2;
   logic [63:0]                  dma_axi_rdata2;
   logic [1:0]                   dma_axi_rresp2;
   logic                         dma_axi_rlast2;
`endif
`ifdef RV_BUILD_AHB_LITE
 //// AHB LITE BUS
   logic [31:0]           haddr2;
   logic [2:0]            hburst2;
   logic                  hmastlock2;
   logic [3:0]            hprot2;
   logic [2:0]            hsize2;
   logic [1:0]            htrans2;
   logic                  hwrite2;
   // LSU AHB Master
   logic [31:0]          lsu_haddr2;
   logic [2:0]           lsu_hburst2;
   logic                 lsu_hmastlock2;
   logic [3:0]           lsu_hprot2;
   logic [2:0]           lsu_hsize2;
   logic [1:0]           lsu_htrans2;
   logic                 lsu_hwrite2;
   logic [63:0]          lsu_hwdata2;
   //System Bus Debug Master                        
   logic [31:0]          sb_haddr2;
   logic [2:0]           sb_hburst2;
   logic                 sb_hmastlock2;
   logic [3:0]           sb_hprot2;
   logic [2:0]           sb_hsize2;
   logic [1:0]           sb_htrans2;
   logic                 sb_hwrite2;
   logic [63:0]          sb_hwdata2;
   // DMA Slave   
    logic [63:0]          dma_hrdata2;
    logic                 dma_hreadyout2;
    logic                 dma_hresp2;
`endif //  `ifdef RV_BUILD_AHB_LITE

   //Debug module
   logic [31:0]           dmi_reg_rdata2;
   //------------------------------------------------------------


   // Instantiate the swerv core
   swerv swerv (
          .*
          );
   swerv swerv2 (
.core_rst_l(core_rst_l2),   // This is "rst_l | dbg_rst_l"  
.trace_rv_i_insn_ip(trace_rv_i_insn_ip2),
.trace_rv_i_address_ip(trace_rv_i_address_ip2),
.trace_rv_i_valid_ip(trace_rv_i_valid_ip2),
.trace_rv_i_exception_ip(trace_rv_i_exception_ip2),
.trace_rv_i_ecause_ip(trace_rv_i_ecause_ip2),
.trace_rv_i_interrupt_ip(trace_rv_i_interrupt_ip2),
.trace_rv_i_tval_ip(trace_rv_i_tval_ip2),                            
.lsu_freeze_dc3(lsu_freeze_dc32),
.dccm_clk_override(dccm_clk_override2),
.icm_clk_override(icm_clk_override2),
.dec_tlu_core_ecc_disable(dec_tlu_core_ecc_disable2),
   // external halt/run interface
.o_cpu_halt_ack(o_cpu_halt_ack2),    // Core Acknowledge to Halt request
.o_cpu_halt_status(o_cpu_halt_status2), // 1'b1 indicates processor is halted
.o_cpu_run_ack(o_cpu_run_ack2),     // Core Acknowledge to run request
.o_debug_mode_status(o_debug_mode_status2), // Core to the PMU that core is in debug mode. When core is in debug mode2), the PMU should refrain from sendng a halt or run request
   // external MPC halt/run interface
.mpc_debug_halt_ack(mpc_debug_halt_ack2), // Halt ack
.mpc_debug_run_ack(mpc_debug_run_ack2), // Run ack
.debug_brkpt_status(debug_brkpt_status2), // debug breakpoint
.dec_tlu_perfcnt0(dec_tlu_perfcnt02), // toggles when perf counter 0 has an event inc
.dec_tlu_perfcnt1(dec_tlu_perfcnt12),
.dec_tlu_perfcnt2(dec_tlu_perfcnt22),
.dec_tlu_perfcnt3(dec_tlu_perfcnt32),
   // DCCM ports                
.dccm_wren(dccm_wren2),
.dccm_rden(dccm_rden2),
.dccm_wr_addr(dccm_wr_addr2),
.dccm_rd_addr_lo(dccm_rd_addr_lo2),
.dccm_rd_addr_hi(dccm_rd_addr_hi2),
.dccm_wr_data(dccm_wr_data2),
`ifdef RV_ICCM_ENABLE
   // ICCM ports
.iccm_rw_addr(iccm_rw_addr2),
.iccm_wren(iccm_wren2),
.iccm_rden(iccm_rden2),
.iccm_wr_size(iccm_wr_size2),
.iccm_wr_data(iccm_wr_data2),
`endif
   // ICache 2), ITAG  ports
.ic_rw_addr(ic_rw_addr2),
.ic_tag_valid(ic_tag_valid2),
.ic_wr_en(ic_wr_en2),
.ic_rd_en(ic_rd_en2),
`ifdef RV_ICACHE_ECC
.ic_wr_data(ic_wr_data2),         // Data to fill to the Icache. With ECC
.ic_debug_wr_data(ic_debug_wr_data2),   // Debug wr cache. 
`else 
.ic_wr_data(ic_wr_data2),         // Data to fill to the Icache. With Parity
.ic_debug_wr_data(ic_debug_wr_data2),   // Debug wr cache. 
`endif
.ic_premux_data(ic_premux_data2),     // Premux data to be muxed with each way of the Icache. 
.ic_sel_premux_data(ic_sel_premux_data2), // Select premux data
.ic_debug_addr(ic_debug_addr2),      // Read/Write addresss to the Icache.   
.ic_debug_rd_en(ic_debug_rd_en2),     // Icache debug rd
.ic_debug_wr_en(ic_debug_wr_en2),     // Icache debug wr
.ic_debug_tag_array(ic_debug_tag_array2), // Debug tag array
.ic_debug_way(ic_debug_way2),       // Debug way. Rd or Wr.
`ifdef RV_BUILD_AXI4
   //-------------------------- LSU AXI signals--------------------------
   // AXI Write Channels
.lsu_axi_awvalid(lsu_axi_awvalid2),
.lsu_axi_awid(lsu_axi_awid2),
.lsu_axi_awaddr(lsu_axi_awaddr2),
.lsu_axi_awregion(lsu_axi_awregion2),
.lsu_axi_awlen(lsu_axi_awlen2),
.lsu_axi_awsize(lsu_axi_awsize2),
.lsu_axi_awburst(lsu_axi_awburst2),
.lsu_axi_awlock(lsu_axi_awlock2),
.lsu_axi_awcache(lsu_axi_awcache2),
.lsu_axi_awprot(lsu_axi_awprot2),
.lsu_axi_awqos(lsu_axi_awqos2),
.lsu_axi_wvalid(lsu_axi_wvalid2),                                       
.lsu_axi_wdata(lsu_axi_wdata2),
.lsu_axi_wstrb(lsu_axi_wstrb2),
.lsu_axi_wlast(lsu_axi_wlast2),
.lsu_axi_bready(lsu_axi_bready2),
   // AXI Read Channels                    
.lsu_axi_arvalid(lsu_axi_arvalid2),
.lsu_axi_arid(lsu_axi_arid2),
.lsu_axi_araddr(lsu_axi_araddr2),
.lsu_axi_arregion(lsu_axi_arregion2),
.lsu_axi_arlen(lsu_axi_arlen2),
.lsu_axi_arsize(lsu_axi_arsize2),
.lsu_axi_arburst(lsu_axi_arburst2),
.lsu_axi_arlock(lsu_axi_arlock2),
.lsu_axi_arcache(lsu_axi_arcache2),
.lsu_axi_arprot(lsu_axi_arprot2),
.lsu_axi_arqos(lsu_axi_arqos2),
.lsu_axi_rready(lsu_axi_rready2),
   //-------------------------- IFU AXI signals--------------------------
   // AXI Write Channels
.ifu_axi_awvalid(ifu_axi_awvalid2),
.ifu_axi_awid(ifu_axi_awid2),
.ifu_axi_awaddr(ifu_axi_awaddr2),
.ifu_axi_awregion(ifu_axi_awregion2),
.ifu_axi_awlen(ifu_axi_awlen2),
.ifu_axi_awsize(ifu_axi_awsize2),
.ifu_axi_awburst(ifu_axi_awburst2),
.ifu_axi_awlock(ifu_axi_awlock2),
.ifu_axi_awcache(ifu_axi_awcache2),
.ifu_axi_awprot(ifu_axi_awprot2),
.ifu_axi_awqos(ifu_axi_awqos2),
.ifu_axi_wvalid(ifu_axi_wvalid2),                                       
.ifu_axi_wdata(ifu_axi_wdata2),
.ifu_axi_wstrb(ifu_axi_wstrb2),
.ifu_axi_wlast(ifu_axi_wlast2),
.ifu_axi_bready(ifu_axi_bready2),
   // AXI Read Channels                    
.ifu_axi_arvalid(ifu_axi_arvalid2),
.ifu_axi_arid(ifu_axi_arid2),
.ifu_axi_araddr(ifu_axi_araddr2),
.ifu_axi_arregion(ifu_axi_arregion2),
.ifu_axi_arlen(ifu_axi_arlen2),
.ifu_axi_arsize(ifu_axi_arsize2),
.ifu_axi_arburst(ifu_axi_arburst2),
.ifu_axi_arlock(ifu_axi_arlock2),
.ifu_axi_arcache(ifu_axi_arcache2),
.ifu_axi_arprot(ifu_axi_arprot2),
.ifu_axi_arqos(ifu_axi_arqos2),
.ifu_axi_rready(ifu_axi_rready2),
   //-------------------------- SB AXI signals--------------------------
   // AXI Write Channels
.sb_axi_awvalid(sb_axi_awvalid2),
.sb_axi_awid(sb_axi_awid2),
.sb_axi_awaddr(sb_axi_awaddr2),
.sb_axi_awregion(sb_axi_awregion2),
.sb_axi_awlen(sb_axi_awlen2),
.sb_axi_awsize(sb_axi_awsize2),
.sb_axi_awburst(sb_axi_awburst2),
.sb_axi_awlock(sb_axi_awlock2),
.sb_axi_awcache(sb_axi_awcache2),
.sb_axi_awprot(sb_axi_awprot2),
.sb_axi_awqos(sb_axi_awqos2),
.sb_axi_wvalid(sb_axi_wvalid2),                                       
.sb_axi_wdata(sb_axi_wdata2),
.sb_axi_wstrb(sb_axi_wstrb2),
.sb_axi_wlast(sb_axi_wlast2),
.sb_axi_bready(sb_axi_bready2),
   // AXI Read Channels                    
.sb_axi_arvalid(sb_axi_arvalid2),
.sb_axi_arid(sb_axi_arid2),
.sb_axi_araddr(sb_axi_araddr2),
.sb_axi_arregion(sb_axi_arregion2),
.sb_axi_arlen(sb_axi_arlen2),
.sb_axi_arsize(sb_axi_arsize2),
.sb_axi_arburst(sb_axi_arburst2),
.sb_axi_arlock(sb_axi_arlock2),
.sb_axi_arcache(sb_axi_arcache2),
.sb_axi_arprot(sb_axi_arprot2),
.sb_axi_arqos(sb_axi_arqos2),
.sb_axi_rready(sb_axi_rready2),
   //-------------------------- DMA AXI signals--------------------------
   // AXI Write Channels
.dma_axi_awready(dma_axi_awready2),
.dma_axi_wready(dma_axi_wready2),
.dma_axi_bvalid(dma_axi_bvalid2),
.dma_axi_bresp(dma_axi_bresp2),
.dma_axi_bid(dma_axi_bid2),
   // AXI Read Channels
.dma_axi_arready(dma_axi_arready2),
.dma_axi_rvalid(dma_axi_rvalid2),
.dma_axi_rid(dma_axi_rid2),
.dma_axi_rdata(dma_axi_rdata2),
.dma_axi_rresp(dma_axi_rresp2),
.dma_axi_rlast(dma_axi_rlast2),
`endif
`ifdef RV_BUILD_AHB_LITE
 //// AHB LITE BUS
.haddr(haddr2),
.hburst(hburst2),
.hmastlock(hmastlock2),
.hprot(hprot2),
.hsize(hsize2),
.htrans(htrans2),
.hwrite(hwrite2),
   // LSU AHB Master
.lsu_haddr(lsu_haddr2),
.lsu_hburst(lsu_hburst2),
.lsu_hmastlock(lsu_hmastlock2),
.lsu_hprot(lsu_hprot2),
.lsu_hsize(lsu_hsize2),
.lsu_htrans(lsu_htrans2),
.lsu_hwrite(lsu_hwrite2),
.lsu_hwdata(lsu_hwdata2),
   //System Bus Debug Master                        
.sb_haddr(sb_haddr2),
.sb_hburst(sb_hburst2),
.sb_hmastlock(sb_hmastlock2),
.sb_hprot(sb_hprot2),
.sb_hsize(sb_hsize2),
.sb_htrans(sb_htrans2),
.sb_hwrite(sb_hwrite2),
.sb_hwdata(sb_hwdata2),
   // DMA Slave   
.dma_hrdata(dma_hrdata2),
.dma_hreadyout(dma_hreadyout2),
.dma_hresp(dma_hresp2),
`endif //  `ifdef RV_BUILD_AHB_LITE
   //Debug module
.dmi_reg_rdata(dmi_reg_rdata2),
          .*
          );
   
   // Instantiate the mem
   mem  mem (
        .rst_l(core_rst_l),
        .*
        );
   
  // Instantiate the JTAG/DMI
   dmi_wrapper  dmi_wrapper (
           .scan_mode(scan_mode),           // scan mode

           // JTAG signals
           .trst_n(jtag_trst_n),           // JTAG reset
           .tck   (jtag_tck),              // JTAG clock
           .tms   (jtag_tms),              // Test mode select
           .tdi   (jtag_tdi),              // Test Data Input
           .tdo   (jtag_tdo),              // Test Data Output
           .tdoEnable (),                  // Test Data Output enable

           // Processor Signals
           .core_rst_n  (core_rst_l),     // Core reset, active low
           .core_clk    (clk),            // Core clock
           .jtag_id     (jtag_id),        // 32 bit JTAG ID
           .rd_data     (dmi_reg_rdata),  // 32 bit Read data from  Processor
           .reg_wr_data (dmi_reg_wdata),  // 32 bit Write data to Processor
           .reg_wr_addr (dmi_reg_addr),   // 32 bit Write address to Processor
           .reg_en      (dmi_reg_en),     // 1 bit  Write interface bit to Processor
           .reg_wr_en   (dmi_reg_wr_en),   // 1 bit  Write enable to Processor
           .dmi_hard_reset   (dmi_hard_reset)   //a hard reset of the DTM, causing the DTM to forget about any outstanding DMI transactions
);

endmodule
   
