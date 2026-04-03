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

solution file add [file join $sfd dct_stream.cpp] -type C++
solution file add [file join $sfd dct_ref.cpp] -type C++ -exclude true
solution file add [file join $sfd tb_dct_stream.cpp] -type C++ -exclude true

directive set -TRANSACTION_DONE_SIGNAL true
#disable constant multiplier optimization for better area and runtime in this lab
directive set -OPT_CONST_MULTS simple_one_adder
go analyze
solution library add nangate-45nm_beh -- -rtlsyntool OasysRTL -vendor Nangate -technology 045nm

