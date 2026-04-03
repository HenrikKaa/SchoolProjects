#ifndef _matrix_h
#define _matrix_h

#include "matrix_mult.h"

// Need to use this because log2_ceil<1> returns 0
template<int N_VAL>
struct LOG2_CEIL {
    enum {
        val = N_VAL <= 1 ? 1: N_VAL <= 2 ? 1 : N_VAL <= 4 ? 2 : 
        N_VAL <= 8 ? 3 : N_VAL <= 16 ? 4 : N_VAL <= 32 ? 5 : 
        N_VAL <= 64 ? 6 : N_VAL <= 128 ? 7 : N_VAL <= 256 ? 8 : 
        N_VAL <= 512 ? 9 : N_VAL <= 1024 ? 10 : N_VAL <= 2048 ? 11 :
        N_VAL <= 4096 ? 12 : N_VAL <= 8192 ? 13 : N_VAL <= 16384 ? 14 :
        N_VAL <= 32768 ? 15 : N_VAL <= 65536 ? 16 : 32
    };
};

template<typename element_t, int N>
class Matrix {
public:
    typedef ac_int<LOG2_CEIL<N>::val, false> index_t;

    Matrix();
    Matrix(element_t input_vals[N][N]);

    void setElement(index_t i, index_t j, element_t val);
    element_t getElement(index_t i, index_t j) const;

    void transpose();

    typedef Matrix<
        ac_int<2*element_t::width + LOG2_CEIL<N>::val, true>,
        N> mult_result_t;
    mult_result_t operator*(const Matrix& param);
    
    element_t matrix_[N][N];
};


template<typename element_t, int SIZE>
Matrix<element_t, SIZE>::Matrix(){
    static bool b_dummy = ac::init_array<AC_VAL_0>((element_t*) matrix_, SIZE*SIZE);
}


template<typename element_t, int SIZE>
Matrix<element_t, SIZE>::Matrix(element_t input_vals[SIZE][SIZE]){
    COPY_i: for(int i=0; i<SIZE; i++){
        COPY_j: for(int j=0; j<SIZE; j++){
            matrix_[i][j] = input_vals[i][j];
        }
    }
}


template<typename element_t, int SIZE>
void Matrix<element_t, SIZE>::setElement(index_t i, index_t j, element_t val){
    matrix_[i][j] = val;
}


template<typename element_t, int SIZE>
element_t Matrix<element_t, SIZE>::getElement(index_t i, index_t j) const {
    return matrix_[i][j];
}


template<typename element_t, int SIZE>
void Matrix<element_t, SIZE>::transpose(){
    element_t temp;

    /*printf("Before trans\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            printf("%4d ", matrix_[i][j].to_int());
        }
        printf("\n");
    }
    printf("\n");*/

    // Go through the upper half triangle of the matrix and swap
    // with the lower half. The diagonal doesn't need changing.
    TRANSPOSE_i: for(int i=0; i<SIZE; i++){
        TRANSPOSE_j: for(int j=0; j<i; j++){
            temp = matrix_[i][j];
            matrix_[i][j] = matrix_[j][i];
            matrix_[j][i] = temp;
        }
    }

    /*printf("After trans\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            printf("%4d ", matrix_[i][j].to_int());
        }
        printf("\n");
    }
    printf("\n");*/
}


template<typename element_t, int SIZE>
typename Matrix<element_t, SIZE>::mult_result_t Matrix<element_t, SIZE>::operator*(const Matrix& param){
    mult_result_t result;
    
    MULT_i: for (int i=0; i<SIZE; i++)
    {
        MULT_j: for (int j=0; j<SIZE; j++)
        {
            hls_result_t C_temp = 0;
            MULT_k: for (int k=0; k<SIZE; k++)
            {
                C_temp += matrix_[i][k] * param.getElement(k, j);
            }
            result.setElement(i, j, C_temp);
        }
    }

    return result;
}

#endif
