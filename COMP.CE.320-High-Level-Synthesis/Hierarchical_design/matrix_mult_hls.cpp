#include "matrix_mult.h"
#include "matrix.h"
#include <ac_assert.h>

#pragma hls_design
template<int ID>
void transposeMat(
    ac_channel<chanStruct<hls_data_t, N> > &data_chan,
    bool transpose,
    ac_channel<Matrix<hls_data_t, N> > &matrix_chan)
{
    Matrix<hls_data_t, N> matrix;
    if(data_chan.available(1)){
        matrix = Matrix<hls_data_t, N>(data_chan.read().data);
    }
    
    if(transpose){
        matrix.transpose();
    }
    
    matrix_chan.write(matrix);
}

#pragma hls_design
void multiply(
    ac_channel<Matrix<hls_data_t, N> > &A,
    ac_channel<Matrix<hls_data_t, N> > &B,
    ac_channel<chanStruct<hls_result_t, N> > &C)
{
    Matrix<hls_result_t, N> C_mat;
    if(A.available(1) && B.available(1)){
        C_mat = A.read() * B.read();
    }

    chanStruct<hls_result_t, N> data;
    COPY_RESULT_i: for(int i=0; i<N; i++){
        COPY_RESULT_j: for(int j=0; j<N; j++){
            data.data[i][j] = C_mat.getElement(i, j);
        }
    }
    C.write(data);
}

# pragma hls_design top
void matrixMultHLS(
    ac_channel<chanStruct<hls_data_t, N> > &A,
    ac_channel<chanStruct<hls_data_t, N> > &B,
    ac_channel<chanStruct<hls_result_t, N> > &C,
    bool A_trans, bool B_trans)
{
    static ac_channel<Matrix<hls_data_t, N> > A_inter;
    static ac_channel<Matrix<hls_data_t, N> > B_inter;
    transposeMat<1>(A, A_trans, A_inter);
    transposeMat<2>(B, B_trans, B_inter);

    multiply(A_inter, B_inter, C);
}