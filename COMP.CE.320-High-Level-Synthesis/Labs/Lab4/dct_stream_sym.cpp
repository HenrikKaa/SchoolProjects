//
// Copyright 2003-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//

#include "dct_stream.h"

ac_int<31> mult_add(ac_int<21> data[XYSIZE], int i)
{
  ac_int<31> acc = 0;
  ac_int<22> pa[XYSIZE/2];
  const ac_int<10> coeff[XYSIZE][XYSIZE/2] = {
    {362,  362,  362,  362},
    {502,  425,  284,   99},
    {473,  195, -195, -473},
    {425,  -99, -502, -284},
    {362, -362, -362,  362},
    {284, -502,   99,  425},
    {195, -473,  473, -195},
    { 99, -284,  425, -502}
  };

  PRE_ADD:for (int k=0 ; k < XYSIZE/2 ; ++k ) {
    pa[k] = data[k] + ((i&1)? -data[XYSIZE-1-k]:(ac_int<22>)data[XYSIZE-1-k]);
  }

  MAC:for (int k=0 ; k < XYSIZE/2 ; ++k ) {
    acc += coeff[i][k] * pa[k];
  }
  return acc;
}

#pragma design top
void dct(ac_channel<ac_int<9> > &input, ac_int<11> output[XYSIZE][XYSIZE])
{

  ac_int<21> temp[XYSIZE][XYSIZE];
  ac_int<21> tmp;
  ac_int<31> dct_value;
  ac_int<9> data0[XYSIZE];
  ac_int<21> data1[XYSIZE];

  vert: for (int i=0; i < XYSIZE; ++i ) {
    copy_input: for (int p = 0; p<XYSIZE; p++) {
      data1[p] = input.read();
    }
    vert_mac: for (int j=0; j < XYSIZE; ++j ) {
      tmp = mult_add(data1,j);
      temp[j][i] = tmp;
    }
  }
  hor: for (int j=0; j < XYSIZE; ++j ) {
    copy_mem: for (int p = 0; p<XYSIZE; p++) {
      data1[p] = temp[j][p];
    }
    hor_mac: for (int i=0 ; i < XYSIZE; ++i ) {
      dct_value = mult_add(data1,i);
      output[i][j] = dct_value >> 20;
    }
  }
}

