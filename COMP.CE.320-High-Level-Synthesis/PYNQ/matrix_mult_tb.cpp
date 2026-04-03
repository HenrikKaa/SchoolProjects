// Henrik Kaakkolammi H275961

#include <stdio.h>
#include <stdlib.h>

// This library must be included to use the macros below
#include "mc_scverify.h"

#include "matrix_mult.h"

// Set to 1 to print all matrices
#define VERBOSE 0

// Result file
FILE * file;
// Return value moved here
int ret = 0;

// Matrices
hls_data_t A[N][N];
hls_data_t B[N][N];
result_t C[N][N];
hls_result_t C_hls[N][N];

// TODO: Comment here what the error was in the "matrix_mult_hls" function
/*
There is an error when using transpose 1, it fails all the tests.
Looking at the code, B[j][k] should be B[k][j].
*/

// Print ac_int type matrix
template < typename T >
void print_matrix(T matrix[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            fprintf(file, "%4d ", matrix[i][j].to_int());
        }
        fprintf(file, "\n");
    }
    fprintf(file, "\n");
}

// Print C++ integer matrix
void print_matrix(int matrix[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            fprintf(file, "%4d ", matrix[i][j]);
        }
        fprintf(file, "\n");
    }
    fprintf(file, "\n");
}

void print_verbose(){
    fprintf(file, "Input A\n");
    print_matrix < hls_data_t > (A);
    fprintf(file, "Input B\n");
    print_matrix < hls_data_t > (B);
}

// Compares the HLS result to golden reference
// Prints the output utilising print_matrix()
// Parameter expect_difference is used for negative test
void compare_results(int expect_difference=0) {
    int error = 0;
    int error_once = 0;   // Used for printing negative test result
    
    // Compare results
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if(expect_difference){
                // One error is enough to print
                if (C_hls[i][j] != C[i][j]) {
                    if(error_once == 0){
                        fprintf(file, "Difference in index [%d][%d]\n", i, j);
                        error_once = 1;
                    }
                }
            } else {
                if (C_hls[i][j] != C[i][j]) {
                    error = 1;
                    fprintf(file, "Difference in index [%d][%d]\n", i, j);
                }
            }
        }
    }
    // If there was no difference the negative test fails
    if(expect_difference && !error_once){
        error = 1;
    }

    // Print matrices only if verbose output is wanted or there is an error in the results
    if (VERBOSE || error) {
        // Write HLS result
        fprintf(file, "\nHLS result\n");
        print_matrix(C_hls);

        // Write reference result
        fprintf(file, "Reference result\n");
        print_matrix(C);
    }

    if (error && !expect_difference) {
        fprintf(file, "Test failed\n");
        ret = 1;
    } else {
        fprintf(file, "Test passed\n");
    }
    if (VERBOSE || error) {
        fprintf(file, "----------------------------------------------------------------\n");
    }
}

// Tests HLS against golden reference with all transposes
void run_test() {
    // Convert input arrays to ints for reference
    // Note that this hides ac_int overflow
    int A_CPP[N][N];
    int B_CPP[N][N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A_CPP[i][j] = A[i][j].to_int();
            B_CPP[i][j] = B[i][j].to_int();
        }
    }

    // Test all transposes
    for (int t = 0; t < 4; t++) {
        ac_int<2, false> transpose = t;
        CCS_DESIGN(matrixMultHLS)(A, B, C_hls, transpose);
        matrixMult(A_CPP, B_CPP, C, t);

        fprintf(file, "Transpose: %d\n", t);
        compare_results();
    }
    fprintf(file, "\n");
}

// Included control test
void test_control() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = i + j;
            B[i][j] = i - j;
        }
    }

    fprintf(file, "---Control test---\n");
    if (VERBOSE) {
        print_verbose();
    }
    run_test();
}

// Tests using random values in the range
void test_random() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = rand();
            B[i][j] = rand();
        }
    }

    fprintf(file, "---Random test---\n");
    if (VERBOSE) {
        print_verbose();
    }
    run_test();
}

// Tests identity matrices as A and B input
void test_identity() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (i == j) {
                A[i][j] = 1;
                B[i][j] = 1;
            } else {
                A[i][j] = 0;
                B[i][j] = 0;
            }
        }
    }

    fprintf(file, "---Identity test---\n");
    if (VERBOSE) {
        print_verbose();
    }
    run_test();
}

// Fills A and B with the minimum value the ac_int can have
void test_min() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = MIN_VALUE;
            B[i][j] = MIN_VALUE;
        }
    }

    fprintf(file, "---Min value test---\n");
    if (VERBOSE) {
        print_verbose();
    }
    run_test();
}

// Fills A and B with the maximum value the ac_int can have
void test_max() {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = MAX_VALUE;
            B[i][j] = MAX_VALUE;
        }
    }

    fprintf(file, "---Max value test---\n");
    if (VERBOSE) {
        print_verbose();
    }
    run_test();
}

// Fills A and B with too big values for ac_int to handle
// Negative test, this should fail
void test_limit() {
    int A_CPP[N][N];
    int B_CPP[N][N];

    // Using MAX_VALUE+1 hides the error in some cases, eg. -32 and 32 multiplied even times
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = MAX_VALUE+1;
            B[i][j] = MAX_VALUE+2;
            A_CPP[i][j] = MAX_VALUE+1;
            B_CPP[i][j] = MAX_VALUE+2;
        }
    }

    fprintf(file, "---Limit value test---\n");
    if (VERBOSE) {
        print_verbose();
    }

    // Test all transposes
    for (int t = 0; t < 4; t++) {
        ac_int<2, false> transpose = t;
        CCS_DESIGN(matrixMultHLS)(A, B, C_hls, transpose);
        matrixMult(A_CPP, B_CPP, C, t);

        fprintf(file, "Transpose: %d\n", t);
        compare_results(1);
    }
}

CCS_MAIN(int argc, char * argv[]) // The Catapult testbench should always be invoked with this macro
{
    // File, matrices and return value are global to simplify the code
    
    file = fopen("matrix_mult_output.txt", "w+");
    fprintf(file, "DATA WIDTH: %d\n", WIDTH);
    fprintf(file, "RESULT WIDTH: %d\n", RESULT_WIDTH);

    test_control();
    test_random();
    test_identity();
    test_min();
    test_max();
    test_limit();

    fclose(file);
    CCS_RETURN(ret);
}
