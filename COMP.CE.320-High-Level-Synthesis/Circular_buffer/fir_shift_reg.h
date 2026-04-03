#ifndef __fir_shift_reg__
#define __fir_shift_reg__

#include <ac_int.h>

const int WIDTH = 8;
typedef ac_int<WIDTH,false> dType;

const int N_REGS = 8;

void fir_shift_reg(dType din, dType taps[N_REGS], dType &dout);
void fir_circular(dType din, dType taps[N_REGS], dType &dout);
#endif
