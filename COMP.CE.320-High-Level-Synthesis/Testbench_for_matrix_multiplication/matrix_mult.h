/*
Multiplies two NxN matrices A and B of type int and puts the product in matrix C.
Allows transposition of A and/or B before multiplication.

transpose = 0: Use A and B as is
transpose = 1: Transpose A before multiplication
transpose = 2: Transpose B before multiplication
transpose = 3: Transpose A and B before multiplication
*/

#ifndef _matrix_mult
#define _BITS_FLOATN_H 0
#define _matrix_mult
#include<ac_int.h>

// Matrix size NxN
const int N = 8;

typedef int data_t;
typedef int result_t;
//typedef int hls_data_t; 
//typedef int hls_result_t;


/* Range is the maximum value in the matrices.
 WIDTH is the number of bits required for max value plus a sign bit.
 RESULT_WIDTH comprimises of: 2*RANGE bits because two M bit values
   multiplied together need 2M bits (excluding sign bit).
 1 extra bit for signed
 extra N bit because every addition can add maximum of 1 bit to the sum.
 */
const int MIN_VALUE = -32;
const int MAX_VALUE = 31;
const int WIDTH = ac::nbits<MAX_VALUE>::val + 1;
const int RESULT_WIDTH = 2*ac::nbits<MAX_VALUE>::val + 1 + N;
typedef ac_int<WIDTH, true> hls_data_t; 
typedef ac_int<RESULT_WIDTH, true> hls_result_t;

// Golden reference implementation
void matrixMult(data_t A[N][N], data_t B[N][N], result_t C[N][N], int transpose);

// HLS implementation
void matrixMultHLS(hls_data_t A[N][N], hls_data_t B[N][N], hls_result_t C[N][N], int transpose);

#endif
