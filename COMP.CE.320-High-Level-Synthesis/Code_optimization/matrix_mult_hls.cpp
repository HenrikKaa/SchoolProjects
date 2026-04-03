#include "matrix_mult.h"
#include <ac_assert.h>

void matrixMultHLS(hls_data_t A[N][N], hls_data_t B[N][N], hls_result_t C[N][N], ac_int<2, false> transpose)
{
    // Check that transpose has legal value
    assert(transpose >= 0 && transpose < 4);

    LOOP_i: for (int i = 0; i < N; i++)
    {
        LOOP_j: for (int j = 0; j < N; j++)
        {
            hls_result_t C_temp = 0;
            LOOP_k: for (int k = 0; k < N; k++)
            {
                if (transpose == 3) { C_temp += A[k][i] * B[j][k]; }
                if (transpose == 2) { C_temp += A[i][k] * B[j][k]; }
                if (transpose == 1) { C_temp += A[k][i] * B[k][j]; }
                if (transpose == 0) { C_temp += A[i][k] * B[k][j]; }
            }
            C[i][j] = C_temp;
        }
    }
}
