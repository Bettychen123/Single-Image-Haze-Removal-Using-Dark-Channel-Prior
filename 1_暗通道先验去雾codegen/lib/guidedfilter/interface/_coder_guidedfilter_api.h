/*
 * File: _coder_guidedfilter_api.h
 *
 * MATLAB Coder version            : 4.2
 * C/C++ source code generated on  : 14-Mar-2022 10:14:45
 */

#ifndef _CODER_GUIDEDFILTER_API_H
#define _CODER_GUIDEDFILTER_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_guidedfilter_api.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void guidedfilter(emxArray_real_T *b_I, emxArray_real_T *p, real32_T r,
  real32_T eps, emxArray_real_T *q);
extern void guidedfilter_api(const mxArray * const prhs[4], int32_T nlhs, const
  mxArray *plhs[1]);
extern void guidedfilter_atexit(void);
extern void guidedfilter_initialize(void);
extern void guidedfilter_terminate(void);
extern void guidedfilter_xil_shutdown(void);
extern void guidedfilter_xil_terminate(void);

#endif

/*
 * File trailer for _coder_guidedfilter_api.h
 *
 * [EOF]
 */
