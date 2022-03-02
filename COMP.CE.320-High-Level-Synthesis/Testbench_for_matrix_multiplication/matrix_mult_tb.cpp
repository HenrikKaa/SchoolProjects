// TODO: Include some IO library to print into file
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

// TODO: Comment here what the error was in the "matrix_mult_hls" function
/*
There is an error when using transpose 1, it fails all the tests.
Looking at the code, B[j][k] should be B[k][j].
*/

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

void print_matrix(int matrix[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            fprintf(file, "%4d ", matrix[i][j]);
        }
        fprintf(file, "\n");
    }
    fprintf(file, "\n");
}

void compare_results(hls_result_t HLS[N][N], result_t CPP[N][N]) {
    int error = 0;

    // Compare results
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            if (HLS[i][j] != CPP[i][j]) {
                error = 1;
                fprintf(file, "Difference in index [%d][%d]\n", i, j);
            }
        }
    }

    // Print matrices only if verbose output is wanted
    // or there is an error in results
    if (VERBOSE || error) {
        // Write HLS result
        fprintf(file, "\nHLS result\n");
        print_matrix(HLS);

        // Write reference result
        fprintf(file, "Reference result\n");
        print_matrix(CPP);
    }

    if (error) {
        ret = 1;
    } else {
        fprintf(file, "Test passed\n");
    }
    if (VERBOSE || error) {
        fprintf(file, "----------------------------------------------------------------\n");
    }
}

void run_test(hls_data_t A[N][N], hls_data_t B[N][N], result_t C[N][N], hls_result_t C_hls[N][N]) {
    // Convert input arrays to ints for reference
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
        CCS_DESIGN(matrixMultHLS)(A, B, C_hls, t);
        matrixMult(A_CPP, B_CPP, C, t);

        fprintf(file, "Transpose: %d\n", t);
        compare_results(C_hls, C);
    }
}

void test_control() {
    hls_data_t A[N][N];
    hls_data_t B[N][N];
    result_t C[N][N];
    hls_result_t C_hls[N][N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = i + j;
            B[i][j] = i - j;
        }
    }

    fprintf(file, "---Control test---\n");
    if (VERBOSE) {
        fprintf(file, "Input A\n");
        print_matrix < hls_data_t > (A);
        fprintf(file, "Input B\n");
        print_matrix < hls_data_t > (B);
    }
    run_test(A, B, C, C_hls);
}

void test_random() {
    hls_data_t A[N][N];
    hls_data_t B[N][N];
    result_t C[N][N];
    hls_result_t C_hls[N][N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = rand();
            B[i][j] = rand();
        }
    }

    fprintf(file, "---Random test---\n");
    if (VERBOSE) {
        fprintf(file, "Input A\n");
        print_matrix < hls_data_t > (A);
        fprintf(file, "Input B\n");
        print_matrix < hls_data_t > (B);
    }
    run_test(A, B, C, C_hls);
}

void test_identity() {
    hls_data_t A[N][N];
    hls_data_t B[N][N];
    result_t C[N][N];
    hls_result_t C_hls[N][N];

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
        fprintf(file, "Input A\n");
        print_matrix < hls_data_t > (A);
        fprintf(file, "Input B\n");
        print_matrix < hls_data_t > (B);
    }
    run_test(A, B, C, C_hls);
}

void test_min() {
    hls_data_t A[N][N];
    hls_data_t B[N][N];
    result_t C[N][N];
    hls_result_t C_hls[N][N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = MIN_VALUE;
            B[i][j] = MIN_VALUE;
        }
    }

    fprintf(file, "---Min value test---\n");
    if (VERBOSE) {
        fprintf(file, "Input A\n");
        print_matrix < hls_data_t > (A);
        fprintf(file, "Input B\n");
        print_matrix < hls_data_t > (B);
    }
    run_test(A, B, C, C_hls);
}

void test_max() {
    hls_data_t A[N][N];
    hls_data_t B[N][N];
    result_t C[N][N];
    hls_result_t C_hls[N][N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = MAX_VALUE;
            B[i][j] = MAX_VALUE;
        }
    }

    fprintf(file, "---Max value test---\n");
    if (VERBOSE) {
        fprintf(file, "Input A\n");
        print_matrix < hls_data_t > (A);
        fprintf(file, "Input B\n");
        print_matrix < hls_data_t > (B);
    }
    run_test(A, B, C, C_hls);
}

CCS_MAIN(int argc, char * argv[]) // The Catapult testbench should always be invoked with this macro
{
    // TODO:
    // -Create variables to be passed to the design
    // -Open output file named "matrix_mult_output.txt" for writing. Save it in project directory!
    // -Create some test cases and test the two matrix multiplication designs against each other
    // -Random input values are a good idea in some test, as are corner cases
    // 	* For control reasons, in one test case, the input values should be
    //	  A[i][j] = i+j
    //    B[i][j] = i-j

    // Result file

    file = fopen("matrix_mult_output.txt", "w+");
    fprintf(file, "WIDTH: %d\n", WIDTH);
    fprintf(file, "RESULT_WIDTH: %d\n", RESULT_WIDTH);

    test_control();
    fprintf(file, "\n");
    test_random();
    fprintf(file, "\n");
    test_identity();
    fprintf(file, "\n");
    test_min();
    fprintf(file, "\n");
    test_max();
    // TODO:
    // -Print the results of the tests to the "matrix_mult_output.txt" file. Make the file readable and informative!
    // -Close the output file at the end
    // -Give the testbench appropriate return value:
    //  *The testbench should always end with this macro that should return 0 if the design passes the test
    //   and 1 if it fails the test
    // -Comment your testbench!

    fclose(file);
    CCS_RETURN(ret);
}