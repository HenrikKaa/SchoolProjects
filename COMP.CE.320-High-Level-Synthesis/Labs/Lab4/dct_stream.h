//
// Copyright 2003-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//

#ifndef __DCT_STREAM__
#define __DCT_STREAM__

// Define macro to include support for fixed-point SystemC
#define SC_INCLUDE_FX

// Include AC Datatypes
#include <ac_int.h>
#include <ac_channel.h>

#include "defs.h"

void dct(ac_channel<ac_int<9> > &input, ac_int<11> output[][XYSIZE]);

#endif

