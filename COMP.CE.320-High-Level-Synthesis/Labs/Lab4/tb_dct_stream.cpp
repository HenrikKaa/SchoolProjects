//
// Copyright 2003-2015 Mentor Graphics Corporation
//
// All Rights Reserved.
//
// THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF
// MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
//

#include "dct_stream.h"
#include "dct_ref.h"

#include <mc_scverify.h>

CCS_MAIN(int argc, char *argv[])
{
  ac_channel<ac_int<9> > input;
  ac_int<9> input_ref[XYSIZE][XYSIZE];
  ac_int<11> output[XYSIZE][XYSIZE];
  ac_int<11> output_ref[XYSIZE][XYSIZE];
  int errCnt = 0;

  for (int p = 0; p<4; p++) {
    printf("Input\n");
    for ( int i = 0; i < XYSIZE; i++ ) {
      for ( int j = 0; j < XYSIZE; j++ ) {
        if (i<3 && j<3) {
          input_ref[i][j] = 128;
        }     else {
          input_ref[i][j] = 0;
        }
        printf("%3d ", (int)input_ref[i][j]);
        input.write(input_ref[i][j]);
      }
      printf("\n");
    }


    // Main function call
    CCS_DESIGN(dct)(input,output);
    dct_ref(input_ref,output_ref);

    printf("\nOutput\n\n");
    for ( int i = 0; i < XYSIZE; i++ ) {
      for ( int j = 0; j < XYSIZE; j++ ) {
        if (output[i][j] != output_ref[i][j]) {
          printf("output[%d][%d] = %d\n", i, j, (int)output[i][j]);
          errCnt++;
        }
        printf("%3d ", (int)output[i][j]);
      }
      printf("\n");
    }
    printf("\nThere were %d errors\n",errCnt);
  }
  CCS_RETURN(0);
}

