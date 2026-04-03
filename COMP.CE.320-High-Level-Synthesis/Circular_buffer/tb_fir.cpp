// Simple test bench for a FIR filter
// Prints the sequence 1, 3, 7, 15, 23, 27, 29, 30 with the given values

#include "fir_shift_reg.h"
#include <mc_scverify.h>
#include <iostream>

CCS_MAIN(int argc, char *argv[]){
	dType taps[] = {1, 2, 4, 8, 8, 4, 2, 1};
	for (int i = 0; i<N_REGS;i++){
		dType input = 1;
		dType output;
		CCS_DESIGN(fir_circular)(input,taps,output);
		//CCS_DESIGN(fir_shift_reg)(input,taps,output);
		std::cout << "input = " << input
			<< ", output = " << output
			<< std::endl;
	}
	CCS_RETURN(0);
}
