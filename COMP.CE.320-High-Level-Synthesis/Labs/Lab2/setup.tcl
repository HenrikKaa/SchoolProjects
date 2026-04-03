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
solution options set /Architectural/DefaultRegisterThreshold 4255

solution file add [file join $sfd mult_add.cpp] -type C++
solution file add [file join $sfd tb_mult_add.cpp] -type C++ -exclude true

directive set -TRANSACTION_DONE_SIGNAL false

