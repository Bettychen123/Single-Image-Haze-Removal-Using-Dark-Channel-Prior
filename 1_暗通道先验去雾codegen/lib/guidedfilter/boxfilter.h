//
// File: boxfilter.h
//
// MATLAB Coder version            : 4.2
// C/C++ source code generated on  : 14-Mar-2022 10:14:45
//
#ifndef BOXFILTER_H
#define BOXFILTER_H

// Include Files
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "guidedfilter_types.h"

// Function Declarations
extern void b_boxfilter(const emxArray_real32_T *imSrc, float r, emxArray_real_T
  *imDst);
extern void boxfilter(const emxArray_real_T *imSrc, float r, emxArray_real_T
                      *imDst);

#endif

//
// File trailer for boxfilter.h
//
// [EOF]
//
