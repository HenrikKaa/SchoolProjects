// A shift register based FIR filter function

#include "fir_shift_reg.h"

void fir_shift_reg(dType din, dType taps[N_REGS], dType &dout){
	static dType reg[N_REGS]; //Internal register
	dType temp = 0;
	SHIFT:for(int i=N_REGS-1;i>=0;i--) //Implements shifting
	{
		if (i==0)
			reg[i]=din;
		else
			reg[i]=reg[i-1];
	}
	MAC:for(int i=0;i<N_REGS;i++) //Multiply-accumulate
		temp += taps[i]*reg[i];
	dout = temp;
}
		
