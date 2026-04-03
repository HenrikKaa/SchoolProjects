//
// Copyright 2003-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//

#include <cstdio>

// Include for function prototype
#include "mult_add.h"

// Uncomment to turn on interface stalling
//#define ADD_STALL

// SCVerify verification MACROs
#include <mc_scverify.h>

CCS_MAIN(int argv, char *argc)
{
  ac_int<31> result;
  ac_int<21> data[XYSIZE];
  ac_int<10> coeff[XYSIZE];

  for (int i=0; i<XYSIZE; i++) {
    data[i] = 0;
    coeff[i] = 10;
  }

  for (int j=0; j<4; j++) {
    for (int i=0; i<XYSIZE; i++) {
      data[i] = i+j+1;
#ifdef ADD_STALL
#ifdef CCS_SCVERIFY // If verifcation flow is running
      if (i&1) { // stall every other time
        testbench::data_wait_ctrl.cycles = 3; // Stall data for three cycles when enabled
      }
#endif
#endif
      result = CCS_DESIGN(mult_add)(data,coeff);
      printf("Result = %d\n",result.to_int()); // use to_int() to convert ac_int for printing
    }
  }
  CCS_RETURN(0);
}

