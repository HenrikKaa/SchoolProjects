//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
//Date        : Fri Jan 28 14:24:06 2022
//Host        : HTC219-710-SPC running 64-bit major release  (build 9200)
//Command     : generate_target Hello_LED.bd
//Design      : Hello_LED
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "Hello_LED,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=Hello_LED,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "Hello_LED.hwdef" *) 
module Hello_LED
   (clk,
    input_rsc_dat,
    return_rsc_dat,
    rst);
  input clk;
  input input_rsc_dat;
  output return_rsc_dat;
  input rst;

  wire clk_1;
  wire input_rsc_dat_1;
  wire led_0_return_rsc_dat;
  wire rst_1;

  assign clk_1 = clk;
  assign input_rsc_dat_1 = input_rsc_dat;
  assign return_rsc_dat = led_0_return_rsc_dat;
  assign rst_1 = rst;
  Hello_LED_led_0_0 led_0
       (.clk(clk_1),
        .input_rsc_dat(input_rsc_dat_1),
        .return_rsc_dat(led_0_return_rsc_dat),
        .rst(rst_1));
endmodule
