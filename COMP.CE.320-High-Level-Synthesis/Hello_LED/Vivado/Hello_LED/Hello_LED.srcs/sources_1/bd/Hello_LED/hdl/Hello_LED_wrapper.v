//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
//Date        : Fri Jan 28 14:24:06 2022
//Host        : HTC219-710-SPC running 64-bit major release  (build 9200)
//Command     : generate_target Hello_LED_wrapper.bd
//Design      : Hello_LED_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Hello_LED_wrapper
   (clk,
    input_rsc_dat,
    return_rsc_dat,
    rst);
  input clk;
  input input_rsc_dat;
  output return_rsc_dat;
  input rst;

  wire clk;
  wire input_rsc_dat;
  wire return_rsc_dat;
  wire rst;

  Hello_LED Hello_LED_i
       (.clk(clk),
        .input_rsc_dat(input_rsc_dat),
        .return_rsc_dat(return_rsc_dat),
        .rst(rst));
endmodule
