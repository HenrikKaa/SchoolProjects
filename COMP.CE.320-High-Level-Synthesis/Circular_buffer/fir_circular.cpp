#include "fir_shift_reg.h"
#include <stdio.h>
#include <stdlib.h>

template<typename T, int N>
class circular_shift
{
public:
// ac_int data width
#define width ac::log2_ceil<N>::val

    // Initialise with DC
    circular_shift(){
        wptr = 0;
        rptr = 0;

        T dummy;
        for(int i=0; i<N; i++){
            mem[i] = dummy;
        }
    }

    // Initialise with data
    circular_shift(T data){
        wptr = 0;
        rptr = 0;

        for(int i=0; i<N; i++){
            mem[i] = data;
        }
    }

    void operator<<(T data){
        mem[wptr++] = data;

        if (wptr == N){
            wptr = 0;
        }
    }

    T operator[](ac_int<width, false> idx){
        rptr = wptr - 1 - idx;

        if (rptr < 0){
            rptr = rptr + N;
        }
        return mem[rptr];
    }

private:
    T mem[N];
    ac_int<width+1, false> wptr;
    ac_int<width+1, true> rptr;
};

void fir_circular(dType din, dType taps[N_REGS], dType &dout){
    // Initialise mem to 0 or the first 7 results will be incorrect
	static circular_shift<dType, N_REGS> mem(0);
	
    mem << din;
    
    dType temp = 0;
	MAC:for(int i=0;i<N_REGS;i++){ //Multiply-accumulate
		temp += taps[i] * mem[i];
	}
	dout = temp;
}

// An attempt at achieving II=4 but tracking the index is buggy
/*
void fir_circular(dType din, dType taps[N_REGS], dType &dout){
	static circular_shift<dType, N_REGS> mem(0);
	static ac_int<ac::log2_ceil<N_REGS>::val, false> counter = 0;
	mem << din;
    
    dType temp = 0;
	MAC:for(int i=0;i<N_REGS;i++){ //Multiply-accumulate
	    // If the index is the input, use that instead
		if (counter == i) {
            temp += taps[i] * din;
	    } else {
		    temp += taps[i] * mem[i];
		}
	}
	counter++;
	dout = temp;
}
*/