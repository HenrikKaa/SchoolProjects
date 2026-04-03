##
## Copyright 2003-2015 Mentor Graphics Corporation
##
## All Rights Reserved.
##
## THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
## MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
## 

# Establish the location of this script and use it to reference all
# other files in this example
set sfd [file dirname [info script]]

# Reset the options to the factory defaults
solution new -state initial
solution options defaults

flow package require /SCVerify
solution options set /Flows/SCVerify/USE_NCSIM true
solution options set /Flows/SCVerify/USE_VCS true

solution file add [file join $sfd mult_add.cpp] -type C++
solution file add [file join $sfd tb_mult_add.cpp] -type C++ -exclude true
directive set -TRANSACTION_DONE_SIGNAL true
go analyze

solution library add nangate-45nm_beh -- -rtlsyntool OasysRTL -vendor Nangate -technology 045nm
directive set -DESIGN_HIERARCHY mult_add
go compile
go libraries

directive set -CLOCKS {clk {-CLOCK_PERIOD 10.0}}
go extract

flow run /SCVerify/launch_make ./scverify/Verify_rtl_v_msim.mk {} SIMTOOL=msim sim
