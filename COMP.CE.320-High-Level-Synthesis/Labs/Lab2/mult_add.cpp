//
// Copyright 2003-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
// 

#include "mult_add.h"

#pragma design top
ac_int<31> mult_add(ac_int<21> data[XYSIZE], const ac_int<10> coeff[XYSIZE]){
  ac_int<31> acc = 0; 
 
  MAC:for (int k=0 ; k < XYSIZE ; ++k ){
    acc += coeff[k] * data[k];	
  }
  return acc;
}
