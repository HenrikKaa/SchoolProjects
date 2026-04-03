// Kaakkolammi Henrik H275961

#include <stdio.h>
#include <stdlib.h>
#include "mc_scverify.h"
#include "determinant.h"


template<int N_det>
void get_minor(int matrix[N_det][N_det], int minor[N_det-1][N_det-1], int i, int j)
{
    //printf("Call minor N=%u, i=%d, j=%d\n", N_det, i, j);
    
    // Copy values
    int source_i = 0;
    for(int dest_i=0; dest_i<N_det-1; dest_i++){
        // Skip ith row
        if (source_i == i){
            source_i++;
        }
        
        int source_j = 0;
        for(int dest_j=0; dest_j<N_det-1; dest_j++){
            // Skip jth column
            if (source_j == j){
                source_j++;
            }
            
            minor[dest_i][dest_j] = matrix[source_i][source_j];

            //printf("From (%d, %d) set (%u, %u) to %d\n", source_i, source_j, dest_i, dest_j, matrix[source_i][source_j]);
            
            source_j++;
        }
        source_i++;
    }
    
    //printf("\n");
}

template<int N_det>
int determinant_cpp(int matrix[N_det][N_det]){
    int result = 0;

    for(int i=0; i<N_det; i++){
        int minor[N_det-1][N_det-1];
        get_minor<N_det>(matrix, minor, i, 0);
        int determinant = matrix[i][0] * determinant_cpp<N_det-1>(minor);;

        if (i%2 == 0) {
            result += determinant;
        } else {
            result -= determinant;
        }
    }
    
    return result;
}

template<>
int determinant_cpp<1>(int matrix[1][1]){
    return matrix[0][0];
}

template<int N_det>
void print_matrix(int matrix[N][N], FILE* file){
    fprintf(file, "Input:\n");
    for(int i=0; i<N_det; i++){
        for(int j=0; j<N_det; j++){
            fprintf(file, "%5d", matrix[i][j]);
        }
        fprintf(file, "\n");
    }
}

CCS_MAIN(int argc, char *argv[])
{
    FILE* output_file;
    output_file = fopen("determinant_output.txt", "a");

    ac_int<W,S> det_hls;
    int det_cpp;

//// Example test
////////////////////
    /*ac_int<W,S> A_hls[3][3] = { {1,0,10},{11,12,0},{33,55,66} };
    int A_cpp[3][3] = { {1,0,10},{11,12,0},{33,55,66} };
    
    CCS_DESIGN(determinant)(A_hls, det_hls);
    det_cpp = determinant_cpp<3>(A_cpp);
    fprintf(output_file, "Example test:\n");
    print_matrix<3>(A_cpp, output_file);
    fprintf(output_file, "Expected %d, HLS %d\n\n", det_cpp, det_hls);
    */

//// Test 5x5
////////////////////
    /*ac_int<W,S> input_5x5_hls[5][5] = { {1,7,-10,2, 9},
                                        {11,12,0,19,-19},
                                        {3,-5,6,8,2},
                                        {3,-10,0,6,2},
                                        {8,-5,-12,9,-5}
                                    };
    int input_5x5_cpp[5][5] = {   {1,7,-10,2, 9},
                                {11,12,0,19,-19},
                                {3,-5,6,8,2},
                                {3,-10,0,6,2},
                                {8,-5,-12,9,-5}
                            };
    det_cpp = determinant_cpp<5>(input_5x5_cpp);
    CCS_DESIGN(determinant)(input_5x5_hls, det_hls);
    fprintf(output_file, "5x5 matrix test:\n");
    print_matrix<5>(input_5x5_cpp, output_file);
    fprintf(output_file, "Expected %d, HLS %d\n\n", det_cpp, det_hls);
    */

//// Test result bit width so that the result is close to the maximum supported value
////////////////////
    ac_int<W,S> input_max_hls[2][2] = { {256-1,-256/2}, {256-1,256/2} };
    int input_max_cpp[2][2] = { {256-1,-256/2}, {256-1,256/2} };

    det_cpp = determinant_cpp<2>(input_max_cpp);
    CCS_DESIGN(determinant)(input_max_hls, det_hls);
    fprintf(output_file, "Bit width test:\n");
    print_matrix<2>(input_max_cpp, output_file);
    fprintf(output_file, "Expected %d, HLS %d\n\n", det_cpp, det_hls);
    

    fclose(output_file);
    CCS_RETURN(0);
}
