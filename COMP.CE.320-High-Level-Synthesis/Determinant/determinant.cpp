// Kaakkolammi Henrik H275961

#include "determinant.h"
#include <ac_assert.h>

#define __synthesis__   // Comment out to see debug prints

// Helper struct for determinant calculation
template<int N_det>
struct determinant_helper
{
	//static_assert(N_det <= 10, "Matrix too big");
	// Return the minor matrix of element (i,j) for determinant calculation
	template<typename T>
	static Matrix<T, N_det-1> get_minor(const Matrix<T, N_det>& matrix, int i, int j)
	{
	    #ifndef __synthesis__
		printf("Call minor N=%u, i=%d, j=%d\n", N_det, i, j);
		#endif
	    
		Matrix<T, N_det-1> minor = Matrix<T, N_det-1>();
		
		// Copy values
		typename Matrix<T, N_det>::index_t source_i = 0;
		for(int dest_i=0; dest_i<N_det-1; dest_i++){
			// Skip ith row
			if (source_i == i){
				source_i++;
			}
			
			typename Matrix<T, N_det>::index_t source_j = 0;
			for(int dest_j=0; dest_j<N_det-1; dest_j++){
				// Skip jth column
				if (source_j == j){
					source_j++;
				}
				
				minor.setElement(dest_i, dest_j, matrix.getElement(source_i, source_j));
				
                #ifndef __synthesis__
				printf("From (%d, %d) set (%u, %u) to %d\n", source_i, source_j, dest_i, dest_j, matrix.getElement(source_i,source_j));
				#endif
				
				source_j++;
			}
			source_i++;
		}
		
		#ifndef __synthesis__
		printf("\n");
		#endif

		return minor;
	}

	// Recursively calculate determinant
	template <typename T>
	static T do_determinant(const Matrix<T, N_det>& param)
	{
		T result = 0;

		for(int i=0; i<N_det; i++){
		    T minor_determinant = determinant_helper<N_det-1>::template do_determinant<T>(get_minor(param, i, 0));
			T determinant = param.getElement(i, 0) * minor_determinant;

			if (i%2 == 0) {
				result += determinant;
			} else {
				result -= determinant;
			}
		}
		
		return result;
	}
};

// Determinant specialization for 1x1 matrix
template<> struct determinant_helper<1>
{
	template <typename T>
	static T do_determinant(const Matrix<T, 1>& param)
	{
		return param.getElement(0,0);
	}
};

// Function for determinant calculation. Uses helper struct to work around partial specialization
template<typename T, int N_det>
T determinant_calc(const Matrix<T, N_det>& param)
{
	return determinant_helper<N_det>::template do_determinant<T>(param);
}

// Top-level function. No modifications needed
void determinant(ac_int<W,S> input[N][N], ac_int<W,S> &result)
{
    Matrix<ac_int<W,S>, N> input_mat(input);
    result = determinant_calc(input_mat);
}
