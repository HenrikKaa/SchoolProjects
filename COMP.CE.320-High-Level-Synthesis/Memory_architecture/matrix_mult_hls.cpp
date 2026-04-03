#include "matrix_mult.h"
#include "matrix.h"
#include <ac_assert.h>

void matrixMultHLS(hls_data_t A[N][N], hls_data_t B[N][N], hls_result_t C[N][N], ac_int<2, false> transpose)
{
    // Check that transpose has legal value
    assert(transpose >= 0 && transpose < 4);

    // Input matrices
    Matrix<hls_data_t, N> A_mat(A);
    Matrix<hls_data_t, N> B_mat(B);

    // Checking bits would suffice, is it possible?
    // if(transpose && 0x01)
    if(transpose == 1 || transpose == 3){
        A_mat.transpose();
    }

    if(transpose == 2 || transpose == 3){
        B_mat.transpose();
    }


    Matrix<hls_result_t, N> C_mat = A_mat * B_mat;
    
    COPY_RESULT_i: for(int i=0; i<N; i++){
        COPY_RESULT_j: for(int j=0; j<N; j++){
            C[i][j] = C_mat.getElement(i, j);
        }
    }
}
