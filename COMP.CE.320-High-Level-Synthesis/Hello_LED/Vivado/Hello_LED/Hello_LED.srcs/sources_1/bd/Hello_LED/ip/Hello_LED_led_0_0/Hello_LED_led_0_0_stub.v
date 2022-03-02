// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Fri Jan 28 14:25:02 2022
// Host        : HTC219-710-SPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               p:/HLS/Hello_LED/Vivado/Hello_LED/Hello_LED.srcs/sources_1/bd/Hello_LED/ip/Hello_LED_led_0_0/Hello_LED_led_0_0_stub.v
// Design      : Hello_LED_led_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "led,Vivado 2017.2" *)
module Hello_LED_led_0_0(clk, rst, input_rsc_dat, input_rsc_triosy_lz, 
  return_rsc_dat, return_rsc_triosy_lz)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,input_rsc_dat,input_rsc_triosy_lz,return_rsc_dat,return_rsc_triosy_lz" */;
  input clk;
  input rst;
  input input_rsc_dat;
  output input_rsc_triosy_lz;
  output return_rsc_dat;
  output return_rsc_triosy_lz;
endmodule
