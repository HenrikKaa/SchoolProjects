//
// Copyright 2003-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//

#include "dct_ref.h"

#pragma design top
void dct_ref(ac_int<9> input[XYSIZE][XYSIZE], ac_int<11> output[XYSIZE][XYSIZE])
{
  const ac_int<10> coeff[XYSIZE][XYSIZE] = {
    {362,  362,  362,  362,  362,  362,  362,  362},
    {502,  425,  284,   99,  -99, -284, -425, -502},
    {473,  195, -195, -473, -473, -195,  195,  473},
    {425,  -99, -502, -284,  284,  502,   99, -425},
    {362, -362, -362,  362,  362, -362, -362,  362},
    {284, -502,   99,  425, -425,  -99,  502, -284},
    {195, -473,  473, -195, -195,  473, -473,  195},
    { 99, -284,  425, -502,  502, -425,  284,  -99}
  };

  ac_int<21> temp[XYSIZE][XYSIZE];
  ac_int<21> tmp;
  ac_int<31> dct_value;

  COL1:for (int i=0; i < XYSIZE; ++i ) {
    ROW1:for (int j=0; j < XYSIZE; ++j ) {
      tmp = 0;
      inner1:for (int k=0; k < XYSIZE; ++k )  {
        tmp += input[i][k] * coeff[j][k];
      }
      temp[j][i] = tmp;
    }
  }

  ROW2:for (int ii=0 ; ii < XYSIZE; ++ii ) {
    COL2:for (int j=0; j < XYSIZE; ++j ) {
      dct_value = 0;
      inner2:for (int k=0 ; k < XYSIZE ; ++k ) {
        dct_value += coeff[ii][k] * temp[j][k];
      }
      output[ii][j] = dct_value >> 20;
    }
  }
}
