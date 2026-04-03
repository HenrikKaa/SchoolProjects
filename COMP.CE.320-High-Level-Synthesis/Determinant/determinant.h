// Kaakkolammi Henrik H275961

#ifndef _determinant
#define _determinant

#define _BITS_FLOATN_H 0

#include <ac_int.h>
#include "matrix.h"

const int N = 2; // Matrix size (NxN)
const int W = 17; // Width. This may have to be increased with some test cases.
const int S = 1;  // Signedness (signed)

#pragma hls_design top
void determinant(ac_int<W,S> input[N][N], ac_int<W,S> &result);

#endif
