// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Fri Jan 28 14:25:02 2022
// Host        : HTC219-710-SPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               p:/HLS/Hello_LED/Vivado/Hello_LED/Hello_LED.srcs/sources_1/bd/Hello_LED/ip/Hello_LED_led_0_0/Hello_LED_led_0_0_sim_netlist.v
// Design      : Hello_LED_led_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Hello_LED_led_0_0,led,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "led,Vivado 2017.2" *) 
(* NotValidForBitStream *)
module Hello_LED_led_0_0
   (clk,
    rst,
    input_rsc_dat,
    input_rsc_triosy_lz,
    return_rsc_dat,
    return_rsc_triosy_lz);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk CLK" *) input clk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 rst RST" *) input rst;
  input input_rsc_dat;
  output input_rsc_triosy_lz;
  output return_rsc_dat;
  output return_rsc_triosy_lz;

  wire clk;
  wire input_rsc_dat;
  wire return_rsc_dat;
  wire return_rsc_triosy_lz;
  wire rst;

  assign input_rsc_triosy_lz = return_rsc_triosy_lz;
  Hello_LED_led_0_0_led U0
       (.clk(clk),
        .input_rsc_dat(input_rsc_dat),
        .return_rsc_dat(return_rsc_dat),
        .return_rsc_triosy_lz(return_rsc_triosy_lz),
        .rst(rst));
endmodule

(* ORIG_REF_NAME = "led" *) 
module Hello_LED_led_0_0_led
   (return_rsc_triosy_lz,
    return_rsc_dat,
    input_rsc_dat,
    rst,
    clk);
  output return_rsc_triosy_lz;
  output return_rsc_dat;
  input input_rsc_dat;
  input rst;
  input clk;

  wire clk;
  wire input_rsc_dat;
  wire return_rsc_dat;
  wire return_rsc_triosy_lz;
  wire rst;

  Hello_LED_led_0_0_led_core led_core_inst
       (.clk(clk),
        .input_rsc_dat(input_rsc_dat),
        .return_rsc_dat(return_rsc_dat),
        .return_rsc_triosy_lz(return_rsc_triosy_lz),
        .rst(rst));
endmodule

(* ORIG_REF_NAME = "led_core" *) 
module Hello_LED_led_0_0_led_core
   (return_rsc_triosy_lz,
    return_rsc_dat,
    input_rsc_dat,
    rst,
    clk);
  output return_rsc_triosy_lz;
  output return_rsc_dat;
  input input_rsc_dat;
  input rst;
  input clk;

  wire clk;
  wire input_rsc_dat;
  wire reg_return_rsc_triosy_obj_ld_cse_i_1_n_0;
  wire return_rsc_dat;
  wire return_rsc_triosy_lz;
  wire return_rsci_idat_i_1_n_0;
  wire rst;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT1 #(
    .INIT(2'h1)) 
    reg_return_rsc_triosy_obj_ld_cse_i_1
       (.I0(rst),
        .O(reg_return_rsc_triosy_obj_ld_cse_i_1_n_0));
  FDRE reg_return_rsc_triosy_obj_ld_cse_reg
       (.C(clk),
        .CE(1'b1),
        .D(reg_return_rsc_triosy_obj_ld_cse_i_1_n_0),
        .Q(return_rsc_triosy_lz),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h2)) 
    return_rsci_idat_i_1
       (.I0(input_rsc_dat),
        .I1(rst),
        .O(return_rsci_idat_i_1_n_0));
  FDRE return_rsci_idat_reg
       (.C(clk),
        .CE(1'b1),
        .D(return_rsci_idat_i_1_n_0),
        .Q(return_rsc_dat),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
